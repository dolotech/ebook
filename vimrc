set noerrorbells visualbell t_vb=
syntax on "打开关键字色
set vb t_vb= "去掉闪屏和报警声音
filetype indent on "为特定文件类型载入相关缩进文件
filetype plugin on "载入文件类型插件

""""""""""""""""""""""
"      Settings      "
""""""""""""""""""""""
set nocompatible                " Enables us Vim specific features
filetype off                    " Reset filetype detection first ...
filetype plugin indent on       " ... and enable filetype detection
set ttyfast                     " Indicate fast terminal conn for faster redraw
set ttymouse=xterm2             " Indicate terminal type for mouse codes
set ttyscroll=3                 " Speedup scrolling
set laststatus=2                " Show status line always
set encoding=utf-8              " Set default encoding to UTF-8
set autoread                    " Automatically read changed files
set autoindent                  " Enabile Autoindent
set backspace=indent,eol,start  " Makes backspace key more powerful.
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set noerrorbells                " No beeps
set number                      " Show line numbers
set showcmd                     " Show me what I'm typing
set noswapfile                  " Don't use swapfile
set nobackup                    " Don't create annoying backup files
set splitright                  " Vertical windows should be split to right
set splitbelow                  " Horizontal windows should split to bottom
set autowrite                   " Automatically save before :next, :make etc.
set hidden                      " Buffer should still exist if window is closed
set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats
set noshowmatch                 " Do not show matching brackets by flickering
set noshowmode                  " We show the mode with airline or lightline
set ignorecase                  " Search case insensitive...
set smartcase                   " ... but not it begins with upper case
set completeopt=menu,menuone    " Show popup menu, even if there is one entry
set pumheight=10                " Completion window max size
set nocursorcolumn              " Do not highlight column (speeds up highlighting)
set nocursorline                " Do not highlight cursor (speeds up highlighting)
set lazyredraw                  " Wait to redraw

syntax enable
set termguicolors
colorscheme solarized8_dark

set autoread " 自动重新加载外部修改内容
"set lines=999 columns=999
"设置为英文版本
let $LANG = 'en'
set langmenu =none

" < 编码配置 >
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
set encoding=utf-8 "设置gvim内部编码
set fileencoding=utf-8 "设置当前文件编码
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1 "设置支持打开的文件的编码

" 文件格式，默认 ffs=dos,unix
set fileformat=unix "设置新文件的<EOL>格式
set fileformats=unix,dos,mac "给出文件的<EOL>格式类型

set rtp+=$VIM/bundle/Vundle.vim
call vundle#begin('$VIM/bundle')
	Plugin 'VundleVim/Vundle.vim'
	Plugin 'fatih/vim-go'  
	Plugin 'easymotion/vim-easymotion'
	Plugin 'scrooloose/nerdtree'
	Plugin 'jiangmiao/auto-pairs'
	Plugin 'kien/ctrlp.vim'
	Plugin 'AndrewRadev/splitjoin.vim'
    Plugin 'SirVer/ultisnips'

call vundle#end() 
filetype plugin indent on 


" JK motions: Line motions
let g:EasyMotion_do_mapping = 0 " Disable default mappings
map f <Plug>(easymotion-prefix)
map fw <Plug>(easymotion-b)
map fb <Plug>(easymotion-w)

let g:EasyMotion_smartcase = 1

"ctrlp
let g:ctrlp_use_caching = 1
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
map <leader>f :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
\ 'dir': '\v[\/](([^\/]+\/)*node_modules|([^\/]+\/)*jspm_packages|([^\/]+\/)*bower_components|([^\/]+\/)*vendor/bundle|([^\/]+\/)*tmp/cache/assets)$|_site'
\ }
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1


"NERDTree配置
map <F2> :NERDTreeToggle<CR>
map <C-F2> :NERDTreeFind<CR>
let NERDTreeChDirMode=2 "选中root即设置为当前目录
"let NERDTreeQuitOnOpen=1 "打开文件时关闭树
let NERDTreeShowBookmarks=1 "显示书签
let NERDTreeMinimalUI=1 "不显示帮助面板
let NERDTreeDirArrows=1 "目录箭头 1 显示箭头 0传统+-|号
nmap ;ln :NERDTreeMirror<CR>

" 重启后撤销历史可用 persistent undo
set undofile
set undolevels=1000 "maximum number of changes that can be undone

nmap ;ll :NERDTreeToggle E:\code\trading<CR>
nmap ;lt :NERDTree  E:\code\trading<CR>
nmap ;lk :NERDTree  E:\code\kline<CR>
nmap ;lb :NERDTree  E:\code\binance<CR>


""""""""""""""""""""""
"      Mappings      "
""""""""""""""""""""""

" Set leader shortcut to a comma ','. By default it's the backslash
let mapleader = ","

" Jump to next error with Ctrl-n and previous error with Ctrl-m. Close the
" quickfix window with <leader>a
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" Visual linewise up and down by default (and use gj gk to go quicker)
noremap <Up> gk
noremap <Down> gj
noremap j gj
noremap k gk

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Act like D and C
nnoremap Y y$

" Enter automatically into the files directory
autocmd BufEnter * silent! lcd %:p:h


"""""""""""""""""""""
"      Plugins      "
"""""""""""""""""""""

" vim-go
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" Open :GoDeclsDir with ctrl-g
nmap <C-g> :GoDeclsDir<cr>
imap <C-g> <esc>:<C-u>GoDeclsDir<cr>


augroup go
  autocmd!

  " Show by default 4 spaces for a tab
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

  " :GoBuild and :GoTestCompile
  autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

  " :GoTest
  autocmd FileType go nmap <leader>t  <Plug>(go-test)

  " :GoRun
  autocmd FileType go nmap <leader>r  <Plug>(go-run)

  " :GoDoc
  autocmd FileType go nmap <Leader>d <Plug>(go-doc)

  " :GoCoverageToggle
  autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

  " :GoInfo
  autocmd FileType go nmap <Leader>i <Plug>(go-info)

  " :GoMetaLinter
  autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)

  " :GoDef but opens in a vertical split
  autocmd FileType go nmap <Leader>v <Plug>(go-def-vertical)
  " :GoDef but opens in a horizontal split
  autocmd FileType go nmap <Leader>s <Plug>(go-def-split)

  " :GoAlternate  commands :A, :AV, :AS and :AT
  autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
  autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
  autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
  autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

" build_go_files is a custom function that builds or compiles the test file.
" It calls :GoBuild if its a Go file, or :GoTestCompile if it's a test file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction
