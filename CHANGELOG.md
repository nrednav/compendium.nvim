# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic
Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.2.0] - 2025-05-05

### Added

- Added new action `insert_template` which inserts a template into the currently
  open buffer
- Added a new configuration option named `telescope_theme`
  - This will allow users to specify which telescope theme to use for the file
    pickers (e.g. ivy, dropdown, cursor, or default for no theme)

### Changed

- Refactored theme application logic for better reusability
  - Moved theme handling code into a separate utility module
  - Updated all actions to use the new utility module
- Changed the default telescope appearance for file pickers from `ivy` to no
  theme
  - This way the plugin does not enforce a particular theme and users can change
    it to whatever they like

## [v0.1.0] - 2025-04-26

- First release
