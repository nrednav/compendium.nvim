local get_formatted_datetime = require("compendium.utils.get_formatted_datetime")

local function apply_theme(command, opts)
  local themes = require("telescope.themes")
  return function()
    command(themes.get_ivy(opts))
  end
end

local function get_selected_template(opts)
  local selection = opts.telescope_actions_state.get_selected_entry()

  opts.telescope_actions.close(opts.prompt_bufnr)

  if not selection then
    vim.notify("[compendium.nvim] create_note_from_template cancelled: No template was selected", vim.log.levels.WARN)
    return
  end

  local template_filepath = vim.fs.joinpath(opts.templates_dir, selection.value)

  if not template_filepath then
    vim.notify(
      "[compendium.nvim] create_note_from_template failed: Could not get filepath for selected template",
      vim.log.levels.ERROR
    )
    return
  end

  return template_filepath
end

local function create_note(opts)
  vim.ui.input({ prompt = "Enter filename: " }, function(filename)
    if filename == nil or filename == "" then
      vim.notify(
        "[compendium.nvim] create_note_from_template action cancelled: No filename was provided.",
        vim.log.levels.WARN
      )
      return
    end

    local filepath = vim.fs.joinpath(opts.landing_dir, filename)

    if vim.fn.filereadable(filepath) == 1 then
      vim.notify(
        "[compendium.nvim] create_note_from_template action failed: File already exists: " .. filepath,
        vim.log.levels.ERROR
      )
      return
    end

    local read_ok, template_content_or_err = pcall(vim.fn.readfile, opts.template_filepath)

    if not read_ok then
      vim.notify(
        string.format(
          "[compendium.nvim] create_note_from_template action failed: Could not read contents of template file: %s. Error: %s",
          opts.template_filepath,
          tostring(template_content_or_err)
        ),
        vim.log.levels.ERROR
      )
      return
    end

    local file_content = template_content_or_err

    if opts.insert_datetime_header then
      local datetime_header = {
        get_formatted_datetime(),
        "",
      }

      for i = #datetime_header, 1, -1 do
        table.insert(file_content, 1, datetime_header[i])
      end
    end

    local write_ok, write_err = pcall(vim.fn.writefile, file_content, filepath)

    if not write_ok then
      vim.notify(
        string.format(
          "[compendium.nvim] create_note_from_template action failed: Could not write template contents to new file: %s. Error: %s",
          opts.template_filepath,
          tostring(write_err)
        ),
        vim.log.levels.ERROR
      )
      return
    end

    vim.notify(
      string.format(
        "[compendium.nvim] Created note from template: %s",
        vim.fn.fnamemodify(opts.template_filepath, ":t")
      ),
      vim.log.levels.INFO
    )

    vim.cmd("tabnew " .. vim.fn.fnameescape(filepath))
  end)
end

local function create_note_from_template(opts)
  if not opts.landing_dir or opts.landing_dir == "" then
    vim.notify(
      "[compendium.nvim] create_note_from_template action failed: landing_dir is not configured.",
      vim.log.levels.ERROR
    )
    return
  end

  if vim.fn.isdirectory(opts.landing_dir) == 0 then
    vim.notify(
      "[compendium.nvim] create_note_from_template action failed: The configured landing_dir does not exist: "
        .. opts.landing_dir,
      vim.log.levels.ERROR
    )
    return
  end

  if not opts.templates_dir or opts.templates_dir == "" then
    vim.notify(
      "[compendium.nvim] create_note_from_template action failed: templates_dir is not configured.",
      vim.log.levels.ERROR
    )
    return
  end

  if vim.fn.isdirectory(opts.templates_dir) == 0 then
    vim.notify(
      "[compendium.nvim] create_note_from_template action failed: The configured templates_dir does not exist: "
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
      string.format("[%s] create_note_from_template action failed: telescope.nvim plugin or its components not found."),
      vim.log.levels.ERROR
    )
    return
  end

  pcall(apply_theme(telescope.find_files, {
    prompt_title = "Select template",
    cwd = opts.templates_dir,
    hidden = true,
    attach_mappings = function(prompt_bufnr, map)
      local function handle_selection()
        local template_filepath = get_selected_template({
          telescope_actions_state = telescope_actions_state,
          telescope_actions = telescope_actions,
          prompt_bufnr = prompt_bufnr,
          templates_dir = opts.templates_dir,
        })

        create_note({
          landing_dir = opts.landing_dir,
          template_filepath = template_filepath,
          insert_datetime_header = opts.insert_datetime_header,
        })
      end

      map("i", "<CR>", handle_selection)
      map("n", "<CR>", handle_selection)

      return true
    end,
  }))
end

return create_note_from_template
