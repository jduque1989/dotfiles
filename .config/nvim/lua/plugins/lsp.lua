-- plugins/lsp.lua
return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
    },
    config = function()
      local lsp = require 'lsp-zero'
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'

      -- Load friendly snippets
      require('luasnip.loaders.from_vscode').lazy_load()

      lsp.preset 'recommended'

      -- Enhanced keymaps for Python development
      lsp.on_attach(function(client, bufnr)
        local bind = vim.keymap.set
        local opts = { buffer = bufnr }

        -- Navigation
        bind('n', 'gd', vim.lsp.buf.definition, opts)
        bind('n', 'gD', vim.lsp.buf.declaration, opts)
        bind('n', 'gi', vim.lsp.buf.implementation, opts)
        bind('n', 'gr', vim.lsp.buf.references, opts)
        bind('n', 'gt', vim.lsp.buf.type_definition, opts)

        -- Documentation
        bind('n', 'K', vim.lsp.buf.hover, opts)
        bind('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        bind('i', '<C-k>', vim.lsp.buf.signature_help, opts)

        -- Code actions
        bind('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        bind('v', '<leader>ca', vim.lsp.buf.code_action, opts)
        bind('n', '<leader>rn', vim.lsp.buf.rename, opts)

        -- Diagnostics
        bind('n', '[d', vim.diagnostic.goto_prev, opts)
        bind('n', ']d', vim.diagnostic.goto_next, opts)
        bind('n', '<leader>dl', vim.diagnostic.open_float, opts)
        bind('n', '<leader>dq', vim.diagnostic.setloclist, opts)

        -- Workspace
        bind('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        bind('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        bind('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)

        -- Formatting (if supported)
        if client.server_capabilities.documentFormattingProvider then
          bind('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end

        -- Enable inlay hints if supported (Python 3.11+)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end)

      -- Enhanced completion setup
      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { select = false },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'luasnip',  priority = 750 },
          { name = 'buffer',   priority = 500 },
          { name = 'path',     priority = 250 },
        },
        formatting = {
          format = function(entry, vim_item)
            -- Kind icons
            local kind_icons = {
              Text = '󰉿',
              Method = '󰆧',
              Function = '󰊕',
              Constructor = '',
              Field = '󰜢',
              Variable = '󰀫',
              Class = '󰠱',
              Interface = '',
              Module = '',
              Property = '󰜢',
              Unit = '󰑭',
              Value = '󰎠',
              Enum = '',
              Keyword = '󰌋',
              Snippet = '',
              Color = '󰏘',
              File = '󰈙',
              Reference = '󰈇',
              Folder = '󰉋',
              EnumMember = '',
              Constant = '󰏿',
              Struct = '󰙅',
              Event = '',
              Operator = '󰆕',
              TypeParameter = '',
            }
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
              nvim_lsp = '[LSP]',
              luasnip = '[Snip]',
              buffer = '[Buf]',
              path = '[Path]',
            })[entry.source.name]
            return vim_item
          end,
        },
      }

      require('mason').setup {
        ui = {
          border = 'rounded',
        },
      }

      require('mason-lspconfig').setup {
        -- Python-focused language servers
        ensure_installed = {
          'pyright',    -- Primary Python LSP
          'ruff',       -- Modern Python linter/formatter
          'basedpyright', -- Enhanced Python LSP (pyright fork)
          'lua_ls',     -- For Neovim config
        },
        handlers = {
          lsp.default_setup,

          -- Enhanced Pyright configuration
          pyright = function()
            require('lspconfig').pyright.setup {
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = 'workspace',
                    typeCheckingMode = 'standard', -- "off", "basic", "standard", "strict"
                    autoImportCompletions = true,
                    indexing = true,
                    packageIndexDepths = {
                      { name = 'django', depth = 2 },
                      { name = 'flask', depth = 2 },
                      { name = 'fastapi', depth = 2 },
                    },
                  },
                  defaultInterpreter = { 'python3' },
                },
                pyright = {
                  disableOrganizeImports = true, -- Using Ruff for this
                },
              },
            }
          end,

          -- Modern Ruff LSP for fast linting and formatting
          ruff = function()
            require('lspconfig').ruff.setup {
              init_options = {
                settings = {
                  args = {
                    '--extend-select=E,W,F,C,N,I',  -- Include imports
                    '--ignore=E501',                -- Line too long
                    '--fix',                        -- Auto-fix issues
                  },
                },
              },
              on_attach = function(client, bufnr)
                -- Disable hover in favor of Pyright
                client.server_capabilities.hoverProvider = false
              end,
            }
          end,

          -- BasedPyright (Enhanced Pyright fork)
          basedpyright = function()
            require('lspconfig').basedpyright.setup {
              settings = {
                basedpyright = {
                  analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = 'workspace',
                    typeCheckingMode = 'standard', -- "off", "basic", "standard", "strict"
                    autoImportCompletions = true,
                    diagnosticSeverityOverrides = {
                      reportUnusedImport = 'warning',
                      reportUnusedVariable = 'warning',
                    },
                  },
                },
              },
            }
          end,

          -- Alternative Python LSP (pylsp) with enhanced features
          pylsp = function()
            require('lspconfig').pylsp.setup {
              settings = {
                pylsp = {
                  plugins = {
                    -- Disable plugins that conflict with pyright
                    pylint = { enabled = false },
                    pyflakes = { enabled = false },
                    pycodestyle = { enabled = false },
                    mccabe = { enabled = false },

                    -- Keep useful plugins
                    rope_autoimport = { enabled = true },
                    rope_completion = { enabled = true },
                  },
                },
              },
            }
          end,
        },
      }

      -- Diagnostic configuration optimized for Python
      vim.diagnostic.config {
        virtual_text = {
          prefix = '●',
          source = 'if_many',
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      }

      -- Diagnostic signs
      vim.diagnostic.config {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
          },
        },
      }

      lsp.setup()
    end,
  },
}
