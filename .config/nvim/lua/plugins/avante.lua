return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = false,
  opts = {
    provider = 'openai',
    providers = {
      openai = {
        endpoint = 'https://api.openai.com/v1',
        model = 'gpt-5-mini',
        api_key = vim.env.OPENAI_API_KEY,
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          -- temperature = 0,
          max_completion_tokens = 8192,
        },
      },
    },
  },
  build = 'make',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'hrsh7th/nvim-cmp', -- for autocompletion
    'nvim-tree/nvim-web-devicons',
    'zbirenbaum/copilot.lua',
    'echasnovski/mini.pick',         -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'ibhagwan/fzf-lua',              -- for file_selector provider fzf
    {
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
