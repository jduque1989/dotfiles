-- autoformatting.lua
return {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'nvimtools/none-ls-extras.nvim',
        'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
    },
    config = function()
        local null_ls = require('null-ls')
        local formatting = null_ls.builtins.formatting -- to setup formatters
        local diagnostics = null_ls.builtins.diagnostics -- to setup linters

        -- Formatters & linters for mason to install
        require('mason-null-ls').setup {
            ensure_installed = {
                'prettier',     -- ts/js formatter
                'stylua',       -- lua formatter
                'eslint_d',     -- ts/js linter
                'shfmt',        -- Shell formatter
                'checkmake',    -- Linter for Makefiles
                'ruff',         -- Python linter and formatter
            },
            automatic_installation = true,
        }

        -- Configure null-ls sources
        local sources = {
            -- Diagnostics
            diagnostics.checkmake,
            -- Formatters
            formatting.prettier.with {
                filetypes = { 'html', 'json', 'yaml', 'markdown' },
            },
            formatting.stylua,
            formatting.shfmt.with {
                args = { '-i', '4' }, -- indent with 4 spaces
            },
            formatting.terraform_fmt,
            require('none-ls.formatting.ruff').with {
                extra_args = { '--extend-select', 'I' },
            },
            require('none-ls.formatting.ruff_format'), -- Add ruff formatting
        }

        -- Set up augroup for formatting on save
        local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

        null_ls.setup {
            sources = sources,
            -- Optional: Enable debug mode
            -- debug = true,
            on_attach = function(client, bufnr)
                if client.supports_method('textDocument/formatting') then
                    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format { async = false }
                        end,
                    })
                end
            end,
        }
    end,
}