# Plugins via antidote (https://github.com/mattmc3/antidote).
# All layers' plugins.txt files are merged into one list. The static bundle is
# rebuilt only when that list changes, so a normal startup sources one file.

export ANTIDOTE_HOME=$L0TH1_DATA/plugins
# Always use our oh-my-zsh clone, even if a parent shell exported another $ZSH
# (use-omz keeps an existing $ZSH).
export ZSH=$ANTIDOTE_HOME/ohmyzsh/ohmyzsh
zstyle ':antidote:bundle' use-friendly-names on

() {
  local antidote=$L0TH1_DATA/antidote
  local list=$L0TH1_CACHE/plugins.txt static=$L0TH1_CACHE/plugins.zsh
  local f wanted="" lockfd

  for f in $L0TH1_PLUGIN_FILES; do wanted+="$(<$f)"$'\n'; done
  while [[ $wanted == *$'\n' ]]; do wanted=${wanted%$'\n'}; done

  # Uses the locals above (zsh scoping is dynamic).
  _l0th1_plugins_ready() {
    [[ -r $antidote/antidote.zsh && -s $static && -r $list && -d $ANTIDOTE_HOME ]] &&
      [[ "$(<$list)" == "$wanted" ]]
  }

  if ! _l0th1_plugins_ready; then
    if (( ! $+commands[git] )); then
      print -u2 "l0th1: git not found, zsh plugins disabled"
      return
    fi
    # Several shells can start at once on a fresh machine (terminal tabs, web
    # terminals): one downloads, the others wait for it instead of colliding.
    mkdir -p $L0TH1_CACHE
    zmodload zsh/system
    : >> $L0TH1_CACHE/plugins.lock   # flock needs an existing file
    if ! zsystem flock -t 300 -f lockfd $L0TH1_CACHE/plugins.lock 2>/dev/null; then
      print -u2 "l0th1: timed out waiting for another shell to install plugins"
      return
    fi
    if ! _l0th1_plugins_ready; then
      if [[ ! -r $antidote/antidote.zsh ]]; then
        print -P "%F{yellow}l0th1:%f installing antidote..."
        rm -rf $antidote
        if ! git clone --quiet --depth=1 https://github.com/mattmc3/antidote.git $antidote; then
          zsystem flock -u $lockfd
          return
        fi
      fi
      fpath=( $antidote/functions $fpath )
      autoload -Uz antidote
      print -P "%F{yellow}l0th1:%f building plugin bundle..."
      if antidote bundle <<<"$wanted" >| $static.tmp; then
        mv $static.tmp $static
        print -r -- "$wanted" >| $list
      else
        rm -f $static.tmp
        zsystem flock -u $lockfd
        return
      fi
    fi
    zsystem flock -u $lockfd
  fi

  fpath=( $antidote/functions $fpath )
  autoload -Uz antidote
  source $static
}
unfunction _l0th1_plugins_ready 2>/dev/null
