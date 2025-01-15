return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'rcarriga/nvim-dap-ui',
      'mfussenegger/nvim-dap-python',
      'theHamsta/nvim-dap-virtual-text',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'
      local dap_python = require 'dap-python'

      require('dapui').setup {}
      require('nvim-dap-virtual-text').setup {
        commented = true, -- Show virtual text alongside comment
      }

      -- Dynamic Python setup for Poetry with fallback to .venv
      local function get_python_path()
        -- Locate the .venv directory dynamically
        local cwd = vim.fn.getcwd()
        local poetry_venv_path = vim.fn.trim(vim.fn.system 'poetry env info --path')
        local venv_path = cwd .. '/.venv/bin/python'

        -- Check if the Poetry virtualenv exists and return it, otherwise fallback to .venv
        if vim.fn.isdirectory(poetry_venv_path) == 1 then
          return poetry_venv_path .. '/bin/python'
        elseif vim.fn.executable(venv_path) == 1 then
          return venv_path
        else
          return '/usr/bin/python' -- Fallback to system Python
        end
      end

      -- Setup dap-python with the resolved Python path
      dap_python.setup(get_python_path())
      -- dap_python.setup 'python3'

      vim.fn.sign_define('DapBreakpoint', {
        text = '',
        texthl = 'DiagnosticSignError',
        linehl = '',
        numhl = '',
      })

      vim.fn.sign_define('DapBreakpointRejected', {
        text = '', -- or "❌"
        texthl = 'DiagnosticSignError',
        linehl = '',
        numhl = '',
      })

      vim.fn.sign_define('DapStopped', {
        text = '', -- or "→"
        texthl = 'DiagnosticSignWarn',
        linehl = 'Visual',
        numhl = 'DiagnosticSignWarn',
      })

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end

      local opts = { noremap = true, silent = true }

      -- Toggle breakpoint
      vim.keymap.set('n', '<leader>db', function()
        dap.toggle_breakpoint()
      end, opts)

      -- Continue / Start
      vim.keymap.set('n', '<leader>dc', function()
        dap.continue()
      end, opts)

      -- Step Over
      vim.keymap.set('n', '<leader>do', function()
        dap.step_over()
      end, opts)

      -- Step Into
      vim.keymap.set('n', '<leader>di', function()
        dap.step_into()
      end, opts)

      -- Step Out
      vim.keymap.set('n', '<leader>dO', function()
        dap.step_out()
      end, opts)

      -- Keymap to terminate debugging
      vim.keymap.set('n', '<leader>dq', function()
        require('dap').terminate()
      end, opts)

      -- Toggle DAP UI
      vim.keymap.set('n', '<leader>du', function()
        dapui.toggle()
      end, opts)
    end,
  },
}
