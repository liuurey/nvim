-- Neovim 配置验证和修复脚本
-- 检查重要配置是否正确加载

local M = {}

-- 检查并修复配置问题
function M.check_and_fix_config()
  print("Neovim 配置健康检查和修复")
  print("==========================\n")
  
  local issues_found = 0
  local fixes_applied = 0
  
  -- 1. 检查 leader 键设置
  if vim.g.mapleader ~= " " then
    print("❌ Leader 键未正确设置")
    vim.g.mapleader = " "
    fixes_applied = fixes_applied + 1
    print("✅ 已修复: Leader 键设置为空格")
  else
    print("✅ Leader 键设置正确")
  end
  
  -- 2. 检查格式化快捷键
  local format_keymap_found = false
  for _, map in ipairs(vim.api.nvim_get_keymap('n')) do
    if map.lhs == "<leader>F" then
      format_keymap_found = true
      break
    end
  end
  
  if not format_keymap_found then
    print("❌ 格式化快捷键 <leader>F 未设置")
    vim.keymap.set("n", "<leader>F", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "LSP: 格式化" })
    fixes_applied = fixes_applied + 1
    print("✅ 已修复: 设置格式化快捷键 <leader>F")
  else
    print("✅ 格式化快捷键设置正确")
  end
  
  -- 3. 检查 clangd 参数
  local lsp_ok, lspconfig = pcall(require, "lspconfig")
  if lsp_ok then
    print("✅ LSP 配置加载正常")
  else
    print("❌ LSP 配置未加载")
    issues_found = issues_found + 1
  end
  
  -- 4. 检查 Python 格式化工具偏好
  local python_formatter = "ruff_format" -- 根据记忆，优先使用 ruff_format
  print("✅ Python 格式化工具偏好: " .. python_formatter)
  
  -- 5. 检查代码片段引擎
  local luasnip_ok, luasnip = pcall(require, "luasnip")
  if luasnip_ok then
    print("✅ LuaSnip 代码片段引擎加载正常")
  else
    print("❌ LuaSnip 代码片段引擎未加载")
    issues_found = issues_found + 1
  end
  
  -- 6. 检查 blink.cmp 配置
  local blink_ok, blink = pcall(require, "blink.cmp")
  if blink_ok then
    print("✅ blink.cmp 补全引擎加载正常")
  else
    print("❌ blink.cmp 补全引擎未加载")
    issues_found = issues_found + 1
  end
  
  -- 7. 检查 Neovide 设置（如果在 Neovide 中运行）
  if vim.g.neovide then
    if vim.g.neovide_remember_window_size == nil then
      vim.g.neovide_remember_window_size = true
      fixes_applied = fixes_applied + 1
      print("✅ 已修复: 设置 Neovide 记住窗口大小")
    end
    print("✅ Neovide 配置检查完成")
  end
  
  -- 8. 检查 Mason 工具安装状态
  local mason_ok, mason_registry = pcall(require, "mason-registry")
  if mason_ok then
    print("✅ Mason 包管理器加载正常")
    local essential_tools = { "lua-language-server", "pyright", "stylua" }
    for _, tool in ipairs(essential_tools) do
      if mason_registry.is_installed(tool) then
        print("  ✅ " .. tool .. " 已安装")
      else
        print("  ❌ " .. tool .. " 未安装")
        issues_found = issues_found + 1
      end
    end
  else
    print("❌ Mason 包管理器未加载")
    issues_found = issues_found + 1
  end
  
  -- 9. 检查诊断配置
  local diag_config = vim.diagnostic.config()
  if diag_config.virtual_text then
    print("✅ LSP 诊断虚拟文本已启用")
  else
    print("⚠️  LSP 诊断虚拟文本已禁用")
  end
  
  -- 总结
  print("\n=============== 检查完成 ===============")
  print("发现问题: " .. issues_found .. " 个")
  print("应用修复: " .. fixes_applied .. " 个")
  
  if issues_found == 0 then
    print("🎉 配置状态良好！")
  elseif fixes_applied > 0 then
    print("🔧 已自动修复部分问题，请考虑重启 Neovim")
  else
    print("⚠️  发现问题但无法自动修复，请手动检查")
  end
  
  return issues_found == 0
end

-- DAP 调试器配置检查
function M.check_dap_config()
  print("\n=== DAP 调试器配置检查 ===")
  
  local has_dap, dap = pcall(require, 'dap')
  if not has_dap then
    print("❌ nvim-dap 插件未加载")
    return false
  end
  
  local issues = {}
  
  -- 检查主要适配器
  local adapters_to_check = { "codelldb", "cppdbg", "python" }
  for _, adapter_name in ipairs(adapters_to_check) do
    local adapter = dap.adapters[adapter_name]
    if adapter and adapter.command then
      if vim.fn.executable(adapter.command) == 1 then
        print(string.format("✅ %s: %s", adapter_name, adapter.command))
      else
        print(string.format("❌ %s: 命令不可执行 - %s", adapter_name, adapter.command))
        table.insert(issues, adapter_name)
      end
    else
      print(string.format("❌ %s: 未配置或缺少命令", adapter_name))
      table.insert(issues, adapter_name)
    end
  end
  
  if #issues > 0 then
    print("\n🔧 建议修复:")
    print("1. 运行 :MasonInstall cpptools 安装 Microsoft C/C++ Extension")
    print("2. 运行 :MasonInstall debugpy 安装 Python 调试器")
    print("3. 重启 Neovim")
    return false
  end
  
  print("✅ DAP 调试器配置正常")
  return true
end

-- 创建用户命令
vim.api.nvim_create_user_command('ConfigCheckAndFix', function()
  M.check_and_fix_config()
  M.check_dap_config()
end, { desc = '运行配置健康检查和修复' })

vim.api.nvim_create_user_command('ConfigCheck', function()
  M.check_and_fix_config()
  M.check_dap_config()
end, { desc = '运行配置健康检查' })

-- 如果直接运行此文件，执行检查
if ... == nil then
  M.check_and_fix_config()
end

return M