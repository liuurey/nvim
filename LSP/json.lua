-- JSON 文件类型特定配置

-- JSON 特有的编辑器设置
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true

-- JSON 不支持注释，禁用注释功能
vim.opt_local.commentstring = ''

-- JSON 特有的折叠设置
vim.opt_local.foldmethod = 'syntax'
vim.opt_local.foldlevel = 2

-- 自动格式化设置
vim.opt_local.formatoptions:remove('c')
vim.opt_local.formatoptions:remove('r')
vim.opt_local.formatoptions:remove('o')