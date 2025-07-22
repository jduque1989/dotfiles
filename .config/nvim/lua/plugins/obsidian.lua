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
<<<<<<< HEAD
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
=======
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
>>>>>>> 600af2c (Organize dotfiles to get ready to be more maintanable)
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
<<<<<<< HEAD

  -- Command to create a new meeting minutes note using the template in the 'templates' folder
  vim.api.nvim_create_user_command('NewRockStart', function()
    -- Get the path to the template
    local template_path = '/Users/juandavidduquea/Library/Mobile Documents/iCloud~md~obsidian/Documents/DIGITAL BRAIN/templates/NewMeetingRockStart.template.md'
    local vault_path = '/Users/juandavidduquea/Library/Mobile Documents/iCloud~md~obsidian/Documents/DIGITAL BRAIN'
    local target_folder = vault_path .. '/Ciclos del Exito/RockStart'

    -- Ensure the target folder exists
    vim.fn.mkdir(target_folder, 'p')

    -- Read the template content
    local template_file = io.open(template_path, 'r')
    if not template_file then
      print('Template file not found: ' .. template_path)
      return
    end
    local template_content = template_file:read '*all'
    template_file:close()

    -- Create a new file with current timestamp
    local os_date = os.date '!%Y-%m-%d'
    local new_note_path = target_folder .. '/Meeting_' .. os_date .. '.md'

    -- Write the template content to the new file
    local new_file = io.open(new_note_path, 'w')
    if new_file then
      new_file:write(template_content)
      new_file:close()
      print('Meeting note created at: ' .. new_note_path)
    else
      print('Failed to create note at: ' .. new_note_path)
    end
  end, {}),
=======
>>>>>>> 600af2c (Organize dotfiles to get ready to be more maintanable)
}
