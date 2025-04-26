local M = {
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
}

return M
