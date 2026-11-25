# Use gpg-agent as the SSH agent on workstations. Skipped inside SSH sessions
# so a forwarded agent is never overridden.
if [[ -z $SSH_CONNECTION ]] && (( $+commands[gpgconf] )); then
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
fi

# Point pinentry at the current terminal before commands that may need the key.
if (( $+commands[gpg-connect-agent] )); then
  export GPG_TTY=$TTY
  _l0th1_update_gpg_tty() {
    case $1 in
      ssh*|scp*|rsync*|git*|gpg*)
        export GPG_TTY=$TTY
        gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
        ;;
    esac
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook preexec _l0th1_update_gpg_tty
fi
