local get_formatted_datetime = require("compendium.utils.get_formatted_datetime")

local function create_note(opts)
  if not opts.landing_dir or opts.landing_dir == "" then
    vim.notify("[compendium.nvim] create_note action failed: landing_dir is not configured.", vim.log.levels.ERROR)
    return
  end

  if vim.fn.isdirectory(opts.landing_dir) == 0 then
    vim.notify(
      "[compendium.nvim] create_note action failed: The configured landing_dir does not exist: " .. opts.landing_dir,
      vim.log.levels.ERROR
    )
    return
  end

  vim.ui.input({ prompt = "Enter filename: " }, function(filename)
    if filename == nil or filename == "" then
      vim.notify("[compendium.nvim] create_note action cancelled: No filename was provided.", vim.log.levels.WARN)
      return
    end

    local filepath = vim.fs.joinpath(opts.landing_dir, filename)

    if vim.fn.filereadable(filepath) == 1 then
      vim.notify("[compendium.nvim] create_note action failed: File already exists: " .. filepath, vim.log.levels.ERROR)
      return
    end

    local file_content = {}

    if opts.insert_datetime_header then
      local datetime_header = {
        get_formatted_datetime(),
        "",
        "",
      }

      for i = #datetime_header, 1, -1 do
        table.insert(file_content, 1, datetime_header[i])
      end
    end

    local file_created = pcall(vim.fn.writefile, file_content, filepath)

    if not file_created then
      vim.notify(
        "[compendium.nvim] create_note action failed: Could not create file: " .. filepath,
        vim.log.levels.ERROR
      )
      return
    end

    vim.notify("[compendium.nvim] Created note: " .. filepath, vim.log.levels.INFO)

    vim.cmd("tabnew " .. vim.fn.fnameescape(filepath))

    vim.cmd("normal! G$") -- Go to end of buffer
  end)
end

return create_note
