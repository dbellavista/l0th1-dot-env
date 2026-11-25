# l0th1-dot-env

My zsh and vim setup, deployed to every machine I use: laptops, desktops,
servers, and (vim only) Windows.

- **This repo (public):** the base config, general functions, OS and profile layers, and the `l0th1` tool.
- **`l0th1-dot-env-private` (private, optional):** work functions, per-host overrides, and the machine list.
- **Each machine (in no repo):** its identity in `~/.config/l0th1/machine.zsh`, and secrets or one-off tweaks in `~/.config/l0th1/local/`.

## Layers

Config is built from layers. Each one is an optional directory, and later layers win:

```
public   zsh/core
public   zsh/os/<darwin|linux>
public   zsh/profiles/<profile>          for each profile in L0TH1_PROFILES
private  zsh/common
private  zsh/profiles/<profile>
private  zsh/hosts/<L0TH1_HOST>
machine  ~/.config/l0th1/local
```

A layer directory can contain:

| Path | What happens |
|---|---|
| `functions/<name>` | autoloaded function (file body = function body). Same name in a later layer **replaces** it. `_name` files are completions. |
| `plugins.txt` | [antidote](https://github.com/mattmc3/antidote) bundle lines; all layers are merged into one static bundle, rebuilt only when the list changes |
| `*.zsh` | sourced in lexical order, after every layer's functions are available |

Vim follows the same idea: `vim/core/*.vim`, then
`<private>/vim/{common,profiles/<p>,hosts/<host>}/*.vim` (each may also have a
`plugins.vim` with extra `Plug` lines), then `~/.vimrc.local`.

### Profiles

| Profile | For | Adds |
|---|---|---|
| `desktop` | personal workstations | gpg-agent as SSH agent (not inside SSH sessions), autojump, vscode |
| `dev` | anywhere I write code | python/pip/rust/... OMZ plugins, `i`/`itest`/`gfpush`; vim YouCompleteMe, ALE, jsdoc (these need build tools) |
| `server` | headless boxes | base only |
| `work`, `android` | *(private repo)* | AWS/jump-host helpers, scrcpy/adb helpers |

A profile name works if a directory exists for it in either repo.

## Install

New machine (zsh and git required):

```sh
git clone https://github.com/dbellavista/l0th1-dot-env.git ~/.local/share/l0th1/public
# optional, on machines with access to it:
git clone git@github.com:dbellavista/l0th1-dot-env-private.git ~/.local/share/l0th1/private

~/.local/share/l0th1/public/bin/l0th1 install --host <name> --profiles "desktop dev"
```

`install`:

- writes `~/.config/l0th1/machine.zsh`
- puts a small managed block in `~/.zshrc`. Lines that other tools append below it stay on that machine.
- links `~/.vim` to `vim/` and `~/.local/bin/l0th1` to `bin/l0th1`
- on first vim install, runs `:PlugInstall`

Anything it replaces is moved to `~/.local/state/l0th1/backups/<timestamp>/`. Running it again is safe.

The private repo is found automatically next to the public one
(`../l0th1-dot-env-private`) or at `~/.local/share/l0th1/private`. Pass
`--private DIR` or `--private none` to override.

### Windows (vim only)

```bat
git clone https://github.com/dbellavista/l0th1-dot-env.git %USERPROFILE%\l0th1-dot-env
echo source ~/l0th1-dot-env/vim/vimrc> %USERPROFILE%\_vimrc
vim +PlugInstall +qa
```

The vimrc adds itself to `runtimepath` and keeps plugins/undo in
`%LOCALAPPDATA%\vim`. Set profiles with `let g:l0th1_profiles = ['dev']` above
the `source` line. Machine-only settings go in `~/_vimrc.local`.

## Updating

| Command | Does |
|---|---|
| `l0th1 update` | `git pull --ff-only` both repos, refresh the `~/.zshrc` block and links |
| `l0th1 update --plugins` | also `antidote update` and `:PlugUpdate` |
| `l0th1 push-all` | runs `l0th1 update` over SSH on every host in the private `machines.txt` (`--dry-run`, `--forward-agent`) |
| `l0th1 status` / `l0th1 doctor` | machine identity and repo state / installation checks |

Shells notice upstream changes by themselves: a background `git fetch` runs at
most once a day and the next shell prints
`l0th1: N new commit(s) upstream - run l0th1 update`. Updates are never applied
automatically, because these files run as code in every shell. Turn the notice off with
`L0TH1_UPDATE_CHECK=0` in `machine.zsh`.

Typical flow: edit here, commit, push, then `l0th1 push-all` (or let each
machine show the notice).

## Testing

```sh
test/linux-smoke.sh            # fresh Debian container: server + desktop/dev installs, zsh and vim
```

## Layout

```
bin/l0th1                 install/update/status/doctor/push-all
zsh/zshrc                entrypoint (layer loader)
zsh/core/                options, PATH, plugins (antidote), tools, update notice, base functions
zsh/os/                  darwin.zsh, linux.zsh
zsh/profiles/            desktop/, dev/, server/
vim/vimrc                entrypoint
vim/core/                options, plugins, ui, editing, filetypes, commands
vim/{autoload,colors,keymap,templates}/
```
