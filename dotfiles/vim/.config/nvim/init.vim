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

let mapleader=" "
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let NERDTreeChDirMode=0
noremap <space> <Nop>
nmap <C-p> :Telescope find_files<CR>
imap <C-c> <esc>
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
nmap <leader>/ :Telescope live_grep<CR>
nmap <leader>e :NERDTreeToggle<cr>
nnoremap <leader>d "_d
vnoremap <C-j> :move '>+1<CR>gv=gv
vnoremap <C-k> :move '<-2<CR>gv=gv

autocmd BufWritePre *.go lua vim.lsp.buf.formatting()
autocmd BufWritePre *.go lua goimports(1000)
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
			\ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
"augroup fmt
"  autocmd!
"  autocmd BufWritePre * Neoformat
"augroup END
"
call plug#begin()
	Plug 'lukas-reineke/indent-blankline.nvim'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/vim-vsnip-integ'
	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'
	Plug 'preservim/nerdtree'
	Plug 'vim-airline/vim-airline'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
	Plug 'neovim/nvim-lspconfig'
	Plug 'ryanoasis/vim-devicons'
	Plug 'tpope/vim-fugitive'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'morhetz/gruvbox'
	Plug 'nvim-treesitter/nvim-treesitter-textobjects'
	Plug 'sbdchd/neoformat'
	Plug 'rafamadriz/friendly-snippets'
	Plug 'kyazdani42/nvim-web-devicons'
	Plug 'APZelos/blamer.nvim'
call plug#end()

let g:blamer_delay = 500
let g:blamer_template = '(<commit-short>) <committer>, <author-time> • <summary>'
let g:blamer_enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
"set background=dark
let g:airline_theme='gruvbox'
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox

autocmd VimEnter * hi Normal ctermbg=none

lua<<EOF
	require'nvim-treesitter.configs'.setup {
		ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
		sync_install = false,
		ignore_install = { "javascript" }, -- List of parsers to ignore installing
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
		buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
		buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
		buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
		buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
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
				analyses = {
					unusedparams = true,
					shadow = true,
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

	function goimports(timeoutms)
		local context = { source = { organizeImports = true } }
		vim.validate { context = { context, "t", true } }

		local params = vim.lsp.util.make_range_params()
		params.context = context

		-- See the implementation of the textDocument/codeAction callback
		-- (lua/vim/lsp/handler.lua) for how to do this properly.
		local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
		if not result or next(result) == nil then return end
		local actions = result[1].result
		if not actions then return end
		local action = actions[1]

		-- textDocument/codeAction can return either Command[] or CodeAction[]. If it
		-- is a CodeAction, it can have either an edit, a command or both. Edits
		-- should be executed first.
		if action.edit or type(action.command) == "table" then
		  if action.edit then
			vim.lsp.util.apply_workspace_edit(action.edit)
		  end
		  if type(action.command) == "table" then
			vim.lsp.buf.execute_command(action.command)
		  end
		else
		  vim.lsp.buf.execute_command(action)
		end
	end	
EOF
