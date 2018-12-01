" .vimrc adapted from Jon Gjengset
" https://github.com/jonhoo/configs/blob/master/.vimrc

" ========== PLUGINS
set nocompatible
filetype off
call plug#begin('~/.vim/plugged')

" === Load plugins
" vim enhancements
Plug 'justinmk/vim-sneak'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'w0rp/ale'
Plug 'machakann/vim-highlightedyank'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

"Semantic language support
Plug 'autozimu/LanguageClient-neovim', {
	\ 'branch': 'next',
	\ 'do': 'bash install.sh'
	\ }
Plug 'ncm2/ncm2'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'roxma/nvim-yarp'

" Completion plugins
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-racer'

" LanguageClient enhancements
Plug 'Shougo/echodoc.vim'

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'

" Colors
Plug 'rafi/awesome-vim-colorschemes'

call plug#end()

" === Plugin settings
let g:lightline = {
	\ 'component_function': {
	\	'filename': 'LightlineFilename',
	\ },
\ }
function! LightlineFilename()
	return expand('%:t') !=# '' ? @% : '[Untitled]'
endfunction

" from http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity
if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor
endif
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

" Linter
let g:ale_sign_column_always = 1
" only lint on save
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 0
let g:ale_lint_on_enter = 0
let g:ale_rust_cargo_use_check = 1
let g:ale_rust_cargo_check_all_targets = 1

" Open hotkeys
map <C-p> :Files<CR>
nmap <leader>; :Buffers<CR>

" Quick-save
nmap <leader>w :w<CR>

" language server protocol
let g:LanguageClient_settingsPath = "~/.vim/settings.json"
let g:LanguageClient_serverCommands = {
	\ 'rust': ['env', 'CARGO_TARGET_DIR=/data/ramonimbao/cargo-target/rls', 'rls'],
	\ }
let g:LanguageClient_autoStart = 1
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" racer + rust
" https://github.com/rust-lang/rust.vim/issues/192
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let $RUST_SRC_PATH = systemlist("rustc --print sysroot")[0] . "/lib/rustlib/src/rust/src"

" Completion
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
" tab to select
" and don't hijack my enter key
inoremap <expr><Tab> (pumvisible()?(empty(v:completed_item)?"\<C-n>":"\<C-y>"):"\<Tab>")
inoremap <expr><CR> (pumvisible()?(empty(v:completed_item)?"\<CR>\<CR>":"\<C-y>"):"\<CR>")

" vim-highlightedyank
if !exists('##TextYankPost')
	map y <Plug>(highlightedyank)
endif

" ========== EDITOR SETTINGS
filetype plugin indent on
set autoindent
set timeoutlen=300 " http://stackoverflow.com/question/2158516/delay-before-o-opens-a-new-line
set encoding=utf-8
set scrolloff=2
set noshowmode
set hidden
set nowrap
set nojoinspaces

" Sane splits
set splitright
set splitbelow

" Permanent undo
set undodir=~/.vimdid
set undofile

" Decent wildmenu
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor

" Use short tabs
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" Get syntax
syntax on

" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/

" ========== GUI SETTINGS
set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set backspace=2 " Backspace over newlines
set foldmethod=marker " Only fold on marks
set ruler " Where am I?
set ttyfast
" https://github.com/vim/vim/issues/1735#issuecomment-383353563
set lazyredraw
set synmaxcol=500
set laststatus=2
set relativenumber " Relative line numbers
set diffopt+=iwhite " No whitespace in vimdiff
set colorcolumn=80 " and give me a colored column
set showcmd " Show (partial) command in status line
set mouse=a " Enable mouse usage (all modes) in terminals
set shortmess+=c " don't give |ins-completion-menu| messages

" Colors
set background=dark
colorscheme onedark

" Show those damn hidden characters
" Verbose: set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•
set nolist
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" ========== KEYBOARD SHORTCUTS
" ; as :
" nnoremap ; :

" Ctrl+c and Ctrl+j as Esc
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>

" Suspend with Ctrl+f
inoremap <C-f> :sus<cr>
vnoremap <C-f> :sus<cr>
nnoremap <C-f> :sus<cr>


" <leader>s for Rg search
noremap <leader>s :Rg
command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \     'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
    \    <bang>0 ? fzf#vim#with_preview('up:60%')
    \            : fzf#vim#with_preview('right:50%:hidden', '?')
    \    <bang>0)

function! s:list_cmd()
	let base = fnamemodify(expand('%'), ':h:.:S')
	return base == '.' ? 'fd --type file --folow' : printf('fd --type file --folow | proximity-sort %s', expand('%'))
endfunction

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
	\								'options': '--tiebreak=index'}, <bang>0)

" Open new file adjacent to current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" Move by line
nnoremap j gj
nnoremap k gk

" Jump to next/previous error
nnoremap <C-j> :cnext<cr>
nnoremap <C-k> :cprev<cr>
nmap <silent> L <Plug>(ale_lint)
nnoremap <C-l> :copen<cr>
nnoremap <C-g> :cclose<cr>

" <leader><leader> toggles between buffers
nnoremap <leader><leader> <c-^>

" <leader>= reformats currant range
nnoremap <leader>= :'<,'>RustFmtRange<cr>

" <leader>, shows/hides hidden characters
nnoremap <leader>, :set invlist<cr>

" <leader>q shows stats
nnoremap <leader>q g<c-g>

" Keymap for replacing up to next _ or -
noremap <leader>m ct_
noremap <leader>n ct-

" M to make
noremap M :!make -k -j4<cr>

" I can type :help on my own, thanks
map <F1> <Esc>
imap <F1> <Esc>

" ========== AUTOCOMMANDS
" Pretend accidental writes to buffers that shouldn't be edited
autocmd BufRead *.orig set readonly
autocmd BufRead *.pacnew set readonly

" Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

" Jump to last edit position on opening file
if has("autocmd")
	" https://stackoverflow.com/questions/31449496/vim-ignore-specific-file-in-autocommand
	au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Follow Rust code style rules
au Filetype rust set colorcolumn=100

" Help filetype detection
autocmd BufRead *.plot set filetype=gnuplot
autocmd BufRead *.md set filetype=markdown
autocmd BufRead *.lds set filetype=ld
autocmd BufRead *.tex set filetype=tex
autocmd BufRead *.trm set filetype=c
autocmd BufRead *.xlsx.axlsx set filetype=ruby

" Jump to start and end of line using the home row keys
" I placed this at the bottom because it only works if it's here
nmap H ^
nmap L $
