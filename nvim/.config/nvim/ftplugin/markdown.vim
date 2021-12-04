command! MarkdownPreview :!pandoc --to html -o %:r.html && open %:r.html %

map <localleader>p :MarkdownPreview<cr>
