-- Neovim configuration file for setting options and managing plugins
-- Author: Juan David Duque
-- Year: 2025
-- Version: V1
require 'core.options'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  require 'plugins.colortheme',
  require 'plugins.misc',
  require 'plugins.neotree',
  require 'plugins.bufferline',
  require 'plugins.lualine',
  require 'plugins.treesitter',
  require 'plugins.telescope',
  require 'plugins.lsp',
  require 'plugins.autocompletion',
  require 'plugins.autoformatting',
  require 'plugins.gitsigns',
  require 'plugins.dashboard',
  require 'plugins.indent-blankline',
  require 'plugins.avante',
  require 'plugins.codeium',
}
vim.defer_fn(function()
  require 'plugins.nvim-dap'
  require 'plugins.obsidian'
  require 'core.keymaps'
end, 20)
