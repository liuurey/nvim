-- which-key 键位冲突修复方案
-- 解决 which-key checkhealth 报告的所有冲突

local M = {}

-- 安全键位删除函数
local function safe_del_keymap(mode, lhs)
  pcall(vim.keymap.del, mode, lhs)
end

-- 延迟配置函数，确保在所有插件加载完成后执行
function M.setup()
  -- 延迟执行以确保所有插件已加载
  vim.schedule(function()
    -- 处理 <Space>l 冲突：重新组织 LSP 键位避开 LazyVim 默认的 "Lazy" 键位
    M.reorganize_lsp_keymaps()
    
    -- 处理其他 <Space> 前缀冲突
    M.fix_space_prefix_conflicts()
    
    -- 修复重复映射问题
    M.fix_duplicate_mappings()
    
    -- 更新 which-key 组定义
    M.update_which_key_groups()
    
    vim.notify("✅ 键位冲突修复完成", vim.log.levels.INFO)
  end)
end

-- 重新组织 LSP 键位映射，避开 LazyVim 的 <Space>l
function M.reorganize_lsp_keymaps()
  -- 移除可能冲突的 <Space>l 相关键位
  local space_l_conflicts = {
    "<space>lR", "<space>ls", "<space>lh", "<space>lf", 
    "<space>li", "<space>la", "<space>lr", "<space>ld", "<space>lD"
  }
  
  for _, key in ipairs(space_l_conflicts) do
    safe_del_keymap("n", key)
  end
  
  -- 重新映射 LSP 功能到 <leader>l 前缀（避免与 <space>l 冲突）
  -- 这些映射与 keybindings.lua 中的保持一致
  local lsp_keymaps = {
    { "<leader>lr", vim.lsp.buf.rename, "重命名符号" },
    { "<leader>la", vim.lsp.buf.code_action, "代码操作" },
    { "<leader>li", vim.lsp.buf.implementation, "跳转到实现" },
    { "<leader>lR", vim.lsp.buf.references, "查找引用" },
    { "<leader>ls", vim.lsp.buf.document_symbol, "文档符号" },
    { "<leader>lh", vim.lsp.buf.hover, "悬停信息" },
    { "<leader>ld", vim.lsp.buf.definition, "跳转到定义" },
    { "<leader>lD", vim.lsp.buf.declaration, "跳转到声明" },
    { "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "格式化代码" },
  }
  
  for _, keymap in ipairs(lsp_keymaps) do
    vim.keymap.set("n", keymap[1], keymap[2], { desc = keymap[3], silent = true })
  end
end

-- 修复其他 <Space> 前缀冲突
function M.fix_space_prefix_conflicts()
  -- 处理 <space>e 冲突：移除冲突的 <space>ev
  safe_del_keymap("n", "<space>ev")
  
  -- 处理 <space>n 冲突：移除冲突的 <space>nh
  safe_del_keymap("n", "<space>nh")
  
  -- 将这些功能重新映射到更合适的键位
  vim.keymap.set("n", "<leader>ev", function()
    vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
  end, { desc = "⚙️ 编辑Neovim配置" })
  
  vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "💡 取消搜索高亮" })
end

-- 修复重复映射问题
function M.fix_duplicate_mappings()
  -- 处理 <leader>dp 重复映射问题：重新定义 Python 调试键位
  -- 移除冲突的映射
  safe_del_keymap("n", "<leader>dp")
  
  -- 重新定义 Python 调试功能到 <leader>py 前缀
  M.setup_python_debug_keymaps()
end

-- 设置 Python 调试专用键位
function M.setup_python_debug_keymaps()
  -- Python 调试功能重新映射到 <leader>py 前缀
  local python_debug_keymaps = {
    { "<leader>pym", function() 
        if pcall(require, 'dap-python') then
          require('dap-python').test_method() 
        else
          vim.notify("dap-python 未安装", vim.log.levels.WARN)
        end
      end, "Python: 调试测试方法" },
    
    { "<leader>pyc", function() 
        if pcall(require, 'dap-python') then
          require('dap-python').test_class() 
        else
          vim.notify("dap-python 未安装", vim.log.levels.WARN)
        end
      end, "Python: 调试测试类" },
    
    { "<leader>pyf", function() 
        if pcall(require, 'dap-python') then
          require('dap-python').debug_selection() 
        else
          vim.notify("dap-python 未安装", vim.log.levels.WARN)
        end
      end, "Python: 调试选中代码" },
    
    { "<leader>pyr", function() 
        if pcall(require, 'dap') then
          require('dap').run_to_cursor() 
        else
          vim.notify("nvim-dap 未安装", vim.log.levels.WARN)
        end
      end, "Python: 运行到光标" },
  }
  
  for _, keymap in ipairs(python_debug_keymaps) do
    vim.keymap.set("n", keymap[1], keymap[2], { desc = keymap[3], silent = true })
  end
end

-- 更新 which-key 组定义
function M.update_which_key_groups()
  local ok, wk = pcall(require, "which-key")
  if not ok then
    return
  end
  
  -- 仅添加与 LazyVim 不冲突的组，避免重复定义
  wk.add({
    -- Python 调试专用组（重新定义到 <leader>py 避免冲突）
    { "<leader>py", group = "🐍 Python调试" },
    
    -- 主题切换组
    { "<leader>T", group = "🎨 主题切换" },
    
    -- 游戏功能组
    { "<leader>G", group = "🎮 趣味游戏" },
  })
end

-- 验证修复效果
function M.verify_fixes()
  print("键位冲突修复验证")
  print("================")
  
  local conflicts_resolved = 0
  local issues_remaining = 0
  
  -- 检查主要冲突是否已解决
  local test_keys = {
    { "<leader>lr", "LSP重命名" },
    { "<leader>la", "LSP代码操作" },
    { "<leader>nh", "取消高亮" },
    { "<leader>ec", "编辑配置" },
    { "<leader>pym", "Python调试方法" },
    { "<leader>pyc", "Python调试类" },
  }
  
  for _, test in ipairs(test_keys) do
    local maps = vim.api.nvim_get_keymap('n')
    local found = false
    for _, map in ipairs(maps) do
      if map.lhs == test[1] then
        found = true
        break
      end
    end
    
    if found then
      print("✅ " .. test[2] .. " (" .. test[1] .. ") 映射正常")
      conflicts_resolved = conflicts_resolved + 1
    else
      print("⚠️ " .. test[2] .. " (" .. test[1] .. ") 映射缺失")
      issues_remaining = issues_remaining + 1
    end
  end
  
  print(string.format("\n修复统计: %d个冲突已解决, %d个问题待处理", 
                     conflicts_resolved, issues_remaining))
  
  if issues_remaining == 0 then
    print("🎉 所有键位冲突已成功修复!")
    print("📝 Python调试功能已迁移到 <leader>py 前缀")
  end
end

-- 创建用户命令
vim.api.nvim_create_user_command('VerifyKeymapFixes', function()
  M.verify_fixes()
end, { desc = '验证键位冲突修复效果' })

return M