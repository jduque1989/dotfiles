return {
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap', 
      'mfussenegger/nvim-dap-python',
      { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
    lazy = false,
    branch = 'regexp',
    config = function()
      require('venv-selector').setup {
        settings = {
          options = {
            notify_user_on_venv_activation = true,
          },
        },
      }
    end,
    keys = {
      { '<leader>vs', '<cmd>VenvSelect<cr>' },
      { '<leader>vc', '<cmd>VenvSelectCached<cr>' },
    },
  },
  {
    'Vimjas/vim-python-pep8-indent',
    ft = 'python',
  },
  {
    'jeetsukumaran/vim-pythonsense',
    ft = 'python',
  },
  {
    'raimon49/requirements.txt.vim',
    ft = 'requirements',
  },
}