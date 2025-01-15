return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown', -- Load only for markdown files
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required
  },
  opts = {
    workspaces = {
      {
        name = 'personal',
        path = '/Users/juandavidduquea/Library/Mobile Documents/iCloud~md~obsidian/Documents/DIGITAL BRAIN',
      },
      {
        name = 'Libros',
        path = '/Users/juandavidduquea/Library/Mobile Documents/iCloud~md~obsidian/Documents/DIGITAL BRAIN/Libros',
      },
    },
    templates = {
      folder = '/Users/juandavidduquea/Library/Mobile Documents/iCloud~md~obsidian/Documents/DIGITAL BRAIN/Templates',
      book_review = [[
---
Title: 
Author: 
Tags: 
  - books
  - abstract
Status: 
Rating: 
Published: 
ISBN: 
Read_Start: 
Read_End: 
Categories: 
  - 
Keywords: 
  - 
URL: 
Summary: 
---

# {{Title}}

**Author:** {{Author}}

## Key Takeaways
- 

## Insights & Applications
- 

## Favorite Quotes
- 
]],
    },
  },
  config = function(_, opts)
    local obsidian = require 'obsidian'

    -- Set up the plugin with user-defined options
    obsidian.setup(opts)

    -- Command to insert a book review template
    vim.api.nvim_create_user_command('InsertBookReview', function()
      -- Prompt for the title of the book
      local title = vim.fn.input 'Book Title: '
      local path = opts.workspaces[2].path .. '/' .. title:gsub(' ', '_') .. '.md'

      -- Template content
      local template = opts.templates.book_review:gsub('{{Title}}', title):gsub('{{Author}}', '')

      -- Write the template to the file
      local file = io.open(path, 'w')
      if file then
        file:write(template)
        file:close()
        print('Book review note created at: ' .. path)
      else
        print 'Error: Could not create the note.'
      end
    end, {})
  end,
}
