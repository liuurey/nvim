-- LaTeX 文件类型特定配置
-- 注意：LSP配置已在 lsp-config.lua 中统一管理，这里只处理文件类型特有的设置

-- LaTeX 特有的编辑器设置
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smartindent = true

-- LaTeX 注释设置
vim.opt_local.commentstring = '% %s'

-- LaTeX 特有的折叠设置
vim.opt_local.foldmethod = 'indent'
vim.opt_local.foldlevel = 2

-- LaTeX 特有的快捷键
local opts = { buffer = true, silent = true }

-- 搜索 Beamer 框
vim.keymap.set('n', '<leader>lb', function()
  if pcall(require, 'snacks') then
    require('snacks').picker.grep_buffers {
      finder = 'grep',
      format = 'file',
      prompt = ' ',
      search = '\\begin{frame}',
      regex = false,
      live = false,
      args = {},
      on_show = function()
        vim.cmd.stopinsert()
      end,
      buffers = false,
      supports_live = false,
      layout = 'left',
    }
  else
    -- 备用方案：使用内置搜索
    vim.cmd('vimgrep /\\begin{frame}/ %')
    vim.cmd('copen')
  end
end, vim.tbl_extend('force', opts, { desc = 'Search Beamer Frames' }))

-- 编译 LaTeX 文件
vim.keymap.set('n', '<leader>tc', function()
  local file = vim.fn.expand('%')
  vim.cmd('!pdflatex ' .. file)
end, vim.tbl_extend('force', opts, { desc = 'Compile LaTeX to PDF' }))