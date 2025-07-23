-- NvimTree replacement: Neotree configuration
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
      'MunifTanjim/nui.nvim',
    },
    config = function()
      -- Leader shortcuts
      vim.keymap.set('n', '<leader>e', ':Neotree reveal toggle<CR>', { desc = ' Toggle Explorer (reveal)' })
      vim.keymap.set('n', '<leader>E', ':Neotree toggle<CR>', { desc = ' Toggle Explorer (simple)' })

      require('neo-tree').setup {
        close_if_last_window = false, -- do not close Neo-tree if it's the last window
        popup_border_style = 'rounded',
        enable_git_status = true,
        enable_diagnostics = true,

        window = {
          position = 'left',
          width = 32,
          mappings = {
            ['<space>'] = 'none', -- disable space toggle node
          },
        },

        filesystem = {
          filtered_items = {
            visible = true, -- show hidden files
            show_hidden_count = true,
            hide_dotfiles = false,
            hide_gitignored = true,
            never_show = {},
          },
          follow_current_file = {
            enabled = true, -- auto-focus the current file in tree
            leave_dirs_open = false,
          },
          use_libuv_file_watcher = true,
        },

        buffers = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = true,
          },
        },

        git_status = {
          window = {
            position = 'float',
          },
        },

        event_handlers = {
          {
            event = 'file_opened',
            handler = function()
              require('neo-tree.command').execute { action = 'close' }
            end,
          },
        },
      }
    end,
  },
}
