-- CUDA 文件类型特定配置
-- 注意：LSP配置已在 lsp-config.lua 中统一管理，这里只处理文件类型特有的设置

-- CUDA 特有的编辑器设置
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smartindent = true
vim.opt_local.cindent = true

-- CUDA 注释设置
vim.opt_local.commentstring = '// %s'

-- CUDA 特有的折叠设置
vim.opt_local.foldmethod = 'syntax'
vim.opt_local.foldlevel = 1

-- CUDA 特有的匹配设置
vim.opt_local.matchpairs:append('<:>')

-- CUDA 特有的快捷键
local opts = { buffer = true, silent = true }
vim.keymap.set('n', '<leader>cc', function()
  -- 编译CUDA文件
  local file = vim.fn.expand('%')
  local output = vim.fn.expand('%:r') .. '.out'
  vim.cmd('!nvcc -o ' .. output .. ' ' .. file)
end, vim.tbl_extend('force', opts, { desc = 'Compile CUDA file' }))
