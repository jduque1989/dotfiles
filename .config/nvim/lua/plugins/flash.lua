return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {
    -- labels for jump targets
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      -- search/jump in all windows
      multi_window = true,
      -- search direction
      forward = true,
      -- when `false`, find only matches in the given direction
      wrap = true,
      -- Each mode will take ignorecase and smartcase into account.
      mode = "exact",
      -- behave like `incsearch`
      incremental = false,
    },
    jump = {
      -- automatically jump when there is only one match
      autojump = false,
    },
    label = {
      -- allow uppercase labels
      uppercase = true,
      -- add any labels with the correct case here, that you want to exclude
      exclude = "",
      -- add a label for the first match in the current window.
      current = true,
      -- show the label after the match
      after = true,
      -- show the label before the match
      before = false,
      -- position of the label extmark
      style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
    },
    modes = {
      -- options used when flash is activated through
      -- a regular search with `/` or `?`
      search = {
        enabled = true,
      },
      -- options used when flash is activated through
      -- `f`, `F`, `t`, `T`, `;` and `,` motions
      char = {
        enabled = true,
        -- hide after jump when not using jump labels
        autohide = false,
        -- show jump labels
        jump_labels = false,
      },
    },
  },
  -- stylua: ignore
  keys = {
    -- Original keybindings (keep for muscle memory)
    { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash Jump" },
    { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    
    -- Leader key integrations for which-key menu
    { "<leader>fj", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash Jump" },
    { "<leader>ft", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "<leader>fr", mode = "o",               function() require("flash").remote() end,            desc = "Flash Remote" },
    { "<leader>fw", mode = { "n", "x", "o" }, function() require("flash").jump({ search = { mode = "search", max_length = 0 } }) end, desc = "Flash Word" },
    { "<leader>fl", mode = { "n", "x", "o" }, function() require("flash").jump({ search = { mode = "search", max_length = 0 }, label = { after = false, before = true } }) end, desc = "Flash Line" },
  },
}
