function md -a file
    pandoc -t asciidoc $file | bat -l asciidoc
end
