return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2', -- Ensure this branch exists and is stable
    dependencies = { -- Add required dependencies explicitly
      'nvim-lua/plenary.nvim', -- Required dependency for harpoon
      'nvim-telescope/telescope.nvim', -- Optional: For Telescope integration
    },
    config = function()
      local harpoon = require 'harpoon'

      -- Initialize Harpoon
      harpoon.setup {}

      -- Keymaps
      vim.keymap.set('n', '<leader>m', function()
        require('harpoon.mark').add_file()
      end, { desc = 'Mark file with Harpoon' })

      vim.keymap.set('n', '<leader>ht', function()
        require('harpoon.ui').toggle_quick_menu()
      end, { desc = 'Toggle Harpoon menu' })

      -- Telescope Integration
      local conf = require('telescope.config').values

      local function toggle_telescope()
        local harpoon_mark = require 'harpoon.mark'
        local marks = harpoon_mark.get_marked_files() -- Fetch marked files

        local file_paths = {}
        for _, item in ipairs(marks) do
          if item.filename then
            table.insert(file_paths, item.filename) -- Use the correct field for file paths
          else
            table.insert(file_paths, item) -- Fallback if no `filename` field
          end
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>sp', toggle_telescope, { desc = 'Open Harpoon with Telescope' })
    end,
  },
}
