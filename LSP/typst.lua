-- Typst 文件类型特定配置
-- 注意：LSP配置已在 lsp-config.lua 中统一管理，这里只处理文件类型特有的设置

-- Typst 特有的编辑器设置
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smartindent = true

-- Typst 注释设置
vim.opt_local.commentstring = '// %s'

-- Typst 特有的折叠设置
vim.opt_local.foldmethod = 'indent'
vim.opt_local.foldlevel = 2

-- Typst 特有的快捷键
local opts = { buffer = true, silent = true }
vim.keymap.set('n', '<leader>tc', function()
  -- 编译Typst文件
  local file = vim.fn.expand('%')
  local output = vim.fn.expand('%:r') .. '.pdf'
  vim.cmd('!typst compile ' .. file .. ' ' .. output)
end, vim.tbl_extend('force', opts, { desc = 'Compile Typst to PDF' }))
