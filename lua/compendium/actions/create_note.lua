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

  vim.ui.input({ prompt = "Enter a filename for the new note (e.g. todo.md): " }, function(filename)
    if filename == nil or filename == "" then
      vim.notify("[compendium.nvim] create_note action cancelled: No filename was provided.", vim.log.levels.WARN)
      return
    end

    local filepath = vim.fs.joinpath(opts.landing_dir, filename)

    if vim.fn.filereadable(filepath) == 1 then
      vim.notify("[compendium.nvim] create_note action failed: File already exists: " .. filepath, vim.log.levels.ERROR)
      return
    end

    local file_created = pcall(vim.fn.writefile, {}, filepath)

    if not file_created then
      vim.notify(
        "[compendium.nvim] create_note action failed: Could not create file: " .. filepath,
        vim.log.levels.ERROR
      )
      return
    end

    vim.notify("[compendium.nvim] Created note: " .. filepath, vim.log.levels.INFO)

    vim.cmd("tabnew " .. vim.fn.fnameescape(filepath))
  end)
end

return create_note
