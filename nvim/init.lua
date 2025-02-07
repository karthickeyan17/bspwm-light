-- Enable true colors for better visuals
vim.opt.termguicolors = true

-- Install Packer (Plugin Manager) if not installed
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  vim.cmd('!git clone --depth 1 https://github.com/wbthomason/packer.nvim '..install_path)
  vim.cmd 'packadd packer.nvim'
end

-- Load Plugins (Only lightweight ones)
require("packer").startup(function(use)
  use "wbthomason/packer.nvim"  -- Plugin manager
  use "EdenEast/nightfox.nvim"  -- Cool lightweight theme
  use "nvim-lualine/lualine.nvim"  -- Minimal status bar
  use "neovim/nvim-lspconfig"  -- Lightweight LSP (for Python autocompletion)
  use "hrsh7th/nvim-cmp"  -- Fast autocompletion
  use "hrsh7th/cmp-nvim-lsp"  -- LSP source for nvim-cmp
end)

-- Set Colorscheme (Nightlight Transparent)
vim.cmd("colorscheme dawnfox")
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")  -- Transparent background
vim.cmd("hi EndOfBuffer guibg=NONE ctermbg=NONE")

-- Status Bar (Minimal)
require("lualine").setup {
  options = { theme = "nightfox" }
}

-- Python Autocompletion (LSP)
require("lspconfig").pyright.setup{}  -- Lightweight Python LSP

-- Autocomplete Setup
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = "nvim_lsp" },
  }
})

-- Basic UI Tweaks
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.showmode = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.scrolloff = 10

