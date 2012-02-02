"   This is my personal .vimrc, I don't recommend you copy it, just
"   use the "   pieces you want(and understand!).  When you copy a
"   .vimrc in its entirety, weird and unexpected things can happen.
"
"   If you find an obvious mistake hit me up at:
"   http://robertmelton.com/contact (many forms of communication)
" }

set nocompatible		" 关闭兼容模式
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" yyq's .vimrc
" ==============================================================================================
set ignorecase smartcase	" 搜索时忽略大小写，但在有一个或以上大写字母时仍保持对大小写敏感

set nu				" 显示行号
set ruler
set rulerformat=%55(%{strftime('%a\ %b\ %e\ %I:%M\ %p')}\ %5l,%-6(%c%V%)\ %P%)
set guioptions+=b
set guioptions-=T

set paste
"set clipboard=unnamed		" 让Vim和Win共用剪贴板

set cursorline cursorcolumn

syntax enable			" 打开语法高亮
syntax on			" 允许按指定主题进行语法高亮，而非默认高亮主题
colorscheme xoria256		" 指定配色方案

set showcmd			" 在命令行显示当前输入的命令

set langmenu=en_US		" 将菜单和信息设置为英文
let $LANG = 'en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set fileencoding=utf-8		" 设置多编码处理
set encoding=utf-8
set tenc=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
"language message zh_CN.UTF-8

filetype on			" 开启文件类型侦测
filetype plugin on		" 根据侦测到的不同类型加载对应的插件


if has("autocmd") && exists("+omnifunc")
autocmd Filetype *
\ if &omnifunc == "" |
\ setlocal omnifunc=syntaxcomplete#Complete |
\ endif
endif

set laststatus=2		" 设置状态栏
set statusline=%2*%n%m%r%h%w%*\ %F\ %1*[FORMAT=%2*%{&ff}:%{&fenc!=''?&fenc:&enc}%1*]\ [TYPE=%2*%Y%1*]\ [COL=%2*%03v%1*]\ [ROW=%2*%03l%1*/%3*%L(%p%%)%1*]\ [DATE=%2*%{strftime(\"%c\",getftime(expand(\"%%\")))}%1*]   

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=peru
  elseif a:mode == 'r'
    hi statusline guibg=blue
  else
    hi statusline guibg=black
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=orange guifg=white
hi statusline guibg=black

hi User1 guifg=gray
hi User2 guifg=red
hi User3 guifg=white
"hi User5 guibg=#C2BFA5 guifg=#666666

" font
set guifont="Courier New":14
"set guifont=DejaVu\ Sans\ Mono:h11

set winaltkeys=no

" map
nmap <tab> V>
nmap <s-tab> V<
vmap <tab> >gv
vmap <s-tab> <gv
" 打开另存为对话框
map <F2> <Esc>:browse saveas<CR>
" 使用NERDTree插件查看工程文件
nmap <F3> :NERDTreeToggle planning<CR>
" 启用/禁止折行
nmap <silent> <F5> <Esc>:call ToggleWrap()<CR>
" 显示/禁止行列光标
nmap <silent> <F6> <Esc>:call ToggleCursor()<CR>
" 新建标签页
map <F10> <Esc>:tabnew<CR>
" 显示/禁止查找高亮度
nmap <silent> <A-f> <Esc>:call ToggleHLSearch()<CR>

function! ToggleWrap()
     if &wrap
          set nowrap
     else
          set wrap
     endif
endfunction

function! ToggleHLSearch()
     if &hls
          set nohls
     else
          set hls
     endif
endfunction

function! ToggleCursor()
     if &cursorcolumn
          set nocursorline nocursorcolumn
     else
          set cursorline cursorcolumn
     endif
endfunction


let mapleader=";"		" 定义快捷键的前缀，即<Leader>
nmap <leader>v :tabedit $MYVIMRC<CR>

" 配置文件
autocmd bufwritepost _vimrc source $MYVIMRC

" 设置文件格式
set fileformats=unix,dos,mac

" Template
autocmd! BufNewFile * silent! 0r $VIM/vimfiles/skel/Template.%:e

" 指定备份文件目录
set backupdir=F:\Bak
set backupskip=D:/Temp/*

" 取消代码自动折叠
autocmd! BufNewFile,BufRead * setlocal nofoldenable
" 打开/关闭代码折叠
nnoremap <space> za

" 优化大文件编辑
let g:LargeFile=10

" 自动加载文件
set autoread

set list!
set listchars=nbsp:¬,tab:┈┈,precedes:«,extends:»,trail:
hi NonText      ctermfg=247 guifg=#a73111 cterm=bold gui=bold
hi SpecialKey   ctermfg=77  guifg=#654321

augroup filetypedetect
   au BufNewFile,BufRead *.mxl	 setf mxl
augroup END

" 插件
" ---------------------------------------------------------------------------------------------
let Grep_Path='C:\Progra~1\GnuWin32\bin\grep.exe'
let Fgrep_Path='C:\Progra~1\GnuWin32\bin\fgrep.exe'
let Egrep_Path='C:\Progra~1\GnuWin32\bin\egrep.exe'
let Agrep_Path='C:\Progra~1\GnuWin32\bin\agrep.exe'
let Grep_Find_Path='C:\Progra~1\GnuWin32\bin\find.exe'
let Grep_Xargs_Path='C:\Progra~1\GnuWin32\bin\xargs.exe'

" Rainbow Parentheses插件
" ---------------------------------------------------------------------------------------------
func! s:rainbow_parenthsis_load()
   call rainbow_parenthsis#LoadSquare ()
   call rainbow_parenthsis#LoadRound ()
   call rainbow_parenthsis#Activate ()
endfunc

au Syntax csc call s:rainbow_parenthsis_load()

" CloseTag插件
" ---------------------------------------------------------------------------------------------
autocmd FileType html,xhtml,xml let b:closetag_html_style=1
autocmd FileType html,xhtml,xml source $VIM/vimfiles/scripts/closetag.vim

" YankRing插件
" ---------------------------------------------------------------------------------------------
nnoremap <silent> <F11> :YRShow<CR>
