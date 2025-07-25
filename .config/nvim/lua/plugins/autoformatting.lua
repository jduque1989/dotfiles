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
                'black',        -- Python formatter (backup)
                'isort',        -- Python import sorter
                'mypy',         -- Python type checker
            },
            automatic_installation = true,
        }

        -- Configure null-ls sources
        local sources = {
            -- Diagnostics
            diagnostics.checkmake,
            require('none-ls.diagnostics.ruff').with {
                extra_args = { '--extend-select', 'I,N,W,E,F,C' },
            },
            diagnostics.mypy.with {
                extra_args = { '--python-executable', 'python3' },
            },
            -- Formatters
            formatting.prettier.with {
                filetypes = { 'html', 'json', 'yaml', 'markdown' },
            },
            formatting.stylua,
            formatting.shfmt.with {
                args = { '-i', '4' }, -- indent with 4 spaces
            },
            formatting.terraform_fmt,
            -- Python formatters (prefer ruff)
            require('none-ls.formatting.ruff_format').with {
                extra_args = { '--line-length', '88' },
            },
            formatting.isort.with {
                extra_args = { '--profile', 'black' },
            },
            -- Fallback Python formatter
            formatting.black.with {
                extra_args = { '--line-length', '88' },
            },
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
