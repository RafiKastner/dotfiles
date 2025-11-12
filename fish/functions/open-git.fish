function open-git
    if test -z (git remote)
        echo "This repository has no remotes"
        return
    end

    set url (git remote get-url origin)

    if string match -gq "*github.com*" $url
        if string match -gq "git@*" $url
            set url (string replace "git@" "" $url)
            set url (string replace ":" "/" "$url")
            echo $url
            set url "https://$url"
        end
        open "$url"
    else
        echo "This repository is not hosted on GitHub"
    end
end
