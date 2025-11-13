#!/bin/bash
# ── animated-neofetch.sh ────────────────────────────────
# Description: Animated ASCII frames + fastfetch system info
# Usage: ./animated-neofetch.sh [delay]
# @pewdiepie-archdaemon

# pass delay as 0 to not clear upon exit

delay=${1:-0.1}
freeze=0
if [ "$delay" -eq 0 ]; then
  freeze=1
  delay="0.1"
fi
ascii_row=3
ascii_col=3
text_row=2
text_col=60

clear
tput cup $text_row $text_col
fastfetch

tput civis
trap 'tput cnorm; clear; exit' INT TERM

while true; do
  for frame in $(ls ~/.config/fish/functions/fastfetch_animated/frames/*.txt | sort -V); do
    tput cup $ascii_row $ascii_col
    cat $frame

    # Wait a little, but also check if user pressed a key
    read -t $delay -n 1 key && {
      tput cnorm
      echo $f_flag
      if [[ $freeze -eq 0 ]]; then
        clear
        {
          sleep .1
          tmux send-keys -t . "$key"
        } &
      fi
      exit
    }
  done
done
