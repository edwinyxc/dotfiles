"" check :h guicursor -- this is a neovim only setting
:set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
		  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
		  \,sm:block-blinkwait175-blinkoff150-blinkon175

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set lazyredraw

"" auto save
"set autowrite
"set autowriteall

"" auto reload vimrc
set exrc
set secure

" Wrapping options 
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

"" TAB and CTRL-I are internally identical, uncomment this if you prefer TAB
"" and never gonna use CTRL + I/O
"nnoremap <Tab> gt
"nnoremap <S-Tab> gT
"nnoremap <silent> <S-t> :tabnew<CR>
"
