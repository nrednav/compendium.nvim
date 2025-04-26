local compendium = {}

local config = {
  landing_dir = nil,
}

function compendium.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})

  if not config.landing_dir or config.landing_dir == "" then
    vim.notify(
      "[compendium.nvim] setup failed: landing_dir is not configured. Please configure it via the setup function.",
      vim.log.levels.ERROR
    )
    return
  end

  config.landing_dir = vim.fn.expand(config.landing_dir)

  if vim.fn.isdirectory(config.landing_dir) == 0 then
    vim.notify(
      "[compendium.nvim] setup failed: The configured landing_dir does not exist: " .. config.landing_dir,
      vim.log.levels.ERROR
    )
    return
  end

  vim.keymap.set("n", "<leader>nc", function()
    require("compendium.actions.create_note")({ landing_dir = config.landing_dir })
  end, { noremap = true, silent = true, desc = "[compendium.nvim] Create a new note" })

  vim.keymap.set("n", "<leader>nf", function()
    require("compendium.actions.find_notes")({ landing_dir = config.landing_dir })
  end, { noremap = true, silent = true, desc = "[compendium.nvim] Find notes" })
end

return compendium
