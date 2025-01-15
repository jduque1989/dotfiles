if vim.g.neovide then
  vim.opt.guifont = "MonoLisa:h24"

  vim.g.neovide_transparency = 0
  vim.g.transparency = 0.8
  vim.g.neovide_scroll_animation_length = 0.3
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_confirm_quit = true
  vim.g.neovide_input_macos_alt_is_meta = false
end

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.timeoutlen = 10

lvim.colorscheme = "tokyonight"
vim.g.tokyonight_style = "night"
lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua",
  timeout = 100,
}
lvim.log.level = "warn"
lvim.builtin.illuminate.active = false
lvim.builtin.bufferline.active = false
lvim.builtin.terminal.persist_mode = false
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.breadcrumbs.active = true
lvim.builtin.dap.active = true
lvim.keys.term_mode = { ["<C-l>"] = false }
lvim.transparent_window = true
lvim.builtin.bufferline.active = true
require("lvim.lsp.manager").setup("marksman")
vim.opt.showtabline = 0

-- Set options individually
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
-- vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.conceallevel = 0
vim.opt.fileencoding = "utf-8"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.mouse = "a"
vim.opt.pumheight = 10
vim.opt.showmode = false
vim.opt.showtabline = 0
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 100
vim.opt.writebackup = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.numberwidth = 2
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 0
vim.opt.sidescrolloff = 8
vim.opt.guifont = "monospace:h17"
vim.opt.title = true
vim.opt.titleold = vim.split(os.getenv("SHELL") or "", "/")[3]
vim.opt.fillchars = vim.opt.fillchars + "eob: "
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldnestmax = 10
vim.opt.foldminlines = 1

vim.opt.fillchars = vim.opt.fillchars + "eob: "
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldnestmax = 10 -- Maximum fold depth
vim.opt.foldminlines = 1 -- Minimum number of lines to create a fold

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work
