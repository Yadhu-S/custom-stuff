syntax on

set nohlsearch
set nocompatible
set tabstop=4
set shiftwidth=4
set smartindent
set noexpandtab
set nu rnu
set undodir=~/.config/nvim/undodir
set undofile
set incsearch
set noswapfile
set nobackup
set guifont=DejaVuSansMono\ Nerd\ Font\ Mono\ 14
set ignorecase
set smartcase
set splitright
"set cursorcolumn
set cursorline

let mapleader=" "
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
noremap <space> <Nop>
nmap <C-p> :Telescope find_files<CR>
imap <C-c> <esc>
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
nmap <leader>/ :Telescope live_grep<CR>
nmap <leader>t :NvimTreeToggle<cr>
map <C-_> :Commentary<CR>
nmap <leader>b :Gitsigns toggle_current_line_blame<CR>
nnoremap <leader>d "_d
vnoremap <C-j> :move '>+1<CR>gv=gv
vnoremap <C-k> :move '<-2<CR>gv=gv
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
"Save as sudo"
cmap w!! w !sudo tee > /dev/null %

autocmd BufWritePost *.go :FormatWrite

autocmd StdinReadPre * let s:std_in=1
"augroup fmt
"  autocmd!
"  autocmd BufWritePre * Neoformat
"augroup END

call plug#begin()
	Plug 'tpope/vim-commentary'
	Plug 'sebdah/vim-delve'
	Plug 'lukas-reineke/indent-blankline.nvim'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/vim-vsnip-integ'
	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'
	Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
	Plug 'kyazdani42/nvim-tree.lua'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'rebelot/kanagawa.nvim'
	Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
	Plug 'neovim/nvim-lspconfig'
	Plug 'ryanoasis/vim-devicons'
	Plug 'lewis6991/gitsigns.nvim'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'nvim-treesitter/nvim-treesitter-textobjects'
	Plug 'sbdchd/neoformat'
	Plug 'rafamadriz/friendly-snippets'
	Plug 'nvim-lualine/lualine.nvim'
	Plug 'kyazdani42/nvim-web-devicons'
	Plug 'kylechui/nvim-surround'
	Plug 'dense-analysis/ale'
	Plug 'mhartington/formatter.nvim'
call plug#end()

""set background=dark
let g:ale_linters = {
\   'go': ['revive'],
\}



lua<<EOF
	require("formatter").setup({
		filetype = {
			go = {
				require("formatter.filetypes.go").goimports,
			},
			["*"] = {
				require("formatter.filetypes.any").remove_trailing_whitespace,
			},
		},
	})

	require("nvim-surround").setup()

	require('gitsigns').setup()

	require('kanagawa').setup({
	transparent = true,
	theme = "default"
	})

	local linecount = function()
		return vim.api.nvim_buf_line_count(0)
	end
	vim.cmd("colorscheme kanagawa")

	require('lualine').setup({
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {{'filename',path = 3}},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress',linecount},
		lualine_z = {'location'}
		},
	tabline = {
		lualine_b = {{ "buffers", mode = 4 }}
		}
	})

	require("nvim-tree").setup({
	sort_by = "case_sensitive",
	hijack_cursor = true,
	prefer_startup_root = true,
	update_focused_file = {
		enable = true,
		update_root = true,
		ignore_list = {},
	},
	view = {
		adaptive_size = false,
		side = "left",
		mappings = {
			list = {
				{ key = "u", action = "dir_up" },
				},
			},
		},
	renderer = {
		add_trailing = true,
		indent_markers = {
			enable = true,
			inline_arrows = true,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				none = " ",
				},
			}
		},
	filters = {
		},
	})

	require'nvim-treesitter.configs'.setup {
		ensure_installed = "bash", "c", "cmake", "commonlisp", "cpp", "css", "dockerfile", "go", "gomod", "gowork", "graphql", "haskell", "html", "java", "javascript", "jsdoc", "json", "json5", "jsonc", "latex", "llvm", "lua", "make", "markdown", "markdown_inline", "ninja", "perl", "proto", "python", "query", "regex", "ruby", "rust", "scala", "scheme", "scss", "sql", "svelte", "toml", "tsx", "typescript", "vim", "vue", "yaml", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
		sync_install = false,
		ignore_install = {  }, -- List of parsers to ignore installing
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
				},
			},
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				node_incremental = "<C-l>",
				node_decremental = "<C-h>",
			},
		},
		highlight = {
			enable = true,
			disable = { "vim" },  -- list of language that will be disabled
			additional_vim_regex_highlighting = false,
		},
	}

	local on_attach = function(client, bufnr)
		local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
		local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
		local opts = { noremap=true, silent=true }
		buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
		buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
		buf_set_keymap('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
		buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
		buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
		buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
		buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
		buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
		buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
		buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
		buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
		buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
		buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
		buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
		buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	end

	local cmp = require'cmp'
	cmp.setup({

		snippet = {
			expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			end,
		},

		mapping = {
			['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
			['<C-u>'] = cmp.mapping.scroll_docs(-4),
			['<C-d>'] = cmp.mapping.scroll_docs(4),
			['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
			['<C-e>'] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
		},

		sources = cmp.config.sources({
			{ name = 'nvim_lsp' },
			{ name = 'vsnip'},
		}, {
			{ name = 'buffer' },
		}),
	})

	local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
	-- gopls (Golang LSP)
	local nvim_lsp = require('lspconfig')
	nvim_lsp.gopls.setup {
		cmd = {"gopls", "serve"},
		capabilities = capabilities,
		flags = {
			debounce_text_changes = 250,
		},
		settings = {
			gopls = {
				experimentalPostfixCompletions = false,
				usePlaceholders = true,
				analyses = {
					unusedparams = true,
					shadow = true,
					fieldalignment = true,
					nilness = true,
					unusedparams = true,
					unusedwrite = true,
				},
				staticcheck = true,
			},
		},
		on_attach = on_attach,
	}

	vim.opt.list = true
	vim.opt.listchars:append("space:⋅")
	vim.opt.listchars:append("eol:↴")	

	-- pyright (Python LSP)
	require'lspconfig'.pyright.setup{
		on_attach = on_attach
	}

	require("indent_blankline").setup {
		show_current_context = true,
		show_current_context_start = true,
	}

	require'nvim-web-devicons'.setup {
		default = true;
	}

	require('telescope').setup{
		defaults = {
			color_devicons = true,
			mappings = { i = { } },
			pickers = { },
			extensions = {
				fzf = {
				  fuzzy = true,
				  override_generic_sorter = true,
				  override_file_sorter = true,
				  case_mode = "smart_case",
				}
			}
		}
	}
	require('telescope').load_extension('fzf')

EOF

