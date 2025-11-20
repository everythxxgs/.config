vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.g.mapleader = ' '


local map = vim.keymap.set

map('n', '<leader>o', ':update<CR> :source<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>q', ':quit<CR>')
map('n', '<leader>lf', vim.lsp.buf.format)
map('n', '<leader>f', ":Pick files<CR>")
map('n', '<leader>h', ":Pick help<CR>")
map('n', '<leader>e', ":Oil<CR>")

map('n', '<leader><leader>', "Vyp")
map('n', '<leader>t', ":bo 10split <CR> :term <CR> i")
map('t', '<C-q>', [[<C-\><C-n>:q!<CR>]])
vim.keymap.set("i", "jk", "<Esc>", { noremap = true })

map({ "n", "x" }, "<leader>y", '"+y')
map({ "n", "x" }, "<leader>d", '"+d')
map({ "i", "s" }, "<C-e>", function() ls.expand_or_jump(1) end, { silent = true })
map({ "i", "s" }, "<C-J>", function() ls.jump(1) end, { silent = true })
map({ "i", "s" }, "<C-K>", function() ls.jump(-1) end, { silent = true })


vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/navarasu/onedark.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },


})

local ls = require("luasnip")
require "mini.pick".setup()
require "oil".setup({
	columns = {
		"icon",
		-- "permissions",
		-- "size",
		-- "mtime",
	},
		keymaps = {
    ["<C-l>"] = "actions.refresh",
    ["<C-p>"] = "actions.preview",
    ["g."] = { "actions.toggle_hidden", mode = "n" },

		}

})

require 'onedark'.setup({
	style = 'darker',
	colors = {
		bg0 = '#101010', -- ← your custom background color
	},
	highlights = {
		['@tag'] = { fg = '$red' },
		['@tag.attribute'] = { fg = '$yellow' },
		['@tag.delimiter'] = { fg = '$fg' },
		['@tag.builtin'] = { fg = '$red' },
	}
})
require('onedark').load()
require "mason".setup()



require 'nvim-treesitter.configs'.setup({
	ensure_installed = { "svelte", "typescript", "javascript", "html", "css", "lua", "python" },
	sync_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
	auto_install = true,
})

-- Ensure Svelte files use proper parser
vim.treesitter.language.register('svelte', 'svelte')

-- Ensure proper filetype detection for Svelte
vim.filetype.add({
	extension = {
		svelte = 'svelte',
	}
})

 local lspconfig = require('lspconfig')
-- Basic LSP servers
vim.lsp.enable({ 	"lua_ls", "cssls", "svelte", "tinymist", "svelteserver",
	"rust_analyzer", "clangd", "ruff",
	"glsl_analyzer", "haskell-language-server", "hlint",
	"intelephense", "biome", "tailwindcss",
	"ts_ls", "emmet_language_server", "emmet_ls", "solargraph"
	})



vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

vim.api.nvim_create_autocmd("FileType", {

  pattern = "typst",

  callback = function()
    vim.opt_local.wrap = true
	vim.opt_local.linebreak = true
	vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_gb"  -- or "en_us"
  end,
})



