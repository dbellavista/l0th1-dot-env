# Settings that oh-my-zsh lib/plugins read when they load, so they must come
# before 20-plugins.zsh.

CASE_SENSITIVE=true
DISABLE_AUTO_TITLE=true

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true
VI_MODE_CURSOR_NORMAL=2
VI_MODE_CURSOR_VISUAL=6
VI_MODE_CURSOR_INSERT=6
VI_MODE_CURSOR_OPPEND=0

: ${EDITOR:=vim}
export EDITOR

autoload -Uz zmv

# Prompt theme. use-omz loads it on the first prompt, so any later layer can
# still change ZSH_THEME; machine.zsh can set L0TH1_ZSH_THEME instead.
if [[ $TERM_PROGRAM == vscode ]]; then
  ZSH_THEME=imajes
else
  ZSH_THEME=${L0TH1_ZSH_THEME:-fino-time}
fi

# oh-my-zsh is updated by `l0th1 update --plugins`, never by its own prompt.
zstyle ':omz:update' mode disabled
