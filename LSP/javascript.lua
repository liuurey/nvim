-- JavaScript/TypeScript 文件类型特定配置

-- JS/TS 特有的编辑器设置
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smartindent = true

-- JS/TS 注释设置
vim.opt_local.commentstring = '// %s'

-- JS/TS 特有的折叠设置
vim.opt_local.foldmethod = 'indent'
vim.opt_local.foldlevel = 2