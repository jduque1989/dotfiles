-- Key mappings configuration for Neovim

-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- Save and quit
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', opts)
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w<CR>', opts)
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', opts)

-- Delete character without copying
vim.keymap.set('n', 'x', '"_x', opts)

-- Center scroll
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)

-- Center search
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Resize splits
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts)
vim.keymap.set('n', '<leader>b', '<cmd>enew<CR>', opts)

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts)
vim.keymap.set('n', '<leader>-', '<C-w>s', opts)
vim.keymap.set('n', '<leader>se', '<C-w>=', opts)
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts)

-- Move between windows
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts)
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts)
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts)
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts)

-- Toggle wrap
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Diagnostics
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>;', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- RipSubstitute
vim.keymap.set({ 'n', 'x' }, '<leader>fs', function()
  require('rip-substitute').sub()
end, { desc = ' rip substitute' })

-- Avante
vim.keymap.set('n', '<leader>av', '<cmd>AvanteAsk<CR>', { desc = 'Avante Ask' })

-- ToggleTerm
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })
vim.keymap.set('n', '<leader>tf', function()
  require('toggleterm.terminal').Terminal:new({ direction = 'float' }):toggle()
end, { desc = 'Toggle floating terminal' })
