function extract --description "Extract any archive"
    switch $argv[1]
        case '*.tar.gz' '*.tgz'; tar xzf $argv[1]
        case '*.tar.xz';         tar xJf $argv[1]
        case '*.tar.bz2';        tar xjf $argv[1]
        case '*.tar.zst';        tar --zstd -xf $argv[1]
        case '*.zip';            unzip $argv[1]
        case '*.7z';             7z x $argv[1]
        case '*';                echo "unknown archive: $argv[1]"
    end
end
