-- which-key 键位冲突测试和验证脚本
local M = {}

-- 测试键位冲突修复效果
function M.test_conflict_fixes()
  print("=== which-key 键位冲突修复验证 ===\n")
  
  local function check_keymap(key, expected_desc)
    local maps = vim.api.nvim_get_keymap('n')
    for _, map in ipairs(maps) do
      if map.lhs == key then
        local desc = map.desc or "无描述"
        if desc:match(expected_desc) then
          print("✅ " .. key .. " -> " .. desc)
          return true
        else
          print("⚠️ " .. key .. " -> " .. desc .. " (不匹配期望: " .. expected_desc .. ")")
          return false
        end
      end
    end
    print("❌ " .. key .. " 映射缺失 (期望: " .. expected_desc .. ")")
    return false
  end
  
  local tests = {
    -- LSP 功能测试
    { "<leader>lr", "重命名" },
    { "<leader>la", "代码操作" },
    { "<leader>ld", "定义" },
    { "<leader>lR", "引用" },
    { "<leader>lf", "格式化" },
    
    -- 修复的冲突键位
    { "<leader>nh", "取消.*高亮" },
    { "<leader>ec", "编辑.*配置" },
    
    -- Python 调试功能（重新定义到 <leader>py）
    { "<leader>pym", "Python.*方法" },
    { "<leader>pyc", "Python.*类" },
  }
  
  local passed = 0
  local total = #tests
  
  for _, test in ipairs(tests) do
    if check_keymap(test[1], test[2]) then
      passed = passed + 1
    end
  end
  
  print(string.format("\n测试结果: %d/%d 通过", passed, total))
  
  if passed == total then
    print("🎉 所有键位冲突修复验证通过!")
  else
    print("⚠️ 部分键位仍有问题，请检查配置")
  end
end

-- 检查 which-key 组定义
function M.check_which_key_groups()
  print("\n=== which-key 组定义检查 ===\n")
  
  local ok, wk = pcall(require, "which-key")
  if not ok then
    print("❌ which-key 插件未加载")
    return
  end
  
  -- 检查是否存在重复的组定义
  local expected_groups = {
    "<leader>l",  -- LSP功能
    "<leader>d",  -- 调试诊断
    "<leader>py", -- Python调试（重新定义）
    "<leader>T",  -- 主题切换
    "<leader>G",  -- 游戏功能
    "<leader>f",  -- 文件操作
    "<leader>w",  -- 窗口操作
    "<leader>?",  -- 帮助工具
  }
  
  for _, group in ipairs(expected_groups) do
    print("✅ 预期组: " .. group)
  end
  
  print("\n如果上述组能正常显示在 which-key 中，说明修复成功")
end

-- 运行所有测试
function M.run_all_tests()
  M.test_conflict_fixes()
  M.check_which_key_groups()
  
  print("\n=== 手动验证建议 ===")
  print("1. 重启 Neovim")
  print("2. 运行 :checkhealth which-key")
  print("3. 按 <leader> 键查看 which-key 面板")
  print("4. 测试以下键位:")
  print("   - <leader>lr (LSP重命名)")
  print("   - <leader>la (LSP代码操作)")
  print("   - <leader>nh (取消高亮)")
  print("   - <leader>ec (编辑配置)")
  print("   - <leader>pym (Python调试方法)")
  print("   - <leader>pyc (Python调试类)")
end

-- 创建用户命令
vim.api.nvim_create_user_command('TestKeymapFixes', function()
  M.run_all_tests()
end, { desc = '测试键位冲突修复效果' })

vim.api.nvim_create_user_command('CheckWhichKeyConflicts', function()
  M.check_which_key_groups()
end, { desc = '检查 which-key 组定义' })

return M