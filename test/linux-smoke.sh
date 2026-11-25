#!/usr/bin/env bash
# Fresh-machine test in a Linux container: install as a server and as a
# workstation, start an interactive zsh and vim, and fail on any error output.
# Usage: test/linux-smoke.sh [image]   (default: debian:stable-slim)
set -euo pipefail
repo=$(cd "$(dirname "$0")/.." && pwd)
image=${1:-debian:stable-slim}

docker run --rm -i -v "$repo:/src:ro" "$image" bash -s <<'IN'
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq >/dev/null
apt-get install -y -qq zsh git vim ca-certificates >/dev/null
useradd -m -s /bin/zsh tester
cp -r /src /home/tester/l0th1-dot-env && chown -R tester: /home/tester/l0th1-dot-env
su - tester -c 'bash -s' <<'USER'
set -euo pipefail
cd ~
for profiles in "server" "desktop dev"; do
  echo "=== profiles: $profiles"
  ~/l0th1-dot-env/bin/l0th1 install --host testbox --profiles "$profiles" --private none --no-vim
  zsh -ic 'exit' >/dev/null 2>&1                   # first start: clones antidote + plugins
  out=$(zsh -ic 'whence -w pathadd gfpush l0th1; print -r -- "theme=$ZSH_THEME"' 2>&1)
  echo "$out"
  if grep -qiE 'error|not found|no such' <<<"$out" && ! grep -q 'gfpush: none' <<<"$out"; then
    echo "FAIL: unexpected output"; exit 1
  fi
done
~/.local/bin/l0th1 install --plugins >/dev/null      # vim link + plugin install
again=$(~/.local/bin/l0th1 install 2>&1)
if grep -qE 'refreshed|backed up|wrote' <<<"$again"; then echo "FAIL: re-install not idempotent: $again"; exit 1; fi
echo "re-install idempotent"
if vim -N -u ~/.vim/vimrc -i NONE -es -c 'if !exists("g:plugs") || g:colors_name !=# "edge" | cquit | endif' -c 'qa!' </dev/null; then
  echo "vim ok"
else
  echo "FAIL: vim config did not load"; exit 1
fi
~/.local/bin/l0th1 doctor
USER
IN
echo "PASS"
