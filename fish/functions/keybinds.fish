function keybinds
    set bold $(tput bold)
    set normal $(tput sgr0)
    echo -e "$bold Bindings$normal"\
    \n \t"CTRL-R -- Get command from history"\
    \n \t"CTRL-F -- Search for any file or directory"\
    \n \t"CTRL-Alt-L -- Search Git log. Returns hashes of selected commits"\
    \n \t"CTRL-Alt-S -- Search Git status. Outputs relative paths of selected lines"\
    \n \t"CTRL-Alt-P -- Search processes. Outputs pids selected processes"\
    \n \t"CTRL-V -- Search all shell variables currently in scope"\
    \n \n \t"CTRL-C -- Kill current foreground process running in terminal"\
    \n \t"CTRL-Z -- Suspend current foreground process running in terminal"\
    \n \t"CTRL-L -- Clears the screen without deleting like clear command"\
    \n \t"CTRL-A -- Moves cursor to the beginning of the line"\
    \n \t"CTRL-E -- Moves cursor to the end of the line"\
    \n \t"CTRL-U -- Completely erase line"\
    \n \t"CTRL-K -- Erase part of the line after cursor"\
    \n \t"CTRL-W -- Erase word before cursor"\
    \n \t"CTRL-Y -- Paste the last thing you cut from clipboard"\
    \n \t"CTRL-P / Up arrow -- Previous command"\
    \n \t"CTRL-N / Down arrow -- Next command in history"
end