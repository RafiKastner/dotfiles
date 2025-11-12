# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/anaconda3/bin/conda
    eval /opt/anaconda3/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/opt/anaconda3/etc/fish/conf.d/conda.fish"
        . "/opt/anaconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /opt/anaconda3/bin $PATH
    end
end
# <<< conda initialize <<<

set -gx EDITOR nvim

# Set up nvm
set -x NVM_DIR $HOME/.nvm

# Source nvm with bass
function nvm
    bass source $NVM_DIR/nvm.sh --no-use ';' nvm $argv
end

# Add the node versions to path -- doesn't work dont think
# set -x PATH $NVM_DIR/versions/node/(nvm current)/bin $PATH

# Load the default Node version
nvm use default >/dev/null

# add function subdirs to fish_function_path
set fish_function_path (path resolve $__fish_config_dir/functions/*/) $fish_function_path

# Initialize commands
starship init fish | source
zoxide init fish | source
fzf --fish | source

alias fzf="fzf --style minimal --preview 'fzf-preview.sh {}'"
alias preview="_fzf_preview_file"

function ff
    aerospace list-windows --all | fzf --no-preview --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
end

alias og="open-git"

alias fastfetch="bash ~/.config/fish/functions/fastfetch_animated/animated_fastfetch.sh"

# Unbind default fzf keybinds for better fzf.fish interface
bind --erase \cr
bind --erase \ct
bind --erase \ec

# Fzf.fish keybinds
fzf_configure_bindings --directory=\cf

alias spinner="run-script zsh spinner.zsh"
alias donut="python ~/Programming/Projects/animations/donut.py -i '38;5;24' '38;5;26' '38;5;39' -1 .7 -s .85 -a"

set -x TMUX_CONF ~/.config/tmux/tmux.conf

# Have one always-running tmux session
# if not set -q TMUX
#     tmux attach-session -t main || tmux new-session -s main
# end

# Navi
set -gx NAVI_SHELL fish

# --- Yazi Setup ---
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function show
    sketchybar --trigger show_workspace WORKSPACE_NAME=$argv[1] SHOULD_DISPLAY=$argv[2]
end

# pnpm
set -gx PNPM_HOME /Users/rafikastner/Library/pnpm
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
