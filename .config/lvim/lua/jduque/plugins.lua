lvim.plugins = {
  { "lunarvim/colorschemes" },
  { "lervag/vimtex" },
  { "folke/tokyonight.nvim" },
  { "arcticicestudio/nord-vim" },
  { "mfussenegger/nvim-jdtls" },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("lvim.core.indentlines").setup()
    end,
    event = "User FileOpened",
    enabled = lvim.builtin.indentlines.active,
  },
  { "Exafunction/codeium.vim" },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup {}
    end
  },
  { "ChristianChiarulli/swenv.nvim" },
  { "AckslD/swenv.nvim" },
  { "stevearc/dressing.nvim" },
  { "mfussenegger/nvim-dap-python" },
  { "kylechui/nvim-surround" },
  {
    "AckslD/nvim-trevJ.lua",
    config = 'require("trevj").setup()', -- optional call for configurating non-default filetypes etc
    init = function()
      vim.keymap.set('n', '<leader>j', function()
        require('trevj').format_at_cursor()
      end)
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function() vim.cmd("do User LspAttachBuffers") end,
    ft = { "markdown" },
  },
  {
    'wfxr/minimap.vim',
    build = "cargo install --locked code-minimap",
    -- cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
    config = function()
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start = 1")
      vim.cmd("let g:minimap_auto_start_win_enter = 1")
    end,
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",                         -- Load on-demand for performance
    lazy = false,                               -- Ensure plugin loads immediately when required
    version = false,                            -- Always use the latest version of Avante.nvim
    build = "make",                             -- Use `make` to build Avante.nvim
    opts = {
      provider = "openai",
      openai = {
        -- endpoint = "https://api.openai.com/v1",
        model = "gpt-4o-mini",
        -- timeout = 30000,
        -- temperature = 0,
        -- max_tokens = 4096,
        -- api_key = os.getenv("OPENAI_API_KEY"), -- Load API key from environment variable
      },
    },
    dependencies = {
      "stevearc/dressing.nvim",      -- Required for enhanced UI
      "nvim-lua/plenary.nvim",       -- Utility library
      "MunifTanjim/nui.nvim",        -- UI components
      "hrsh7th/nvim-cmp",            -- Autocompletion for Avante commands
      "nvim-tree/nvim-web-devicons", -- File type icons
      "zbirenbaum/copilot.lua",      -- Optional: Integrate GitHub Copilot
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy", -- Load lazily
        opts = {
          default = {
            embed_image_as_base64 = false, -- Avoid base64 embedding for performance
            prompt_for_file_name = false,  -- No prompt for file names
            drag_and_drop = {
              insert_mode = true,          -- Enable drag-and-drop in insert mode
            },
            use_absolute_path = false,     -- macOS doesn't need absolute paths
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" }, -- Enhanced Markdown support
        },
        ft = { "markdown", "Avante" },           -- Lazy-load for Markdown and Avante files
      },
    },
  },
}
