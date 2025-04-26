local compendium = {}

local config = require("compendium.data.config")

local actions = {}

function compendium.setup(user_config)
  config = vim.tbl_deep_extend("force", config, user_config or {})

  config.landing_dir = vim.fn.expand(config.landing_dir)
  config.templates_dir = vim.fn.expand(config.templates_dir)

  actions = {
    create_note = {
      fn = function()
        require("compendium.actions.create_note")({
          landing_dir = config.landing_dir,
          insert_datetime_header = config.insert_datetime_header,
        })
      end,
      mode = "n",
      opts = {
        noremap = true,
        silent = true,
        desc = "Create a new note",
      },
    },
    find_notes = {
      fn = function()
        require("compendium.actions.find_notes")({ landing_dir = config.landing_dir })
      end,
      mode = "n",
      opts = {
        noremap = true,
        silent = true,
        desc = "Find notes",
      },
    },
    create_note_from_template = {
      fn = function()
        require("compendium.actions.create_note_from_template")({
          landing_dir = config.landing_dir,
          templates_dir = config.templates_dir,
          insert_datetime_header = config.insert_datetime_header,
        })
      end,
      mode = "n",
      opts = {
        noremap = true,
        silent = true,
        desc = "Create a new note from a template",
      },
    },
    create_cwd_note_from_template = {
      fn = function()
        require("compendium.actions.create_note_from_template")({
          landing_dir = vim.loop.cwd(),
          templates_dir = config.templates_dir,
          insert_datetime_header = config.insert_datetime_header,
        })
      end,
      mode = "n",
      opts = {
        noremap = true,
        silent = true,
        desc = "Create a new note from a template, in the current working directory",
      },
    },
  }

  if config.setup_keymaps then
    for action_name, keymap_info in pairs(actions) do
      local key = config.action_keymap[action_name]

      if key and type(key) == "string" and key ~= "" then
        vim.keymap.set(keymap_info.mode, key, keymap_info.fn, keymap_info.opts)
      end
    end
  end
end

return compendium
