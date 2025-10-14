function cf
    test (count $argv) -gt 0; and set search $argv[1]
    set selection (fd . ~ --absolute-path --hidden --follow | fzf --height 40% --reverse --query="$search")
    echo $selection
    if test -z $selection
        echo No selection made
    end
    if test -f $selection
        # takes file path string and deletes file from the end
        # s/ replaces (.*\) anything \ that ends with backslash // and replaces /1  
        # with those characters but a space not the excluded backslash
        #;s/ then replaces  .* anything starting with space // with nothing
        set selection $(echo $selection | sed 's/\(.*\)\//\1 /;s/ .*//')
    end
    test -n "$selection"; and cd $selection
end
