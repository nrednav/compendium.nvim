# compendium.nvim

A plugin to help manage a collection of notes.

## Table of Contents

- [About](#about)
- [Getting Started](#getting-started)
  - [Dependencies](#dependencies)
  - [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)

## About

`compendium.nvim` is a plugin that helps you manage a central collection of
notes.

With the help of [Telescope](https://github.com/nvim-telescope/telescope.nvim),
you can quickly create and find notes from within any neovim session.

## Getting Started

### Dependencies

- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

### Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'nrednav/compendium.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim'
  },
  config = function()
    require('compendium').setup({
      -- Required configuration
      landing_dir = "/path/to/where/all/new/notes/will/live",
      templates_dir = "/path/to/where/templates/will/live"
    })
  end
}
```

## Usage

- To create a new note: `<leader>cc`
- To create a new note from a template: `<leader>ct`
- To create a new note from a template, in the current working directory: `<leader>cT`
- To find notes in the collection: `<leader>cf`
- To insert a template into the currently open buffer: `<leader>ci`

## Configuration

Defaults:
```lua
{
  'nrednav/compendium.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim'
  },
  config = function()
    require('compendium').setup({
      -- Directory where your notes are stored
      landing_dir = nil,
      -- Directory where your templates are stored
      templates_dir = nil,
      -- When true, automatically inserts a formatted datetime header when inserting a template
      -- Format = YYYY - MMMM DD, hh:mm
      insert_datetime_header = false,
      -- Key mappings for plugin actions
      action_keymap = {
        create_note = "<leader>cc",
        find_notes = "<leader>cf",
        create_note_from_template = "<leader>ct",
        create_cwd_note_from_template = "<leader>cT",
        insert_template = "<leader>ci",
      },
      -- Whether to setup the keymaps defined in action_keymap automatically
      setup_keymaps = true,
      -- The telescope theme to use (e.g. default (no theme), ivy (fallback), dropdown, or cursor)
      telescope_theme = "default",
    })
  end
}
```
