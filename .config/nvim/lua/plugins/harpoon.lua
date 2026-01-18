return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local harpoon = require 'harpoon'

      -- Initialize Harpoon 2
      harpoon.setup {}

      -- Keymaps for Harpoon 2 API
      vim.keymap.set('n', '<leader>m', function()
        harpoon:list():add()
      end, { desc = 'Mark file with Harpoon' })

      vim.keymap.set('n', '<leader>ht', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Toggle Harpoon menu' })

      -- Navigation to specific marks
      vim.keymap.set('n', '<leader>1', function()
        harpoon:list():select(1)
      end, { desc = 'Harpoon file 1' })

      vim.keymap.set('n', '<leader>2', function()
        harpoon:list():select(2)
      end, { desc = 'Harpoon file 2' })

      vim.keymap.set('n', '<leader>3', function()
        harpoon:list():select(3)
      end, { desc = 'Harpoon file 3' })

      vim.keymap.set('n', '<leader>4', function()
        harpoon:list():select(4)
      end, { desc = 'Harpoon file 4' })

      -- Navigate prev/next
      vim.keymap.set('n', '<leader>hp', function()
        harpoon:list():prev()
      end, { desc = 'Harpoon prev file' })

      vim.keymap.set('n', '<leader>hn', function()
        harpoon:list():next()
      end, { desc = 'Harpoon next file' })
    end,
  },
}
