"" check :h guicursor -- this is a neovim only setting
:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
		  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
		  \,sm:block-blinkwait175-blinkoff150-blinkon175

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set lazyredraw

"better wildmenu
set path+=**
set wildmenu
set wildmode=longest:list,full


"" auto save
set autowrite
set autowriteall

"" auto reload vimrc
set exrc
set secure

"" TAB and CTRL-I are internally identical, uncomment this if you prefer TAB
"" and never gonna use CTRL + I/O
"nnoremap <Tab> gt
"nnoremap <S-Tab> gT
"nnoremap <silent> <S-t> :tabnew<CR>

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
cnoremap <C-E> <C-R>=expand("%:p:h") . "/" <CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

"" Buffer nav
" noremap <leader>z :bp<CR>
" noremap <leader>w :bn<CR>
noremap <A-Left> :bp<CR>
noremap <A-Right> :bp<CR>
noremap <Space><Space> :b#<CR>

" brain dead
"noremap <C-S-[> :bp<CR>
"noremap <C-S-]> :bn<CR>

"" Close buffer
noremap <leader>c :bd<CR>

"" Clean search (highlight)
nnoremap <silent> <leader>, :noh<cr>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default
" 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" TODO-- use nix vars to generate personal preferences
colorscheme zenburn
