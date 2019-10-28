" ============================================================================
" vim setup and configuration
" ============================================================================

set nocompatible

if ! filereadable($ME_REPO_DIR.'/vim-plug/plug.vim')
  echo "vim-plug repo not found; try 'refresh vim'"
  finish
endif

source $ME_REPO_DIR/vim-plug/plug.vim
call plug#begin($XDG_CACHE_HOME.'/vim/plugins')
Plug 'sheerun/vim-polyglot',
Plug 'editorconfig/editorconfig-vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'itchyny/lightline.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'majutsushi/tagbar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/bats.vim'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'luan/vim-concourse'
Plug 'w0rp/ale'
Plug 'maximbaz/lightline-ale'
call plug#end()

" use spacebar to trigger keymaps
let mapleader=" "

" config management
nmap <silent><leader>ev :edit $MYVIMRC<cr>
nmap <silent><leader>sv :source $MYVIMRC<cr>

" colorscheme
syntax on
if exists('+termguicolors')
  set termguicolors
endif
colorscheme onehalfdark
highlight Comment cterm=italic
highlight CursorLine cterm=underline
highlight CursorLineNr cterm=underline

" quitting
map <leader>q :quitall<cr>
map <leader>bd :bp\|bd #<cr>

" editing
set autoindent                          " put the cursor where it should be
set tabstop=8                           " tab-formatted files expect this
set list                                " show TABs ...
set listchars=tab:.\                    " ... as  .___
set bs=2                                " backspace over everything
set visualbell                          " quiet please
set nowrap                              " don't wrap lines
set foldmethod=manual                   " I control when to fold
set wildmenu                            " enhanced completion
map <c-d> dd
noremap <cr> o<esc>
nmap <silent><leader>w :set invwrap<cr>
nmap <silent><leader>p :set invpaste<cr>:set paste?<cr>
map <silent><leader>f mzgg=G`z<cr>

" navigation
nnoremap k gk
nnoremap j gj
nnoremap <c-k> <c-w>k
nnoremap <c-j> <c-w>j
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nmap <c-n> :cnext<cr>
nmap <c-m> :cprev<cr>
set mouse=a                             " enable mouse for a(ll) modes
set ttymouse=xterm2                     " xterm-like mouse handling (enables mouse scroll)
set scrolloff=4                         " minimal lines above/below cursor
set sidescroll=1                        " horizontal scroll column count
set sidescrolloff=8                     " minimal columns left/right cursor

" search
set incsearch                           " highlight search matches
nmap <silent><leader>h :set invhlsearch<cr>

" netrw
let g:netrw_home=$XDG_CACHE_HOME.'/vim'

" status line
set laststatus=2                        " always display status line
set noshowmode                          " current mode displayed by lightline

" gutter
set number
function! ToggleRelativeNumbers()
  set relativenumber!
  set number
endfunction
autocmd InsertEnter * call ToggleRelativeNumbers()
autocmd InsertLeave * call ToggleRelativeNumbers()
set numberwidth=3                       " line number gutter width
nmap <silent><leader>n :set number!<cr>
nmap <silent><leader>tg :GitGutterLineHighlightsToggle<cr>

" NERDTree
let NERDTreeIgnore=['\.swp$', '\.pyc$', '__pycache__']
let NERDTreeBookmarksFile = $XDG_CACHE_HOME.'/vim/bookmarks'
map <silent><leader><leader> :NERDTreeToggle<cr>

" rulers
set ruler                               " cursor line/column number,
set cursorline                          " highlight current line
set cursorcolumn                        " highlight current column
nnoremap <silent><leader>c :set cursorcolumn! <cr>
if exists('+colorcolumn')
  let &colorcolumn="80,".join(range(120,999),",")
endif

" command history
set history=50

" diff
set diffopt+=vertical                   " say 'no' to horizontal diffs

" state between vim sessions
set viminfo='10,\"100,:20,%,n$XDG_CACHE_HOME/vim/viminfo
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" use zsh if available
if executable('zsh')
  set shell=zsh
endif

" vim-commentary
map // :Commentary<cr>j

" vim-fugitive
nnoremap <silent><leader>gg :Gstatus<cr>
nnoremap <silent><leader>gd :Gdiff<cr>
nnoremap <silent><leader>gc :Gcommit<cr>
nnoremap <silent><leader>gp :Gpush<cr>

" prefer solver_searcher over grep
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_working_path_mode = 'r'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
"  let g:ctrlp_extensions = ['line']
endif

" lightline
let g:lightline = {
      \   'colorscheme': 'onehalfdark',
      \   'active': {
      \     'left': [ ['mode', 'paste'], ['readonly', 'gitbranch', 'modified', 'fileinfo', 'filename'] ],
      \     'right': [ ['lineinfo'], ['fileformat', 'filencoding', 'filetype'], ['linter_ok', 'linter_checking', 'linter_errors', 'linter_warnings'] ]
      \   },
      \   'inactive': {
      \     'left': [ [ 'pwd' ] ],
      \     'right': [ [ 'lineinfo' ], [ 'fileinfo' ], [ 'scrollbar' ] ],
      \   },
      \   'component_expand': {
      \     'buffers': 'lightline#bufferline#buffers',
      \     'trailing': 'lightline#trailing_whitespace#component',
      \     'linter_ok': 'lightline#ale#ok',
      \     'linter_checking': 'lightline#ale#checking',
      \     'linter_warnings': 'lightline#ale#warnings',
      \     'linter_errors': 'lightline#ale#errors',
      \   },
      \   'component_function': {
      \     'gitbranch': 'fugitive#head',
      \     'pwd': 'LightlineWorkingDirectory',
      \     'scrollbar': '_scrollbar'
      \   },
      \   'component_type': {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left'
      \   }
      \ }
