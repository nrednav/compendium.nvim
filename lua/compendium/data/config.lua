-- data/config.lua
-- Default configuration for compendium.nvim

local M = {
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
}

return M
