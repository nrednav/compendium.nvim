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
      landing_dir = nil,
      templates_dir = nil,
      insert_datetime_header = false,
      action_keymap = {
        create_note = "<leader>cc",
        find_notes = "<leader>cf",
        create_note_from_template = "<leader>ct",
        create_cwd_note_from_template = "<leader>cT",
      },
      setup_keymaps = true,
    })
  end
}
```
