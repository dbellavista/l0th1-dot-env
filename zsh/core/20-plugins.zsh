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
  local f wanted=""

  if [[ ! -r $antidote/antidote.zsh ]]; then
    if (( ! $+commands[git] )); then
      print -u2 "l0th1: git not found, zsh plugins disabled"
      return
    fi
    print -P "%F{yellow}l0th1:%f installing antidote..."
    git clone --quiet --depth=1 https://github.com/mattmc3/antidote.git $antidote || return
  fi
  fpath=( $antidote/functions $fpath )
  autoload -Uz antidote

  for f in $L0TH1_PLUGIN_FILES; do wanted+="$(<$f)"$'\n'; done
  while [[ $wanted == *$'\n' ]]; do wanted=${wanted%$'\n'}; done

  if [[ ! -s $static || ! -r $list || ! -d $ANTIDOTE_HOME || "$(<$list)" != "$wanted" ]]; then
    mkdir -p $L0TH1_CACHE
    print -r -- "$wanted" >| $list
    print -P "%F{yellow}l0th1:%f building plugin bundle..."
    antidote bundle <$list >| $static || { rm -f $static; return }
  fi
  source $static
}
