local telescope_utils = require("compendium.utils.telescope")

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

  local themed_find_files = telescope_utils.apply_theme(opts.telescope_theme, telescope.find_files, {
    prompt_title = "Find notes",
    cwd = opts.landing_dir,
    hidden = true,
  })

  if themed_find_files then
    pcall(themed_find_files)
  else
    vim.notify("[compendium.nvim] find_notes action failed: could not prepare telescope action", vim.log.levels.WARN)
  end
end

return find_notes
