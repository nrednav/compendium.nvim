local get_formatted_datetime = require("compendium.utils.get_formatted_datetime")
local telescope_utils = require("compendium.utils.telescope")

local function get_selected_template(opts)
  local selection = opts.telescope_actions_state.get_selected_entry()

  opts.telescope_actions.close(opts.prompt_bufnr)

  if not selection then
    vim.notify("[compendium.nvim] insert_template action cancelled: No template was selected", vim.log.levels.WARN)
    return
  end

  local template_filepath = vim.fs.joinpath(opts.templates_dir, selection.value)

  if not template_filepath then
    vim.notify(
      "[compendium.nvim] insert_template action failed: Could not get filepath for selected template",
      vim.log.levels.ERROR
    )
    return
  end

  return template_filepath
end

local function insert_template(opts)
  if not opts.templates_dir or opts.templates_dir == "" then
    vim.notify(
      "[compendium.nvim] insert_template action failed: templates_dir is not configured.",
      vim.log.levels.ERROR
    )
    return
  end

  if vim.fn.isdirectory(opts.templates_dir) == 0 then
    vim.notify(
      "[compendium.nvim] insert_template action failed: The configured templates_dir does not exist: "
        .. opts.templates_dir,
      vim.log.levels.ERROR
    )
    return
  end

  local telescope_ok, telescope = pcall(require, "telescope.builtin")
  local telescope_actions_ok, telescope_actions = pcall(require, "telescope.actions")
  local telescope_actions_state_ok, telescope_actions_state = pcall(require, "telescope.actions.state")

  if not (telescope_ok and telescope_actions_ok and telescope_actions_state_ok) then
    vim.notify(
      "[compendium.nvim] insert_template action failed: telescope.nvim plugin or its components not found.",
      vim.log.levels.ERROR
    )
    return
  end

  local themed_find_files = telescope_utils.apply_theme(opts.telescope_theme, telescope.find_files, {
    prompt_title = "Select template to insert",
    cwd = opts.templates_dir,
    hidden = true,
    attach_mappings = function(prompt_bufnr, map)
      local function handle_insert_selection()
        local template_filepath = get_selected_template({
          telescope_actions_state = telescope_actions_state,
          telescope_actions = telescope_actions,
          prompt_bufnr = prompt_bufnr,
          templates_dir = opts.templates_dir,
        })

        if not template_filepath then
          return
        end

        local read_ok, template_content_or_err = pcall(vim.fn.readfile, template_filepath)

        if not read_ok then
          vim.notify(
            string.format(
              "[compendium.nvim] insert_template action failed: Could not read contents of template file: %s. Error: %s",
              template_filepath,
              tostring(template_content_or_err)
            ),
            vim.log.levels.ERROR
          )
          return
        end

        local template_content = template_content_or_err

        if opts.insert_datetime_header then
          local datetime_header = {
            get_formatted_datetime(),
            "",
          }

          for i = #datetime_header, 1, -1 do
            table.insert(template_content, 1, datetime_header[i])
          end
        end

        table.insert(template_content, "")

        local insert_row = 0
        local insert_col = 0

        local insert_ok, insert_err =
          pcall(vim.api.nvim_buf_set_text, 0, insert_row, insert_col, insert_row, insert_col, template_content)

        if not insert_ok then
          vim.notify(
            string.format(
              "[compendium.nvim] insert_template action failed: Could not insert template content into buffer. Error: %s",
              tostring(insert_err)
            ),
            vim.log.levels.ERROR
          )
          return
        end

        vim.notify(
          string.format("[compendium.nvim] Inserted template at start: %s", vim.fn.fnamemodify(template_filepath, ":t")),
          vim.log.levels.INFO
        )
      end

      map("i", "<CR>", handle_insert_selection)
      map("n", "<CR>", handle_insert_selection)

      return true
    end,
  })

  if themed_find_files then
    pcall(themed_find_files)
  else
    vim.notify(
      "[compendium.nvim] insert_template action failed: could not prepare telescope action",
      vim.log.levels.WARN
    )
  end
end

return insert_template
