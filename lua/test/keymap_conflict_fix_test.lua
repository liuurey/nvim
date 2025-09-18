-- which-key 键位冲突修复验证测试
-- 用于验证修复后的键位状态

local M = {}

-- 测试结果表
local results = {
  passed = 0,
  failed = 0,
  warnings = 0,
  details = {}
}

-- 添加测试结果
local function add_result(test_name, status, message)
  table.insert(results.details, {
    name = test_name,
    status = status,
    message = message
  })
  
  if status == "PASS" then
    results.passed = results.passed + 1
  elseif status == "FAIL" then
    results.failed = results.failed + 1
  else
    results.warnings = results.warnings + 1
  end
end

-- 检查键位是否存在
local function keymap_exists(mode, lhs)
  local maps = vim.api.nvim_get_keymap(mode)
  for _, map in ipairs(maps) do
    if map.lhs == lhs then
      return true, map.desc or "无描述"
    end
  end
  return false, nil
end

-- 测试 LSP 键位是否正确迁移到 <leader>l
local function test_lsp_keymaps()
  print("🔍 测试 LSP 键位映射...")
  
  local lsp_keys = {
    { "<leader>lr", "重命名符号" },
    { "<leader>la", "代码操作" },
    { "<leader>li", "跳转到实现" },
    { "<leader>lR", "查找引用" },
    { "<leader>ls", "文档符号" },
    { "<leader>lh", "悬停信息" },
    { "<leader>ld", "跳转到定义" },
    { "<leader>lD", "跳转到声明" },
    { "<leader>lf", "格式化代码" },
  }
  
  local conflicts_found = 0
  
  for _, key_info in ipairs(lsp_keys) do
    local exists, desc = keymap_exists("n", key_info[1])
    if exists then
      add_result("LSP " .. key_info[2], "PASS", 
        string.format("%s 映射正常: %s", key_info[1], desc))
    else
      add_result("LSP " .. key_info[2], "FAIL", 
        string.format("%s 映射缺失", key_info[1]))
      conflicts_found = conflicts_found + 1
    end
  end
  
  return conflicts_found == 0
end

-- 测试 Space 前缀冲突是否解决
local function test_space_conflicts()
  print("🔍 测试 Space 前缀冲突...")
  
  local space_conflicts = {
    "<space>lf", "<space>ls", "<space>li", "<space>ld",
    "<space>lr", "<space>la", "<space>lR", "<space>lh", "<space>lD",
    "<space>ev", "<space>ec", "<space>nh"
  }
  
  local conflicts_remaining = 0
  
  for _, key in ipairs(space_conflicts) do
    local exists = keymap_exists("n", key)
    if exists then
      add_result("Space 冲突", "WARN", 
        string.format("冲突键位仍存在: %s", key))
      conflicts_remaining = conflicts_remaining + 1
    else
      add_result("Space 冲突", "PASS", 
        string.format("冲突键位已清理: %s", key))
    end
  end
  
  return conflicts_remaining == 0
end

-- 测试 which-key 组是否正确定义
local function test_which_key_groups()
  print("🔍 测试 which-key 组定义...")
  
  local ok, wk = pcall(require, "which-key")
  if not ok then
    add_result("Which-key 组", "FAIL", "which-key 插件未加载")
    return false
  end
  
  -- 检查组是否无重复
  local expected_groups = {
    { "<leader>py", "🐍 Python调试" },
    { "<leader>G", "🎮 趣味游戏" },
    { "<leader>T", "🎨 主题切换" },
  }
  
  local groups_ok = true
  
  for _, group in ipairs(expected_groups) do
    local exists, desc = keymap_exists("n", group[1])
    if exists then
      add_result("Which-key 组", "PASS", 
        string.format("组 %s 正常: %s", group[1], desc or group[2]))
    else
      add_result("Which-key 组", "WARN", 
        string.format("组 %s 未找到", group[1]))
      groups_ok = false
    end
  end
  
  return groups_ok
end

-- 测试主要功能键位是否正常
local function test_main_keymaps()
  print("🔍 测试主要功能键位...")
  
  local main_keys = {
    { "<leader>nh", "取消搜索高亮" },
    { "<leader>ec", "编辑配置文件" },
    { "<leader>D", "打开仪表盘" },
  }
  
  local main_ok = true
  
  for _, key_info in ipairs(main_keys) do
    local exists, desc = keymap_exists("n", key_info[1])
    if exists then
      add_result("主要功能", "PASS", 
        string.format("%s 正常: %s", key_info[1], desc))
    else
      add_result("主要功能", "FAIL", 
        string.format("%s 缺失", key_info[1]))
      main_ok = false
    end
  end
  
  return main_ok
end

-- 运行所有测试
function M.run_all_tests()
  print("=== which-key 键位冲突修复验证测试 ===")
  print("开始时间：" .. os.date("%Y-%m-%d %H:%M:%S"))
  print()
  
  -- 重置结果
  results = { passed = 0, failed = 0, warnings = 0, details = {} }
  
  -- 执行测试
  local lsp_ok = test_lsp_keymaps()
  local space_ok = test_space_conflicts()
  local groups_ok = test_which_key_groups()
  local main_ok = test_main_keymaps()
  
  print()
  print("=== 测试结果汇总 ===")
  
  -- 输出详细结果
  for _, result in ipairs(results.details) do
    local icon = "❓"
    if result.status == "PASS" then
      icon = "✅"
    elseif result.status == "FAIL" then
      icon = "❌"
    else
      icon = "⚠️"
    end
    
    print(string.format("%s %s: %s", icon, result.name, result.message))
  end
  
  print()
  print(string.format("📊 统计: %d 通过, %d 失败, %d 警告", 
    results.passed, results.failed, results.warnings))
  
  -- 总体评估
  local overall_ok = lsp_ok and space_ok and groups_ok and main_ok
  
  if overall_ok and results.failed == 0 then
    print("🎉 所有键位冲突已成功修复!")
  elseif results.failed == 0 then
    print("⚠️ 修复基本完成，存在一些警告项")
  else
    print("❌ 仍存在需要修复的问题")
  end
  
  -- 给出建议
  if not space_ok then
    print("\n💡 建议: 重新加载配置或重启 Neovim")
  end
  
  if not groups_ok then
    print("\n💡 建议: 确认 which-key 插件已正确加载")
  end
  
  print("\n结束时间：" .. os.date("%Y-%m-%d %H:%M:%S"))
  
  return overall_ok
end

-- 快速检查命令
function M.quick_check()
  print("⚡ 快速检查 which-key 状态...")
  
  -- 检查插件是否加载
  local wk_ok, wk = pcall(require, "which-key")
  if not wk_ok then
    print("❌ which-key 插件未加载")
    return false
  end
  
  print("✅ which-key 插件已加载")
  
  -- 检查关键键位
  local key_checks = {
    "<leader>lr", "<leader>la", "<leader>nh", "<leader>ec"
  }
  
  local all_ok = true
  for _, key in ipairs(key_checks) do
    local exists = keymap_exists("n", key)
    if exists then
      print("✅ " .. key .. " 正常")
    else
      print("❌ " .. key .. " 缺失")
      all_ok = false
    end
  end
  
  return all_ok
end

-- 创建用户命令
vim.api.nvim_create_user_command('TestKeymapFixes', function()
  M.run_all_tests()
end, { desc = '运行键位冲突修复验证测试' })

vim.api.nvim_create_user_command('QuickCheckKeymaps', function()
  M.quick_check()
end, { desc = '快速检查键位状态' })

return M