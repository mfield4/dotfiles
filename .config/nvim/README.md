# Neovim Configuration (Lua)

This is a modular Neovim configuration written in Lua, designed to be an upgraded version of standard Vim defaults.

## Structure

```text
~/.config/nvim/
├── init.lua          # Entry point
└── lua/
    ├── core/
    │   ├── options.lua  # Global options
    │   ├── keymaps.lua  # Keybindings
    │   └── autocmds.lua # Autocommands (trim whitespace, etc.)
    └── work/
        └── init.lua     # Work-specific integrations
```

## Features

- **Sane Defaults**: Adapted from standard `vimrc`.
- **Keymaps**: Split navigation with Ctrl+hjkl, quick save/quit, visual mode selection jumps.
- **Autocommands**: Auto-trim trailing whitespace on save, filetype-specific settings (e.g., indentation).

## Usage

Simply clone or link these files into `~/.config/nvim/`.
