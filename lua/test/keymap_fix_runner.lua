-- 键位冲突修复执行脚本
-- 用于重新加载配置并验证修复效果

local M = {}

-- 重新加载所有相关配置
function M.reload_configs()
  print("🔄 正在重新加载配置...")
  
  -- 清理包缓存
  local modules_to_clear = {
    "config.keybindings",
    "plugins.which-key",
    "plugins.theme",
    "plugins.debugger",
    "test.keymap_conflict_fix_test"
  }
  
  for _, module in ipairs(modules_to_clear) do
    package.loaded[module] = nil
    pcall(function()
      vim.cmd("silent! unmap <buffer> <leader>")
    end)
  end
  
  -- 重新加载核心配置
  pcall(require, "config.keybindings")
  
  print("✅ 配置重新加载完成")
  
  -- 等待 which-key 加载完成
  vim.defer_fn(function()
    local ok, wk = pcall(require, "which-key")
    if ok then
      print("✅ which-key 插件已重新加载")
    else
      print("⚠️ which-key 插件加载失败")
    end
  end, 1000)
end

-- 手动设置缺失的键位
function M.setup_missing_keymaps()
  print("🔧 手动设置缺失的键位映射...")
  
  local keymap = vim.keymap
  
  -- LSP 功能统一配置到 <leader>l 前缀
  keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "重命名符号" })
  keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "代码操作" })
  keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "跳转到实现" })
  keymap.set("n", "<leader>lR", vim.lsp.buf.references, { desc = "查找引用" })
  keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol, { desc = "文档符号" })
  keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "悬停信息" })
  keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "跳转到定义" })
  keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "跳转到声明" })
  keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { desc = "格式化代码" })
  
  -- 搜索高亮管理
  keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "💡 取消搜索高亮" })
  
  -- 快速编辑配置文件
  keymap.set("n", "<leader>ec", function()
    vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
  end, { desc = "⚙️ 编辑配置文件" })
  
  -- 仪表盘快捷访问
  keymap.set("n", "<leader>D", function()
    if LazyVim and LazyVim.has("dashboard-nvim") then
      vim.cmd("Dashboard")
    elseif LazyVim and LazyVim.has("alpha-nvim") then
      vim.cmd("Alpha")
    else
      vim.notify("未找到仪表盘插件", vim.log.levels.WARN)
    end
  end, { desc = "打开仪表盘" })
  
  print("✅ 手动键位设置完成")
end

-- 设置 which-key 组
function M.setup_which_key_groups()
  print("📋 设置 which-key 组...")
  
  vim.defer_fn(function()
    local ok, wk = pcall(require, "which-key")
    if not ok then
      print("❌ which-key 插件未加载")
      return
    end
    
    -- 清理可能的重复组
    pcall(vim.keymap.del, "n", "<leader>T")
    pcall(vim.keymap.del, "n", "<leader>G")
    pcall(vim.keymap.del, "n", "<leader>py")
    
    -- 重新添加组
    wk.add({
      { "<leader>py", group = "🐍 Python调试" },
      { "<leader>G", group = "🎮 趣味游戏" },
      { "<leader>T", group = "🎨 主题切换" },
    })
    
    print("✅ which-key 组设置完成")
  end, 500)
end

-- 完整修复流程
function M.full_fix()
  print("=== 开始完整的键位冲突修复流程 ===")
  print("时间：" .. os.date("%Y-%m-%d %H:%M:%S"))
  print()
  
  -- 1. 重新加载配置
  M.reload_configs()
  
  -- 2. 等待一秒后设置缺失的键位
  vim.defer_fn(function()
    M.setup_missing_keymaps()
    
    -- 3. 再等待一秒设置 which-key 组
    vim.defer_fn(function()
      M.setup_which_key_groups()
      
      -- 4. 最后运行测试验证
      vim.defer_fn(function()
        print()
        print("🧪 运行修复验证测试...")
        local test_ok, test_module = pcall(require, "test.keymap_conflict_fix_test")
        if test_ok then
          test_module.run_all_tests()
        else
          print("❌ 无法加载测试模块")
        end
      end, 1500)
    end, 1000)
  end, 1000)
end

-- 快速修复（仅设置键位，不重新加载）
function M.quick_fix()
  print("⚡ 执行快速修复...")
  
  M.setup_missing_keymaps()
  M.setup_which_key_groups()
  
  vim.defer_fn(function()
    local test_ok, test_module = pcall(require, "test.keymap_conflict_fix_test")
    if test_ok then
      test_module.quick_check()
    end
  end, 500)
end

-- 创建用户命令
vim.api.nvim_create_user_command('FixKeymapConflicts', function()
  M.full_fix()
end, { desc = '执行完整的键位冲突修复' })

vim.api.nvim_create_user_command('QuickFixKeymaps', function()
  M.quick_fix()
end, { desc = '快速修复键位问题' })

vim.api.nvim_create_user_command('ReloadKeymapConfigs', function()
  M.reload_configs()
end, { desc = '重新加载键位相关配置' })

return M