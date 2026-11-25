#!/usr/bin/env zsh
# Tests for zsh/core/bin/{rm,tar}_throttled. Runs on macOS and Linux; uses a
# throwaway directory and never touches anything else.
# Usage: test/throttled-tools.zsh
emulate -R zsh
setopt pipe_fail
bin=${0:A:h:h}/zsh/core/bin
export PATH=$bin:$PATH
work=$(mktemp -d "${TMPDIR:-/tmp}/l0th1-test.XXXXXX")
export TMPDIR=$work/tmp; mkdir -p $TMPDIR
trap 'rm -rf $work' EXIT
fails=0
check() { if eval "$2"; then print "  ok   $1"; else print "  FAIL $1"; fails=$((fails+1)); fi }
leftover_lists() { local -a l=( $TMPDIR/rm_throttled.*(N) ); print $#l }

mktree() {
  rm -rf $1; mkdir -p $1/a/b/c $1/'with space' $1/empty/nested
  for i in {1..250}; do : > $1/a/b/c/f$i; done
  print hi > $1/'with space'/'x y'
  print -n > $1/$'new\nline'
  mkfifo $1/a/fifo
  print keep > $work/outside; ln -s $work/outside $1/a/link-out
}

print "rm_throttled"
check "refuses /"            '! rm_throttled -y / 2>/dev/null'
check "refuses top-level"    '! rm_throttled -y /usr 2>/dev/null'
check "refuses \$HOME"       '! rm_throttled -y $HOME 2>/dev/null'
check "refuses non-dir"      '! rm_throttled -y $work/nope 2>/dev/null'
check "rejects bad batch"    '! rm_throttled -y -b x $work 2>/dev/null'
mktree $work/t1
out=$(rm_throttled -n $work/t1 2>&1)
check "dry run counts 254"   '[[ $out == *"Found 254 files."* ]]'
check "dry run deletes none" '[[ -e $work/t1/a/b/c/f1 ]]'
check "needs -y off a tty"   '! rm_throttled $work/t1 </dev/null >/dev/null 2>&1 && [[ -e $work/t1/a/b/c/f1 ]]'
check "deletes whole tree"   'rm_throttled -y -b 40 -s 0 $work/t1 >/dev/null 2>&1 && [[ ! -e $work/t1 ]]'
check "keeps symlink target" '[[ $(<$work/outside) == keep ]]'
check "no temp list left"    '[[ $(leftover_lists) == 0 ]]'

print "tar_throttled"
mktree $work/src
check "refuses bad ext"      '! tar_throttled -r 0 $work/x.zip $work/src 2>/dev/null'
check "refuses inside src"   '! tar_throttled -r 0 $work/src/x.tar $work/src 2>/dev/null'
check "plain .tar"           'tar_throttled -r 0 $work/a.tar $work/src >/dev/null 2>&1'
check "stored by basename"   '[[ $(tar -tf $work/a.tar | grep -c "^src/a/b/c/f") == 250 ]]'
check "no .partial left"     '[[ ! -e $work/a.tar.partial ]]'
check "refuses existing"     '! tar_throttled -r 0 $work/a.tar $work/src 2>/dev/null'
check ".tar.gz + verify"     'tar_throttled -r 0 -V $work/a.tar.gz $work/src >/dev/null 2>&1 && gzip -t $work/a.tar.gz'
if (( $+commands[zstd] )); then
  check ".tar.zst + verify"  'tar_throttled -r 0 -V $work/a.tar.zst $work/src >/dev/null 2>&1 && zstd -tq $work/a.tar.zst'
fi
if (( $+commands[pv] )); then
  check "rate-capped .tar"   'tar_throttled -r 10M $work/b.tar $work/src >/dev/null 2>&1 && [[ -s $work/b.tar ]]'
  # Interrupt a slow run: the partial archive must be removed.
  mkdir -p $work/big; head -c 4000000 /dev/urandom > $work/big/blob
  tar_throttled -r 200k $work/c.tar $work/big >/dev/null 2>&1 &
  pid=$!; sleep 2; kill -INT $pid; wait $pid; rc=$?
  check "Ctrl-C removes .partial" '[[ $rc != 0 && ! -e $work/c.tar.partial && ! -e $work/c.tar ]]'
else
  check "needs pv for a cap" 'msg=$(tar_throttled $work/b.tar $work/src 2>&1); (( $? != 0 )) && [[ $msg == *"pv is needed"* && ! -e $work/b.tar ]]'
fi
if (( EUID != 0 )); then
  mktree $work/bad; chmod 000 $work/bad/a/b
  check "failed tar cleans up" '! tar_throttled -r 0 $work/d.tar $work/bad >/dev/null 2>&1 && [[ ! -e $work/d.tar.partial && ! -e $work/d.tar ]]'
  chmod 755 $work/bad/a/b
fi

(( fails )) && { print "$fails FAILED"; exit 1 }
print "PASS"
