-- DAP 调试器配置检查脚本
-- 用于诊断和验证 DAP 适配器配置问题

local M = {}

-- 检查文件是否存在且可执行
local function check_executable(path)
  if not path or path == "" then
    return false, "路径为空"
  end
  
  if vim.fn.filereadable(path) == 0 then
    return false, "文件不存在或不可读"
  end
  
  if vim.fn.executable(path) == 0 then
    return false, "文件不可执行"
  end
  
  return true, "OK"
end

-- 获取 Windows 调试器路径
local function get_windows_debugger_path(tool_name)
  local possible_paths = {
    vim.fn.stdpath("data") .. "/mason/bin/" .. tool_name .. ".exe",
    vim.fn.stdpath("data") .. "/mason/packages/" .. tool_name .. "/" .. tool_name .. ".exe",
    vim.fn.stdpath("data") .. "/mason/packages/" .. tool_name .. "/extension/debugAdapters/bin/OpenDebugAD7.exe",
    vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7.exe",
    vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb.exe",
    vim.fn.stdpath("data") .. "/mason/packages/codelldb/codelldb.exe",
  }
  
  for _, path in ipairs(possible_paths) do
    local ok, msg = check_executable(path)
    if ok then
      return path, msg
    end
  end
  
  -- 检查系统 PATH
  if vim.fn.executable(tool_name) == 1 then
    return tool_name, "在系统PATH中找到"
  end
  
  return nil, "未找到可执行文件"
end

-- 检查 DAP 适配器
function M.check_dap_adapters()
  print("=== DAP 调试器配置检查 ===")
  print()
  
  local adapters_to_check = {
    { name = "codelldb", tool = "codelldb" },
    { name = "cppdbg", tool = "OpenDebugAD7" },
    { name = "python", tool = "python" },
    { name = "debugpy", tool = "debugpy-adapter" },
  }
  
  for _, adapter in ipairs(adapters_to_check) do
    local path, msg = get_windows_debugger_path(adapter.tool)
    local status = path and "✅" or "❌"
    
    print(string.format("%s %s (%s):", status, adapter.name, adapter.tool))
    
    if path then
      print(string.format("  路径: %s", path))
      print(string.format("  状态: %s", msg))
    else
      print(string.format("  错误: %s", msg))
      
      -- 提供修复建议
      if adapter.tool == "OpenDebugAD7" then
        print("  建议: 运行 :MasonInstall cpptools 安装 Microsoft C/C++ Extension")
        print("  或使用 codelldb 作为替代调试器")
      elseif adapter.tool == "debugpy-adapter" then
        print("  建议: 运行 :MasonInstall debugpy 安装 Python 调试器")
      elseif adapter.tool == "codelldb" then
        print("  建议: 运行 :MasonInstall codelldb 安装 LLDB 调试器")
      end
    end
    print()
  end
  
  -- 检查 DAP 配置
  local has_dap, dap = pcall(require, 'dap')
  if not has_dap then
    print("❌ nvim-dap 插件未加载")
    return
  end
  
  print("=== DAP 适配器注册状态 ===")
  print()
  
  local registered_adapters = { "codelldb", "cppdbg", "python", "gdb", "node2" }
  for _, adapter_name in ipairs(registered_adapters) do
    local adapter = dap.adapters[adapter_name]
    if adapter then
      print(string.format("✅ %s: 已注册", adapter_name))
      if adapter.command then
        local ok, msg = check_executable(adapter.command)
        local status = ok and "✅" or "❌"
        print(string.format("  %s 命令: %s (%s)", status, adapter.command, msg))
      end
    else
      print(string.format("❌ %s: 未注册", adapter_name))
    end
  end
  
  print()
  print("=== 建议的修复步骤 ===")
  print("1. 运行 :MasonInstall cpptools 安装 Microsoft C/C++ Extension")
  print("2. 运行 :MasonInstall debugpy 确保 Python 调试器已安装")
  print("3. 重启 Neovim 重新加载配置")
  print("4. 运行 :checkhealth dap 检查 DAP 健康状态")
end

-- 安装缺失的调试器
function M.install_missing_debuggers()
  local tools_to_install = {}
  
  -- 检查 cpptools
  local cpptools_path = get_windows_debugger_path("OpenDebugAD7")
  if not cpptools_path then
    table.insert(tools_to_install, "cpptools")
  end
  
  -- 检查 debugpy
  local debugpy_path = get_windows_debugger_path("debugpy-adapter")
  if not debugpy_path then
    table.insert(tools_to_install, "debugpy")
  end
  
  if #tools_to_install > 0 then
    print("准备安装缺失的调试器: " .. table.concat(tools_to_install, ", "))
    for _, tool in ipairs(tools_to_install) do
      vim.cmd("MasonInstall " .. tool)
    end
    print("安装完成！请重启 Neovim。")
  else
    print("所有调试器已安装！")
  end
end

-- 创建用户命令
vim.api.nvim_create_user_command('DapCheck', function()
  M.check_dap_adapters()
end, { desc = '检查 DAP 调试器配置' })

vim.api.nvim_create_user_command('DapInstallMissing', function()
  M.install_missing_debuggers()
end, { desc = '安装缺失的 DAP 调试器' })

return M