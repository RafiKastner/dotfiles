function czf
    test (count $argv) -gt 0; and set search $argv[1]
    fd . ~ --hidden --exclude .git | fzf-tmux --reverse --height 40% --query="$search" | xargs code
end