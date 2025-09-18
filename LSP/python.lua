-- Python 文件类型特定配置
-- 注意：这里不需要再次启用 LSP，因为 lsp-config.lua 已统一管理
-- 只处理文件类型特有的设置

-- Python 特有的编辑器设置
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smartindent = true

-- Python 注释设置
vim.opt_local.commentstring = '# %s'

-- Python 特有的折叠设置
vim.opt_local.foldmethod = 'indent'
vim.opt_local.foldlevel = 2

-- Python 特有的全局变量设置
vim.g.python_highlight_all = 1

-- 可选：Python 特有的快捷键
-- 只在确实需要时添加，避免与主配置冲突
local opts = { buffer = true, silent = true }
vim.keymap.set('n', '<leader>pr', function()
  vim.cmd('!python %')
end, vim.tbl_extend('force', opts, { desc = 'Run Python file' }))
