return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim', -- required
    'sindrets/diffview.nvim', -- optional, for side-by-side diffs
  },
  config = function()
    require('neogit').setup {
      integrations = {
        diffview = true,
      },
    }
  end,
  keys = {
    {
      '<leader>gh',
      function()
        require('neogit').open()
      end,
      desc = 'Open Neogit',
    },
  },
  cmd = 'Neogit',
}
