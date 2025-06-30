return {
  'akinsho/toggleterm.nvim',
  version = '*', -- use latest tagged version
  config = function()
    require('toggleterm').setup {
      -- customize here
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'horizontal', -- or "vertical" | "float" | "tab"
      close_on_exit = true,
      shell = vim.o.shell,
    }
  end,
}
