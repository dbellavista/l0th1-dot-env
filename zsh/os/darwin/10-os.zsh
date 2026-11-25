# macOS

# Homebrew: login shells get it from ~/.zprofile; this covers non-login shells.
if [[ -z $HOMEBREW_PREFIX ]]; then
  for _l0th1_brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x $_l0th1_brew ]] && { eval "$($_l0th1_brew shellenv)"; break }
  done
  unset _l0th1_brew
fi

path=(
  ${HOMEBREW_PREFIX:-/opt/homebrew}/opt/gnu-sed/libexec/gnubin(N/)
  $path
  $HOME/Library/Android/sdk/platform-tools(N/)
)

[[ -x /Applications/VLC.app/Contents/MacOS/VLC ]] &&
  alias cvlc='/Applications/VLC.app/Contents/MacOS/VLC -I dummy'
