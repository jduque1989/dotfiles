-- Author: Juan David Duque
-- Claude Code integration for AI-assisted coding
return {
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' }, -- UI components for notifications
    config = true, -- Use default configuration
    keys = {
      -- Leader prefix for all AI commands
      { '<leader>a', nil, desc = 'AI/Claude Code' },

      -- Core Claude Code commands
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' }, -- Open/close Claude interface
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' }, -- Switch focus to Claude window
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' }, -- Resume last session
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' }, -- Continue conversation
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' }, -- Switch AI model

      -- Context management
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' }, -- Add current file to context
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' }, -- Send visual selection
      {
        '<leader>as',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' }, -- Works in file explorers
      },

      -- Diff management - accept/reject Claude's code suggestions
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
  },
}
