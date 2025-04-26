local compendium = {}

local config = {
  landing_dir = nil,
  templates_dir = nil,
}

function compendium.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})

  config.landing_dir = vim.fn.expand(config.landing_dir)
  config.templates_dir = vim.fn.expand(config.templates_dir)

  vim.keymap.set("n", "<leader>nc", function()
    require("compendium.actions.create_note")({ landing_dir = config.landing_dir })
  end, { noremap = true, silent = true, desc = "[compendium.nvim] Create a new note" })

  vim.keymap.set("n", "<leader>nf", function()
    require("compendium.actions.find_notes")({ landing_dir = config.landing_dir })
  end, { noremap = true, silent = true, desc = "[compendium.nvim] Find notes" })

  vim.keymap.set("n", "<leader>nt", function()
    require("compendium.actions.create_note_from_template")({
      landing_dir = config.landing_dir,
      templates_dir = config.templates_dir,
    })
  end, { noremap = true, silent = true, desc = "[compendium.nvim] Create a new note from a template" })
end

return compendium
