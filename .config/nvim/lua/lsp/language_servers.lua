
-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig').html.setup {
  capabilities = capabilities,
}
require'lspconfig'.cssls.setup{
  capabilities = capabilities,
}

require'lspconfig'.tsserver.setup{
  capabilities = capabilities,
}

require'lspconfig'.texlab.setup{
  capabilities = capabilities,
}

require'lspconfig'.pylsp.setup{
  capabilities = capabilities,
}
require'lspconfig'.phpactor.setup{
  capabilities = capabilities,
}
require'lspconfig'.bashls.setup{
  capabilities = capabilities,
}
