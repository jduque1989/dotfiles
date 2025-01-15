local banners = require 'Plugins.banners' -- Replace with the actual path to your banners file

return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    -- Select a random banner
    math.randomseed(os.time())
    local random_banner = banners[math.random(#banners)]

    require('dashboard').setup {
      theme = 'hyper', -- Set the theme to hyper
      config = {
        header = random_banner, -- Use the random banner
        shortcut = {
          { desc = '󰀶  Update Plugins', group = '@property', action = 'PackerSync', key = 'u' },
          { desc = '  New File', group = '@property', action = 'enew', key = 'n' },
          { desc = '󰒅  Recent Files', group = '@property', action = 'Telescope oldfiles', key = 'r' },
          { desc = '  Find File', group = '@property', action = 'Telescope find_files', key = 'f' },
          { desc = '󰭚  Quit', group = '@property', action = 'qa!', key = 'q' },
        },
        footer = { 'Code, Build, Innovate 🚀' },
      },
    }
  end,
  dependencies = { { 'nvim-tree/nvim-web-devicons' } },
}
