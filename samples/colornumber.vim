" Color test: Save this file, then enter ':so %'
" Then enter one of following commands:
"  :VimColorTest "(for console/terminal Vim)
"  :GvimColorTest "(for GUI gvim)
function! VimColorTest(outfile, fgend, bgend)
let result = []
for fg in range(a:fgend)
for bg in range(a:bgend)
let kw = printf('%-7s', printf('c_%d_%d', fg, bg))
let h = printf('hi %s ctermfg=%d ctermbg=%d', kw, fg, bg)
let s = printf('syn keyword %s %s', kw, kw)
call add(result, printf('%-32s | %s', h, s))
endfor
endfor
call writefile(result, a:outfile)
execute 'edit '.a:outfile
source %
endfunction
" Increase numbers in next line to see more colors.
command! VimColorTest call VimColorTest('vim-color-test.tmp', 12, 16)

function! GvimColorTest(outfile)
let result = []
for red in range(0, 255, 16)
for green in range(0, 255, 16)
for blue in range(0, 255, 16)
let kw = printf('%-13s', printf('c_%d_%d_%d', red, green, blue))
let fg = printf('#%02x%02x%02x', red, green, blue)
let bg = '#fafafa'
let h = printf('hi %s guifg=%s guibg=%s', kw, fg, bg)
let s = printf('syn keyword %s %s', kw, kw)
call add(result, printf('%s | %s', h, s))
endfor
endfor
endfor
call writefile(result, a:outfile)
execute 'edit '.a:outfile
source %
endfunction
command! GvimColorTest call GvimColorTest('gvim-color-test.tmp')
