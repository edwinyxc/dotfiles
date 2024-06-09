{ config, pkgs, lib, inputs, ... }:
let 
    # Replaced with bulitin upstream
    #plenary-nvim = pkgs.vimUtils.buildVimPlugin {
    #    name = "plenary-nvim";
    #    src = inputs.plenary-nvim;
    #};

    #always installs the latest version
    PlugAndConfig = plug : config : {
        plugin = plug;
        config = config;
    };

    Plug = plug : (PlugAndConfig plug "");
  
    importFile = lib.strings.fileContents;
    
   # toggle-lsp-diagnostics-nvim =  pkgs.vimUtils.buildVimPlugin {
   #     name = "toggle-lsp-diagnostics-nvim";
   #     src = inputs.vimPlugins_toggle-lsp-diagnostics-nvim;
   # };

   # telescope-bibtex-nvim = pkgs.vimUtils.buildVimPlugin {
   #     name = "telescope-bibtex-nvim";
   #     src = inputs.vimPlugins_telescope-bibtex-nvim;

   # };

    outline-nvim = pkgs.vimUtils.buildVimPlugin {
        name = "outline.nvim";
        src = inputs.vimPlugins_outline-nvim;
    };

    #fzf-mru-vim = pkgs.vimUtils.buildVimPlugin {
    #    name = "fzf-mru.vim";
    #    src = inputs.vimPlugins_fzf-mru-vim;
    #};

in {
	home.packages = with pkgs; [
		tree-sitter
		jq 
		curl
		universal-ctags
#nix 
#rnix-lsp # error: 'rnix-lsp' has been removed as it is unmaintained
		nil 
#nodejs
		nodejs
# python
		nodePackages.pyright # not worth
# js & ts 
#nodePackages.typescript-language-server
#rust 
#rust-analyzer
# lua
# 
#sumneko-lua-language-server # not worth
#lua-ls

#micromamba

#TODO
#languageTool

#java
		vimPlugins.nvim-jdtls

    ];

  programs.neovim = {
      enable = true;
      #package = pkgs.neovim-nightly;
      #package = inputs.neovim-nightly.packages.${pkgs.system}.neovim;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withNodeJs = true;
      withPython3 = true;
      withRuby = true;

      #-- appended to the end of init.vim
      extraConfig = builtins.concatStringsSep "\n" [
         #-- loadSync

         # lua configs 
         ''
lua << EOF
-- loadSync
${ 
    '' 
    --importFile ./nvim/telescope.lua 
    ''
}
-- runAsync (deferred lsp configs)
vim.defer_fn(function()
    ${importFile ./nvim/lsp.lua}

    vim.cmd [[
       " defered 
    ]]
end, 70)
EOF
         ''
      ];

      plugins = with pkgs.vimPlugins; [

        #Common dependency for other plugins 
        (PlugAndConfig plenary-nvim  ''
""" IMPORTANT! """ put this at the first to ensure write first !!!
${importFile ../system/vimrc}
        '')

        (Plug vim-gutentags)
        #(Plug vim-LanguageTool)

        (Plug vimtex)
        
        vim-fugitive
        (PlugAndConfig vim-tmux-navigator ''
        '')
        nvim-web-devicons

        #Fuzzy finder
        (PlugAndConfig fzf-vim ''
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>f :FZF -m<CR>
nnoremap <silent> <leader>F :Files<CR>
nnoremap <silent> <leader>g :Rg <CR>

"Recovery commands from history through FZF
"not useful
"nmap <leader>y :History:<CR>
        '')

#        (PlugAndConfig fzf-mru-vim ''
#nnoremap <silent> <C-P> :FZFMru<CR>
#        '')
        #telescope-nvim
        #telescope-fzf-native-nvim

        #(PlugAndConfig telescope-bibtex-nvim ''
        #'')

        #(Plug "nvim-telescope/telescope.nvim")
        #(Plug "kelly-lin/telescope-ag")

        #tree-sitter!
        (PlugAndConfig nvim-treesitter.withAllGrammars ''
lua << EOF
require'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,

		-- using old ones
		-- disable = { "markdown" }, 
	},
	indent = { enable = true, },
	incremental_selection = {
	--keymaps = {
		enable = true,
		--  init_selection = "gnn",
		--  node_incremental = "grn",
		--  scope_incremental = "grc",
		--  node_decremental = "grm",
		--},
	},
}

EOF
        '')

        (PlugAndConfig nvim-treesitter-context ''
lua << EOF
require'treesitter-context'.setup{
-- Enable this plugin (Can be enabled/disabled later via commands)
	enable = true, 
-- How many lines the window should span. Values <= 0 mean no limit.
	max_lines = 5, 
-- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	trim_scope = 'outer', 
	patterns = { 
-- Match patterns for TS nodes. These get wrapped to match at word boundaries.
-- For all filetypes
-- Note that setting an entry here replaces all other patterns for this entry.
-- By setting the 'default' entry below, you can control which nodes you want to
-- appear in the context window.
		default = {
			'class',
			'function',
			'method',
			-- 'for', -- These won't appear in the context
			-- 'while',
			-- 'if',
			-- 'switch',
			-- 'case',
		},
        -- Example for a specific filetype.
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        --   rust = {
        --       'impl_item',
        --   },
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
    },

    -- [!] The options below are exposed but shouldn't require your attention,
    --     you can safely ignore them.

    zindex = 20, -- The Z-index of the context window
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
}
EOF
        '')

        # brackets highlighting
        # (Plug "p00f/nvim-ts-rainbow") 

        # LSP
        nvim-lspconfig
        #(Plug "neovim/nvim-lspconfig")

# Toggle diagnostics
#        (PlugAndConfig toggle-lsp-diagnostics-nvim ''
#lua << EOF
#require'toggle_lsp_diagnostics'.init()
#if (not my) then my = {} end
#my.toggke = false
#my.toggle_diagnostics = function() 
#    local toggle_lsp_diagnostics = require'toggle_lsp_diagnostics'
#    if my.toggle then 
#        toggle_lsp_diagnostics.turn_on_diagnostics()
#    else
#        toggle_lsp_diagnostics.turn_off_diagnostics()
#    end
#    my.toggle = not my.toggle
#end
#EOF
#
#nnoremap <leader>d :lua my.toggle_diagnostics()<CR>
#        '')

        # Completion
        #nvim-cmp
        #cmp-nvim-lsp
        #cmp-buffer
        #cmp-path
        #cmp-cmdline

        # snippets are needed for many language servers
        #cmp-vsnip
        #vim-vsnip

        #friendly-snippets # snippet collection for all languages
        #(Plug "petertriho/cmp-git")

        #TODO r w vimPlugins.lsp_signature-nvim
        lsp_signature-nvim

        #motions
        #vim-wordmotion
        clever-f-vim

#outlines 

# Aerial is buggy
#        (PlugAndConfig aerial-nvim ''
#lua << EOF
#require("aerial").setup({
#    -- optionally use on_attach to set keymaps when aerial has attached to a buffer
#    on_attach = function(bufnr)
#    -- Jump forwards/backwards with '{' and '}'
#    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
#    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
#    end,
#})
#-- You probably also want to set a keymap to toggle aerial
#vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle!<CR>")
#EOF
#        '')
        (PlugAndConfig outline-nvim ''
lua << EOF
require("outline").setup({ })
EOF

nmap <leader>o <cmd>Outline<CR>
        '')

        # Status line
        (PlugAndConfig lualine-nvim ''
lua << EOF
require("lualine").setup({
sections = {
  lualine_a = {
    {
      'filename',
      file_status = true,      -- Displays file status (readonly status, modified status)
      newfile_status = false,  -- Display new file status (new file means no write after created)
      path = 1,                -- 0: Just the filename
                               -- 1: Relative path
                               -- 2: Absolute path
                               -- 3: Absolute path, with tilde as the home directory
                               -- 4: Filename and parent dir, with tilde as the home directory

      shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                               -- for other components. (terrible name, any suggestions?)
      symbols = {
        modified = '[+]',      -- Text to show when the file is modified.
        readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
        unnamed = '[No Name]', -- Text to show for unnamed buffers.
        newfile = '[New]',     -- Text to show for newly created file before first write
      }
    }
  }
}
})
EOF
        '')


# Fri 31 May 2024 03:45:27 AEST 
# -- [occupies one line! -- not worth]

#        (PlugAndConfig bufferline-nvim ''
#lua << EOF
#require('bufferline').setup {
#  options = {
#    show_close_icon = true,
#    show_buffer_close_icons = false,
#    separator_style = "thick",
#  },
#}
#EOF
#        '')

# Could be replaced in basic settings
# [Edwin: repalced] Fri 07 Jun 2024 02:40:03 AEST
#        (PlugAndConfig indentLine ''
#let g:indentLine_fileTypeExclude = ['markdown']
#        '')

# Must have?.
#        (PlugAndConfig wilder-nvim ''
#lua << EOF
#require('wilder').setup({modes = {':', '/', '?'}})
#require('wilder').set_option('renderer', wilder.renderer_mux({
#  [':'] = wilder.popupmenu_renderer({
#    highlighter = wilder.basic_highlighter(),
#  }),
#  ['/'] = wilder.wildmenu_renderer({
#    highlighter = wilder.basic_highlighter(),
#  }),
#}))
#EOF
#        '')

        # Colors & themes
	(PlugAndConfig catppuccin-nvim ''
	'')
        zenburn

	# A very fast color keyword highlighter with context-sensitive 
	# support for many language syntaxes. 
	vim-css-color

        #(PlugAndConfig vim-LanguageTool ''

        #'')

        (PlugAndConfig vim-easy-align ''
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
        '')

        (PlugAndConfig markdown-preview-nvim ''
let g:mkdp_browser = 'firefox'
nmap <leader>p <Plug>MarkdownPreviewToggle
        '')
      #End of vimPlugins
      ];

       extraPackages = with pkgs; [
        ripgrep
        git
       ];
  };
}
