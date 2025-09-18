-- Lua 文件类型特定配置
-- 注意：这里不需要再次启用 LSP，因为 lsp-config.lua 已统一管理
-- 只处理文件类型特有的设置

-- Lua 特有的编辑器设置
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smartindent = true

-- Lua 注释设置
vim.opt_local.commentstring = '-- %s'

-- Lua 特有的折叠设置
vim.opt_local.foldmethod = 'indent'
vim.opt_local.foldlevel = 1

-- 可选：Lua 特有的快捷键
local opts = { buffer = true, silent = true }
vim.keymap.set('n', '<leader>lr', function()
  vim.cmd('luafile %')
end, vim.tbl_extend('force', opts, { desc = 'Execute Lua file' }))
