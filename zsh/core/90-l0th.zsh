# Update notice. A background `l0th1 check` runs `git fetch` at most once a day;
# startup only reads its cached result, so there's no network wait here.
# Disable with L0TH1_UPDATE_CHECK=0 in ~/.config/l0th1/machine.zsh.
() {
  [[ ${L0TH1_UPDATE_CHECK:-1} == 1 && -o interactive ]] || return
  local stamp=$L0TH1_STATE/last-check behind=$L0TH1_STATE/behind
  local -a stale

  if [[ -r $behind ]] && (( $(<$behind) > 0 )); then
    print -P "%F{yellow}l0th1:%f $(<$behind) new commit(s) upstream - run %Bl0th1 update%b"
  fi

  stale=( $stamp(N.mh+24) )
  if [[ ! -e $stamp || -n $stale ]]; then
    mkdir -p $L0TH1_STATE && : >| $stamp
    $L0TH1_PUBLIC/bin/l0th1 check &>/dev/null &!
  fi
}
