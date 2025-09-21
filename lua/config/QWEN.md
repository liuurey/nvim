# Neovim Configuration Context

## Project Overview

This is a Neovim configuration based on LazyVim, customized for use in a Termux environment on Android. The configuration aims to provide a powerful development environment with optimized settings for mobile use.

## Configuration Structure

The configuration is organized into several key files:

1. **init.lua** - The main initialization file that loads the LazyVim configuration and custom keybindings
2. **config/lazy.lua** - LazyVim plugin management configuration
3. **config/autocmds.lua** - Custom autocommands for various Neovim events
4. **config/keybindings.lua** - Key mappings organized by functionality (LSP, diagnostics, etc.)
5. **config/keymaps.lua** - Additional key mappings for various modes (insert, visual, normal)
6. **config/options.lua** - Global Neovim options and settings
7. **lua/plugins/** - Directory containing plugin-specific configurations

## Key Features

### Plugin Management
- Uses LazyVim as the base configuration framework
- Plugins are managed through lazy.nvim
- Custom plugin configurations are in the `lua/plugins/` directory

### Terminal Optimizations
- Special handling for Termux terminal environment
- Terminal auto-insert mode when opening terminals
- Optimized settings for mobile terminal usage

### Keybindings
Two main keybinding files exist:
- `keybindings.lua` - Organized by functionality groups (LSP, diagnostics, etc.)
- `keymaps.lua` - Mode-specific key mappings (insert, visual, normal)

### Autocommands
Custom autocommands for:
- Terminal optimization
- File saving behaviors
- File type specific configurations
- Large file handling optimizations

## Development Notes

### Termux Specific Configurations
- Adjusted settings for Termux environment
- Special handling for terminal and file system operations
- Optimized for mobile development workflow

### Performance Optimizations
- Large file handling with automatic optimizations
- Lazy loading of plugins
- Disabled unused plugin providers

## Usage Instructions

1. **Loading the Configuration**
   The configuration is automatically loaded when Neovim starts. The main entry point is `init.lua`.

2. **Keybinding Organization**
   - `<leader>p` - LSP functionality
   - `<leader>x` - Diagnostics
   - `<leader>py` - Python debugging
   - `<leader>C` - Configuration management
   - `<leader>N` - Notification management
   - `<leader>f` - File searching

3. **Customizing Keybindings**
   Keybindings can be modified in `config/keybindings.lua` and `config/keymaps.lua`.

4. **Adding Plugins**
   New plugins should be added through the LazyVim configuration in `config/lazy.lua` or by adding files to `lua/plugins/`.

5. **Custom Autocommands**
   Custom autocommands can be added to `config/autocmds.lua`.

6. **Options Configuration**
   Global options are configured in `config/options.lua`.

## Troubleshooting

1. **Plugin Issues**
   - Run `:Lazy` to check plugin status
   - Check `:checkhealth` for diagnostic information

2. **Keybinding Conflicts**
   - Use `:WhichKey` to see available keybindings
   - Check both `keybindings.lua` and `keymaps.lua` for conflicts

3. **Performance Issues**
   - Large file optimizations are automatic but can be adjusted in `autocmds.lua`
   - Plugin loading can be tuned in `lazy.lua`