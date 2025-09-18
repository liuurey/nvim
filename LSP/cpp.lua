-- C++ 文件类型特定配置
-- 注意：这里不需要再次启用 LSP，因为 lsp-config.lua 已统一管理
-- 只处理文件类型特有的设置

-- C++ 特有的编辑器设置
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smartindent = true
vim.opt_local.cindent = true

-- C++ 注释设置
vim.opt_local.commentstring = '// %s'

-- C++ 特有的折叠设置
vim.opt_local.foldmethod = 'syntax'
vim.opt_local.foldlevel = 1

-- C++ 特有的匹配设置
vim.opt_local.matchpairs:append('<:>')

-- C++ 特有的全局变量
vim.g.cpp_class_scope_highlight = 1
vim.g.cpp_member_variable_highlight = 1
vim.g.cpp_class_decl_highlight = 1

-- 可选：C++ 特有的快捷键
local opts = { buffer = true, silent = true }
vim.keymap.set('n', '<leader>ch', function()
  -- 切换头文件和源文件
  local file_ext = vim.fn.expand('%:e')
  if file_ext == 'cpp' or file_ext == 'cc' or file_ext == 'cxx' then
    local header_file = vim.fn.expand('%:r') .. '.h'
    if vim.fn.filereadable(header_file) == 1 then
      vim.cmd('edit ' .. header_file)
    else
      header_file = vim.fn.expand('%:r') .. '.hpp'
      if vim.fn.filereadable(header_file) == 1 then
        vim.cmd('edit ' .. header_file)
      end
    end
  elseif file_ext == 'h' or file_ext == 'hpp' then
    local source_file = vim.fn.expand('%:r') .. '.cpp'
    if vim.fn.filereadable(source_file) == 1 then
      vim.cmd('edit ' .. source_file)
    else
      source_file = vim.fn.expand('%:r') .. '.cc'
      if vim.fn.filereadable(source_file) == 1 then
        vim.cmd('edit ' .. source_file)
      end
    end
  end
end, vim.tbl_extend('force', opts, { desc = 'Toggle Header/Source' }))

vim.keymap.set('n', '<leader>cb', function()
  -- 编译当前文件
  local file = vim.fn.expand('%')
  local output = vim.fn.expand('%:r') .. '.exe'
  vim.cmd('!g++ -o ' .. output .. ' ' .. file)
end, vim.tbl_extend('force', opts, { desc = 'Compile C++ file' }))
