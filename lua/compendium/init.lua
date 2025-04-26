local compendium = {}

local config = {
  notes_landing_dir = nil,
}

function compendium.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})

  if not config.notes_landing_dir or config.notes_landing_dir == "" then
    vim.notify(
      "[compendium.nvim] setup failed: notes_landing_dir is not configured. Please configure it via the setup function.",
      vim.log.levels.ERROR
    )
    return
  end

  config.notes_landing_dir = vim.fn.expand(config.notes_landing_dir)

  if vim.fn.isdirectory(config.notes_landing_dir) == 0 then
    vim.notify(
      "[compendium.nvim] setup failed: The configured notes_landing_dir does not exist: " .. config.notes_landing_dir,
      vim.log.levels.ERROR
    )
    return
  end

  vim.keymap.set("n", "<leader>nc", function()
    require("compendium.actions.create_note")({ notes_landing_dir = config.notes_landing_dir })
  end, { noremap = true, silent = true, desc = "[compendium.nvim] Create a new note" })

  vim.notify("[compendium.nvim] setup finished", vim.log.levels.INFO)
end

return compendium
