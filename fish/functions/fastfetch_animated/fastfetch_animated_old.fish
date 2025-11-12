function fastfetch_animated
    tput civis
    trap 'tput cnorm' EXIT
    fastfetch
    tput cup 1 1
    while true
        for file in ~/.config/fish/functions/fastfetch_animated/frames/*
            tput cup 6 1
            cat $file
            sleep .1
        end
    end
end
