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
set cursorcolumn
set cursorline

nnoremap <C-j> <C-e>
nnoremap <C-k> <C-y>
let mapleader=" "
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
noremap <space> <Nop>
nmap <C-p> :Telescope find_files<CR>
imap <C-c> <esc>
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'       : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'       : '<S-Tab>'
nmap <leader>/ :Telescope live_grep<CR>
nmap <leader>o :Telescope oldfiles<CR>
nmap <leader>f :Telescope buffers<CR>
nmap <leader>t :NvimTreeToggle<cr>
nmap <leader>s :ClangdSwitchSourceHeader<cr>
" map <C-/> :Commentary<CR>
map <C-/> :CommentToggle<CR>
map <C-_> :CommentToggle<CR>
nmap <leader>b :Gitsigns toggle_current_line_blame<CR>
nnoremap <leader>d "_d
vnoremap <C-j> :move '>+1<CR>gv=gv
vnoremap <C-k> :move '<-2<CR>gv=gv
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
nnoremap <leader>h :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>n :lua require("harpoon.ui").nav_next()<CR>
nnoremap <leader>p :lua require("harpoon.ui").nav_prev()<CR>
nnoremap <C-h> :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>1 :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>2 :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>3 :lua require("harpoon.ui").nav_file(5)<CR>
nnoremap <leader>4 :lua require("harpoon.ui").nav_file(7)<CR>
nnoremap <leader>5 :lua require("harpoon.ui").nav_file(9)<CR>
nnoremap <leader>6 :lua require("harpoon.ui").nav_file(11)<CR>
nnoremap <leader>7 :lua require("harpoon.ui").nav_file(13)<CR>
nnoremap <leader>8 :lua require("harpoon.ui").nav_file(15)<CR>
nnoremap <leader>9 :lua require("harpoon.ui").nav_file(17)<CR>
nnoremap <leader>0 :lua require("harpoon.ui").nav_file(19)<CR>

"Save as sudo"
cmap w!! w !sudo tee > /dev/null %

autocmd BufWritePost *.go :Neoformat
autocmd BufWritePost *.h :Neoformat
autocmd BufWritePost *.cpp :Neoformat

autocmd BufRead,BufNewFile *.ush set filetype=hlsl

autocmd StdinReadPre * let s:std_in=1
"augroup fmt
"  autocmd!
"  autocmd BufWritePre * Neoformat
"augroup END

call plug#begin()
" Plug 'tpope/vim-commentary'
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
Plug 'nvim-treesitter/nvim-treesitter', { 'branch': 'main' }
Plug 'nvim-treesitter/nvim-treesitter-textobjects', { 'branch': 'main' }
Plug 'sbdchd/neoformat'
Plug 'rafamadriz/friendly-snippets'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kylechui/nvim-surround'
Plug 'mhartington/formatter.nvim'
Plug 'p00f/clangd_extensions.nvim'
Plug 'nicwest/vim-camelsnek'
Plug 'terrortylor/nvim-comment'
Plug 'ThePrimeagen/harpoon'
Plug 'mfussenegger/nvim-lint'
Plug 'lervag/vimtex'
Plug 'lervag/vimtex', { 'tag': 'v2.15' }
call plug#end()

set background=dark
" let g:ale_linters = {
" \   'go': ['revive'],
" \}

let g:neoformat_only_msg_on_error = 1

let g:vimtex_view_method = 'zathura'
let g:vimtex_compiler_method = 'latexmk'
let maplocalleader = ","

lua<<EOF
require('nvim_comment').setup()

require("formatter").setup({
filetype = {
	go = {
		--require("formatter.filetypes.go").goimports,
	},
	["*"] = {
		--require("formatter.filetypes.any").remove_trailing_whitespace,
	},
},
})
require("nvim-surround").setup()

require('gitsigns').setup()

require('kanagawa').setup({
transparent = false,
})

local linecount = function()
return vim.api.nvim_buf_line_count(0)
end
vim.cmd("colorscheme kanagawa-wave")

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
prefer_startup_root = false,
hijack_directories = {
	enable = true,
	auto_open = false,
},
update_focused_file = {
	enable = true,
	update_root = false,
	ignore_list = {},
},
view = {
	width = {
		max = -1,
	},
	float = {
		enable = true,
	},
},
renderer = {
	add_trailing = true,
	indent_markers = {
		enable = true,
		inline_arrows = true,
	}
	},
filters = {
	},
})

-- nvim-treesitter `main` branch API (the old `master` branch was archived
-- 2026-04-03 and is broken on Nvim 0.12). `configs.setup{}` no longer exists:
-- parsers are installed via install(), highlighting via vim.treesitter.start().
local ts_parsers = {"bash", "c", "cmake", "commonlisp", "cpp", "css", "dockerfile", "go", "gomod", "gowork", "graphql", "haskell", "hlsl", "html", "java", "javascript", "jsdoc", "json", "json5", "jsonc", "latex", "llvm", "lua", "make", "markdown", "markdown_inline", "ninja", "perl", "proto", "python", "query", "regex", "ruby", "rust", "scala", "scheme", "scss", "sql", "svelte", "toml", "tsx", "typescript", "vim", "vue", "yaml"}

local ok_ts, ts = pcall(require, 'nvim-treesitter')
if ok_ts then
	ts.install(ts_parsers)  -- replaces `ensure_installed`; async, no-op if present
end

-- Enable treesitter highlighting per buffer (replaces `highlight.enable`).
-- `vim` is left on Vim's regex highlighting, matching the old `disable = {"vim"}`.
vim.api.nvim_create_autocmd('FileType', {
	callback = function(ev)
		if vim.bo[ev.buf].filetype == 'vim' then return end
		pcall(vim.treesitter.start, ev.buf)
	end,
})

-- Textobjects moved to its own `main`-branch API.
local ok_to, tobj = pcall(require, 'nvim-treesitter-textobjects')
if ok_to then
	tobj.setup { select = { lookahead = true } }
	vim.keymap.set({ "x", "o" }, "af", function()
		require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
	end)
	vim.keymap.set({ "x", "o" }, "if", function()
		require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
	end)
end
-- NOTE: incremental_selection (<C-l>/<C-h>) was removed upstream in the
-- rewrite and has no built-in replacement; those keymaps no longer work.

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
sorting = {
	comparators = {
		cmp.config.compare.offset,
		cmp.config.compare.exact,
		cmp.config.compare.recently_used,
		require("clangd_extensions.cmp_scores"),
		cmp.config.compare.kind,
		cmp.config.compare.sort_text,
		cmp.config.compare.length,
		cmp.config.compare.order,
	},
},

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

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.lsp.set_log_level("error")

-- FIX STARTS HERE
-- CHANGED: Manually defining config with explicit root_markers so the new 0.11 native client knows when to attach.
-- This bypasses the buggy default configs that were causing the failures.

-- 1. GOPLS
vim.lsp.config.gopls = {
	cmd = {"gopls", "serve"},
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	-- root_markers are CRITICAL for vim.lsp.enable to work in 0.11
	root_markers = { "go.work", "go.mod", ".git" },
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		gopls = {
			experimentalPostfixCompletions = false,
			usePlaceholders = true,
			staticcheck = true,
		},
	},
}
vim.lsp.enable("gopls")

vim.opt.list = true
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")   

-- 2. PYRIGHT
vim.lsp.config.pyright = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
	capabilities = capabilities,
	on_attach = on_attach,
}
vim.lsp.enable("pyright")

-- 3. CLANGD
vim.lsp.config.clangd = {
	name = 'clangd',
	cmd = {'clangd', '--background-index', '--clang-tidy', '--log=error','--completion-style=detailed', '--header-insertion-decorators'},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", "compile_flags.txt", ".git" },
	capabilities = capabilities,
	on_attach = on_attach,
	initialization_options = {
		fallback_flags = { '-std=c++17' },
	},
}
vim.lsp.enable("clangd")
-- FIX ENDS HERE

require("ibl").setup {
	debounce = 100,
	indent = { char = "|",tab_char = "|" },
	whitespace = { highlight = { "Whitespace", "NonText" } },
}

require'nvim-web-devicons'.setup {
	default = true;
}

require('telescope').setup{
defaults = {
	layout_strategy = 'vertical',
	layout_config = {
		vertical = { width = 0.9 },
	},
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
require("telescope").load_extension('harpoon')

require('lint').linters_by_ft = {
	markdown = {'go'},
}

EOF
