source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin
set rtp+=$VIM/vimfiles/bundle/vundle/
call vundle#rc('$VIM/vimfiles/bundle/')

Bundle 'gmarik/vundle'
Plugin 'jiangmiao/auto-pairs'
Plugin 'kien/ctrlp.vim'
Bundle 'fatih/vim-go'
Bundle 'easymotion/vim-easymotion'
Bundle 'scrooloose/nerdtree'

set diffexpr=MyDiff()
function MyDiff()
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

set nocompatible "不兼容VI
set noswapfile "关闭swap文件
set nobackup "关闭文件备份
set nu "显示行号
syntax on "打开关键字色
set vb t_vb= "去掉闪屏和报警声音
filetype off "侦测文件类型
filetype indent on "为特定文件类型载入相关缩进文件
filetype plugin on "载入文件类型插件
colorscheme desert "色彩主题
set autoread " 自动重新加载外部修改内容
set lines=999 columns=999
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

" Vim-go
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

"ctrlp
let g:ctrlp_use_caching = 1
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = {
\ 'dir': '\v[\/](([^\/]+\/)*node_modules|([^\/]+\/)*jspm_packages|([^\/]+\/)*bower_components|([^\/]+\/)*vendor/bundle|([^\/]+\/)*tmp/cache/assets)$|_site'
\ }
"quickfix 按F6或F7切换结果
nmap <F6> :cp<cr>
nmap <F7> :cn<cr>

"NERDTree配置
map <F10> :NERDTreeToggle<CR>
map <C-F10> :NERDTreeFind<CR>
let NERDTreeChDirMode=2 "选中root即设置为当前目录
"let NERDTreeQuitOnOpen=1 "打开文件时关闭树
let NERDTreeShowBookmarks=1 "显示书签
let NERDTreeMinimalUI=1 "不显示帮助面板
let NERDTreeDirArrows=1 "目录箭头 1 显示箭头 0传统+-|号

au FileType go nmap <leader>b <Plug>(go-build)
nmap ;ll :NERDTreeToggle E:\work\php\serverr<CR>
nmap ;lw :NERDTree E:\work\php\server<CR>
nmap ;ls :NERDTree E:\work\php\server<CR>
nmap ;lm :NERDTree E:\work\php\server<CR>
nmap ;li :NERDTree E:\work\php\server<CR>
nmap ;ln :NERDTreeMirror<CR>

"映射Easymotion快捷键为:空格+w/b
let g:EasyMotion_leader_key='<Space>'

" 重启后撤销历史可用 persistent undo
set undofile
set undodir=$VIM/vimfiles/\_undodir
set undolevels=1000 "maximum number of changes that can be undone
let g:go_snippet_engine = "neosnippet" "默认代码补全引擎是 Ultisnips，修改为 neosnippet
let colors_name = "darkblue_my"

highlight Pmenu ctermbg=DarkGray "guibg=LightGray

highlight PmenuSel ctermbg=4 "guibg=DarkGray guifg=White

"highlight PmenuSbar ctermbg=Blue "guibg=DarkBlue

"highlight PmenuThumb ctermbg=Yellow "guibg=Black


"将键盘上的F4功能键映射为添加作者信息的快捷键
map <F4> ms:call AddAuthor()<cr>'s
function AddTitle()
call append(0,"/**********************************************************")
call append(1," * Author : Michael")
call append(2," * Email : dolotech@163.com")
call append(3," * Last modified : ".strftime("%Y-%m-%d %H:%M"))
call append(4," * Filename : ".expand("%:t"))
call append(5," * Description : ")
call append(6," * *******************************************************/")
echohl WarningMsg | echo "Successful in adding the copyright." | echohl None
endfunction
function AddAuthor()
let n=1
while n < 5
let line = getline(n)
if line =~'^\s*\*\s*\S*Last\s*modified\s*:\s*\S*.*$'
call UpdateTitle()
return
endif
let n = n + 1
endwhile
call AddTitle()
endfunction
function UpdateTitle()
normal m'
execute '/* Last modified\s*:/s@:.*$@\=strftime(": %Y-%m-%d %H:%M")@'
normal "
normal mk
execute '/* Filename\s*:/s@:.*$@\=": ".expand("%:t")@'
execute "noh"
normal 'k
echohl WarningMsg | echo "Successful in updating the copy right." | echohl None
endfunction