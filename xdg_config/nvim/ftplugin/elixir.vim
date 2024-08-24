setlocal foldmethod=syntax
setlocal indentexpr=
" Atom map to string map
vmap [m :s/\(\w\+\):/"\1" =>/g<cr>
map [m :s/\(\w\+\):/"\1" =>/g<cr>
" String map to atom map
vmap ]m :s/"\(\w*\)" =>/\1:/g<cr>
map ]m :s/"\(\w*\)" =>/\1:/g<cr>
" One line functin to multi
nn ]1 :s/), do:/) do\r/<cr>normal }Aend<cr>
nn [1 :s/) do$\n/), do:/<cr>

nmap [w <plug>(elixir-refactor-pipe)
nmap ]w <plug>(elixir-refactor-unpipe)

function s:exunit_post_quickfix() abort
  let apps = globpath(getcwd(), 'apps/*')
  let apps = split(apps, '\n')
  let apps = map(apps, { _, x -> fnamemodify(x, ':t') })

  let qflist = getqflist()

  for i in qflist
    if i.valid != 1
      continue
    end

    " Match app test stacktraces
    " Example:
    "  test/web/controllers/account_controller_test.exs:21: (test)
    let pattern = '\(test/.*/.*\):\d\+: (test)'
    let list = matchlist(i.text, pattern)

    if len(list) > 0
      let path = list[1]
      let path = globpath('./apps/*', path)
      let i.bufnr = 0
      let i.filename = path
      let i.text = ''
      continue
    end

    " Match stacktraces.
    "
    " Example:
    "  (web 0.1.0) lib/web/templates/layout/app.html.eex:16: Web.LayoutView."app.html"/1
    "  (phoenix 1.4.17) lib/phoenix/view.ex:410: Phoenix.View.render_to_iodata/3
    "  (phoenix 1.4.17) lib/phoenix/controller.ex:776: Phoenix.Controller.__put_render__/5
    let pattern = '(\(\w\+\) \S\+) \(.*\):\d\+: \(.*\)'
    let list = matchlist(i.text, pattern)

    if len(list) > 0
      let mod = list[1]
      let path = list[2]
      let fun_name = list[3]

      if index(apps, mod) >= 0
        let path = join(['apps', mod, path], '/')
      else
        let path = join(['deps', mod, path], '/')
      end

      let i.bufnr = 0
      let i.filename = path
      let i.module = mod
      let i.text = fun_name
      continue
    end
    " let i.valid = 0
  endfor

  call setqflist(qflist)
endfunction

command! -buffer ExunitCgetfile :call s:exunit_cgetfile()

command! -nargs=* MixCompile :compiler elixir | make <args><cr>
command! -nargs=* MixTest :compiler exunit | make <args><cr>
