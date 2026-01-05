{ pkgs, inputs, ... } :
let 
    fzf-mru-vim = pkgs.vimUtils.buildVimPlugin {
        name = "fzf-mru.vim";
        src = inputs.vimPlugins_fzf-mru-vim;
    };

in {
  environment.variables = {EDITOR = "vim";};

  environment.systemPackages = with pkgs; [ 
    (vim-full.customize {
        name = "vi";
        vimrcConfig.packages.myPlugins = with pkgs.vimPlugins; {
            start = [
                #vim-nix
		fzf-vim
		vim-gutentags
                #vim-fugitive
		vimtex
		clever-f-vim
		vim-easy-align
                #csv-vim
                fzf-mru-vim
                ale
                tagbar
                    
#        (PlugAndConfig fzf-mru-vim ''
#        '')
	    ];
            opt = [];
        };
        vimrcConfig.customRC = (builtins.readFile ./vimrc) + ''

"tags @See https://github.com/ludovicchabant/vim-gutentags/issues/161
if executable('rg')
  let g:gutentags_file_list_command = 'rg --files'
endif

"fzf.vim
nnoremap <silent> <leader>b :Buffers<CR>
"nnoremap <silent> <leader>f :FZF -m<CR>
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>g :Rg <CR>

"fzfmru
nnoremap <silent> <leader>F :FZFMru<CR>

"Recovery commands from history through FZF
"not useful
"nmap <leader>y :History:<CR>

"vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" tagbar
nmap <F8> :TagbarToggle<CR>

" ALE 
" Enable ALE for all file types
let g:ale_enabled = 1

" Python-specific linter and fixer
let g:ale_linters = {
\   'python': ['ruff'],
\   'nix': ['statix'],
\}
let g:ale_fixers = {
\   'python': ['ruff'],
\}

" Automatically fix on save for specific file types
let g:ale_fix_on_save = 1

" Display error/warning signs and virtual text for error messages
let g:ale_sign_error = 'E:'
let g:ale_sign_warning = 'W:'
let g:ale_virtualtext_cursor = 1
	''; 
    })
        statix  # Nix Code Formatter
        #alejandra # Nix Code Formatter

        python311Packages.ruff
        #python311Packages.black

  ];

}
