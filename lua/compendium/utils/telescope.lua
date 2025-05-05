local M = {}

-- Applies a specific theme to a telescope action
function M.apply_theme(theme_name, action, action_opts)
  local themes_ok, themes = pcall(require, "telescope.themes")

  if not themes_ok then
    vim.notify("[compendium.nvim] apply_theme failed: telescope.themes module was not found", vim.log.levels.WARN)
    return function()
      action(action_opts)
    end
  end

  local default_theme_name = "ivy"
  local effective_theme_name = theme_name or default_theme_name

  if effective_theme_name == "default" then
    return function()
      action(action_opts)
    end
  end

  local theme_fn = themes["get_" .. effective_theme_name]

  if not theme_fn or type(theme_fn) ~= "function" then
    vim.notify(
      string.format(
        "[compendium.nvim] apply_theme failed: telescope theme '%s' was not found or invalid. Falling back to '%s'",
        effective_theme_name,
        default_theme_name
      ),
      vim.log.levels.WARN
    )

    theme_fn = themes.get_ivy

    if not theme_fn then
      vim.notify(
        string.format(
          "[compendium.nvim] apply_theme failed: default telescope theme '%s' was not found",
          default_theme_name
        ),
        vim.log.levels.ERROR
      )
      return function()
        action(action_opts)
      end
    end
  end

  return function()
    action(theme_fn(action_opts))
  end
end

return M
