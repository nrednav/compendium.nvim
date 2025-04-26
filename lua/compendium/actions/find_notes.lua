local function apply_theme(command, opts)
  local themes = require("telescope.themes")
  return function()
    command(themes.get_ivy(opts))
  end
end

local function find_notes(opts)
  if not opts.landing_dir or opts.landing_dir == "" then
    vim.notify("[compendium.nvim] find_notes action failed: landing_dir is not configured.", vim.log.levels.ERROR)
    return
  end

  if vim.fn.isdirectory(opts.landing_dir) == 0 then
    vim.notify(
      "[compendium.nvim] find_notes action failed: The configured landing_dir does not exist: " .. opts.landing_dir,
      vim.log.levels.ERROR
    )
    return
  end

  local telescope_ok, telescope = pcall(require, "telescope.builtin")

  if not telescope_ok then
    vim.notify("[compendium.nvim] find_notes action failed: telescope.nvim plugin not found.", vim.log.levels.ERROR)
    return
  end

  pcall(apply_theme(telescope.find_files, {
    prompt_title = "Find notes",
    cwd = opts.landing_dir,
    hidden = true,
  }))
end

return find_notes
