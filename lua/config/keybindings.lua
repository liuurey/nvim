-- Neovim 键位配置优化 - 统一中文描述，解决冲突
-- 核心策略：统一管理、避免重复、保持兼容性

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ========== 核心设计原则 ==========
-- 1. 统一中文描述，提升用户体验
-- 2. 避免与 LazyVim 默认键位冲突
-- 3. 使用明确的前缀分组管理
-- 4. 确保 which-key 组的唯一性

-- ========== 安全键位清理机制 ==========
-- 定义安全的键位删除函数，避免错误
local function safe_unmap(mode, key)
  local success, _ = pcall(vim.keymap.del, mode, key)
  return success
end

-- 定义批量清理函数
local function batch_unmap(mappings)
  for _, mapping in ipairs(mappings) do
    safe_unmap(mapping[1], mapping[2])
  end
end

-- 清理已知冲突的键位
local conflicting_keys = {
  {"n", "<leader>gol"},   -- 旧游戏键位
  {"n", "<leader>golr"},  -- 旧游戏键位
  {"n", "<space>l"},      -- 避免与 LazyVim 冲突
  {"n", "<space>e"},      -- 避免与文件浏览器冲突
  {"n", "<space>n"},      -- 避免与通知冲突
  {"n", "<leader>x"},     -- 清理可能与 diagnostics/quickfix 冲突的 x 组
  {"n", "<leader>l"},     -- 清理与 LazyVim Lazy 功能冲突的 l 键位
}

batch_unmap(conflicting_keys)

-- ========== 插件检测函数 ==========
-- 智能插件检测，提升兼容性
local function has_plugin(name)
  return pcall(require, name)
end

-- ========== LSP 功能重新设计 ==========
-- 使用 <leader>p 前缀作为 LSP 功能组，避免与 LazyVim 的 <space>l (Lazy) 冲突
-- 提供完整的 LSP 功能映射，保持语义清晰
-- 修复键位重叠问题：使用 <leader>p 替代 <leader>l 避免与 LazyVim 冲突

-- LSP 核心功能组（使用 p 前缀，表示 Programming/Project）
keymap.set("n", "<leader>pr", vim.lsp.buf.rename, { desc = "🔧 重命名符号" })
keymap.set("n", "<leader>pa", vim.lsp.buf.code_action, { desc = "🔧 代码操作" })
keymap.set("n", "<leader>pi", vim.lsp.buf.implementation, { desc = "🔧 跳转到实现" })
keymap.set("n", "<leader>pR", vim.lsp.buf.references, { desc = "🔧 查找引用" })
keymap.set("n", "<leader>ps", vim.lsp.buf.document_symbol, { desc = "🔧 文档符号" })
keymap.set("n", "<leader>ph", vim.lsp.buf.hover, { desc = "🔧 悬停信息" })
keymap.set("n", "<leader>pd", vim.lsp.buf.definition, { desc = "🔧 跳转到定义" })
keymap.set("n", "<leader>pD", vim.lsp.buf.declaration, { desc = "🔧 跳转到声明" })

-- 异步格式化功能（遵循内存规范，使用 <leader>F）
keymap.set("n", "<leader>F", function() 
  vim.lsp.buf.format({ async = true }) 
end, { desc = "🔧 格式化代码" })

-- 额外的格式化快捷方式
keymap.set("n", "<leader>pf", function() 
  vim.lsp.buf.format({ async = true }) 
end, { desc = "🔧 格式化代码" })

-- ========== 诊断和调试功能 ==========
-- 统一诊断功能到 <leader>d 前缀，智能检测插件可用性

-- 诊断列表功能
keymap.set("n", "<leader>dd", function()
  if has_plugin("trouble") then
    vim.cmd("Trouble diagnostics toggle")
  else
    vim.diagnostic.setloclist()
  end
end, { desc = "🔍 诊断问题列表" })

keymap.set("n", "<leader>db", function()
  if has_plugin("trouble") then
    vim.cmd("Trouble diagnostics toggle filter.buf=0")
  else
    vim.diagnostic.setloclist()
  end
end, { desc = "🔍 当前缓冲区诊断" })

keymap.set("n", "<leader>dq", function()
  if has_plugin("trouble") then
    vim.cmd("Trouble qflist toggle")
  else
    vim.cmd("copen")
  end
end, { desc = "🔍 快速修复列表" })

keymap.set("n", "<leader>dt", function()
  if has_plugin("trouble") then
    vim.cmd("Trouble todo toggle")
  else
    vim.notify("需要安装 trouble.nvim 插件", vim.log.levels.WARN)
  end
end, { desc = "🔍 待办事项列表" })

-- 诊断跳转（添加计数和回绕支持）
keymap.set("n", "<leader>dj", function()
  vim.diagnostic.goto_next({ wrap = true })
end, { desc = "🔍 下一个诊断" })

keymap.set("n", "<leader>dk", function()
  vim.diagnostic.goto_prev({ wrap = true })
end, { desc = "🔍 上一个诊断" })

keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "🔍 显示诊断详情" })

-- Python 调试功能（遵循内存规范，使用 <leader>py 前缀）
keymap.set("n", "<leader>pyb", function()
  if has_plugin("dap") then
    require("dap").toggle_breakpoint()
  else
    vim.notify("需要安装 nvim-dap 插件", vim.log.levels.WARN)
  end
end, { desc = "🐍 切换断点" })

keymap.set("n", "<leader>pyc", function()
  if has_plugin("dap") then
    require("dap").continue()
  else
    vim.notify("需要安装 nvim-dap 插件", vim.log.levels.WARN)
  end
end, { desc = "🐍 继续执行" })

-- ========== 趣味游戏功能 ==========
-- 整合娱乐功能到 <leader>G 前缀，优化插件检测
keymap.set("n", "<leader>Gl", function()
  if has_plugin("snacks") then
    require("snacks").game.life()
  elseif has_plugin("cellular-automaton") then
    vim.cmd("CellularAutomaton game_of_life")
  else
    vim.notify("🎮 未找到游戏插件 (snacks.nvim 或 cellular-automaton.nvim)", vim.log.levels.WARN)
  end
end, { desc = "🎮 生命游戏" })

keymap.set("n", "<leader>Gr", function()
  if has_plugin("snacks") then
    require("snacks").game.rain()
  elseif has_plugin("cellular-automaton") then
    vim.cmd("CellularAutomaton make_it_rain")
  else
    vim.notify("🎮 未找到游戏插件 (snacks.nvim 或 cellular-automaton.nvim)", vim.log.levels.WARN)
  end
end, { desc = "🎮 代码雨动画" })

-- 额外的娱乐功能
keymap.set("n", "<leader>Gz", function()
  if has_plugin("zone") then
    require("zone").run()
  else
    vim.notify("🎮 未找到 zone.nvim 插件", vim.log.levels.WARN)
  end
end, { desc = "🎮 禅意模式" })

-- ========== 搜索和高亮控制 ==========
-- 提供多种方式控制搜索高亮
keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "💡 取消搜索高亮" })
keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "💡 取消搜索高亮" })

-- 增强搜索体验
keymap.set("n", "n", "nzzzv", { desc = "💡 下一个搜索结果并居中" })
keymap.set("n", "N", "Nzzzv", { desc = "💡 上一个搜索结果并居中" })
keymap.set("n", "*", "*zzzv", { desc = "💡 搜索当前单词并居中" })
keymap.set("n", "#", "#zzzv", { desc = "💡 反向搜索当前单词并居中" })

-- ========== 快捷退出功能 ==========
-- 提供便捷的退出操作，提升操作效率
keymap.set("n", "<leader>Q", ":q<CR>", { desc = "🚪 退出当前窗口" })

-- 创建自定义命令 :Q 用于退出所有
vim.api.nvim_create_user_command('Q', function()
  -- 检查是否有未保存的文件
  local modified_bufs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
      table.insert(modified_bufs, vim.api.nvim_buf_get_name(buf))
    end
  end
  
  if #modified_bufs > 0 then
    local choice = vim.fn.confirm(
      "有 " .. #modified_bufs .. " 个未保存的文件，您想要：",
      "&保存并退出\n&直接退出\n&取消",
      1
    )
    
    if choice == 1 then
      -- 保存并退出所有
      vim.cmd("wa")
      vim.cmd("qa")
    elseif choice == 2 then
      -- 直接退出所有（不保存）
      vim.cmd("qa!")
    end
    -- choice == 3 或其他值：取消，不做任何操作
  else
    -- 没有未保存的文件，直接退出所有
    vim.cmd("qa")
  end
end, { desc = '🚪 智能退出所有窗口（保存检查）' })

-- ========== 仪表盘和启动页 ==========
-- Dashboard 启动页快捷访问，支持多种仪表盘插件
keymap.set("n", "<leader>D", function()
  if has_plugin("dashboard") then
    vim.cmd("Dashboard")
  elseif has_plugin("alpha") then
    vim.cmd("Alpha")
  elseif has_plugin("snacks") then
    require("snacks").dashboard.open()
  else
    vim.notify("📊 未找到仪表盘插件 (dashboard-nvim、alpha-nvim 或 snacks.nvim)", vim.log.levels.WARN)
  end
end, { desc = "📊 打开仪表盘" })

-- Krabby 启动画面快捷键
-- keymap.set("n", "<leader>Dk", function()
--   vim.cmd("Krabby")
-- end, { desc = "🦀 显示 Krabby 启动画面" })
-- 
-- keymap.set("n", "<leader>Dt", function()
--   vim.cmd("KrabbyToggle")
-- end, { desc = "🦀 切换 Krabby 启动显示" })

-- ========== which-key 组统一配置 ==========
-- 延迟加载 which-key 配置，确保插件已加载且避免重复定义
vim.schedule(function()
  local ok, wk = pcall(require, "which-key")
  if not ok then
    return
  end

  -- 统一注册自定义组，避免与 LazyVim 默认组冲突
  -- 移除 LSP 组的显式定义，让 which-key 根据实际键位自动分组（符合最佳实践）
  -- LSP 功能已迁移到 <leader>p 前缀，避免与 LazyVim 的 <space>l (Lazy) 冲突
  wk.add({
    -- 不再显式定义 <leader>p 组，让 which-key 根据 <leader>pr, <leader>pd 等键位自动创建 LSP 分组
    { "<leader>dd", group = "🔍 诊断调试" }, -- 使用dd避免与debug冲突
    { "<leader>G", group = "🎮 趣味游戏" },
    { "<leader>py", group = "🐍 Python调试" },
    { "<leader>C", group = "⚙️ 配置管理" },
    { "<leader>N", group = "📢 通知管理" },
    { "<leader>Th", group = "🎨 主题切换" },
    { "<leader>T", group = "💻 终端工具" },
    { "<leader>ss", group = "🔍 搜索浏览" }, -- 使用ss避免与search冲突
  })
end)

-- ========== 配置管理增强 ==========
-- 配置编辑移动到 <leader>C，完全避免 <space>e 冲突
keymap.set("n", "<leader>Cc", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "⚙️ 编辑配置文件" })

keymap.set("n", "<leader>Cv", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/lua/config/keybindings.lua")
end, { desc = "⚙️ 编辑键位配置" })

keymap.set("n", "<leader>Cp", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/lua/plugins/")
end, { desc = "⚙️ 编辑插件配置" })

keymap.set("n", "<leader>Cs", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/snippets/")
end, { desc = "⚙️ 编辑代码片段" })

-- 重新加载配置（增强版）
keymap.set("n", "<leader>Cr", function()
  -- 先保存当前缓冲区
  if vim.bo.modified then
    vim.cmd("write")
  end
  
  -- 重新加载配置
  vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
  vim.notify("✅ 配置文件已重新加载", vim.log.levels.INFO)
  
  -- 刷新当前缓冲区
  vim.cmd("edit!")
end, { desc = "🔄 重新加载配置" })

-- 配置检查命令
keymap.set("n", "<leader>Ch", function()
  vim.cmd("checkhealth")
end, { desc = "⚙️ 检查系统健康" })

-- ========== 通知管理增强 ==========
-- 通知功能移动到 <leader>N，避免 <space>n 冲突
keymap.set("n", "<leader>Nh", function()
  if has_plugin("telescope") then
    vim.cmd("Telescope notify")
  elseif has_plugin("snacks") and require("snacks").notifier then
    require("snacks").notifier.show_history()
  else
    -- 显示 Neovim 原生消息历史
    vim.cmd("messages")
  end
end, { desc = "📢 通知历史" })

-- 清理通知
keymap.set("n", "<leader>Nc", function()
  vim.cmd("messages clear")
  if has_plugin("snacks") and require("snacks").notifier then
    require("snacks").notifier.hide()
  end
  vim.notify("📢 所有通知已清理", vim.log.levels.INFO)
end, { desc = "📢 清理通知" })

-- 切换通知级别
keymap.set("n", "<leader>Nl", function()
  local level_input = vim.fn.input("输入日志级别 (TRACE/DEBUG/INFO/WARN/ERROR): ")
  local current_level = vim.log.levels[level_input:upper()] or vim.log.levels.INFO
  vim.lsp.set_log_level(current_level)
  vim.notify("📢 日志级别已设置为: " .. level_input:upper(), vim.log.levels.INFO)
end, { desc = "📢 设置日志级别" })

-- ========== 源码浏览增强 ==========
-- 新增的源码浏览功能（使用ss避免与LazyVim冲突）
keymap.set("n", "<leader>sss", function()
  if has_plugin("telescope") then
    vim.cmd("Telescope live_grep")
  else
    vim.notify("🔍 需要安装 telescope.nvim 插件", vim.log.levels.WARN)
  end
end, { desc = "🔍 全局搜索" })

keymap.set("n", "<leader>ssf", function()
  if has_plugin("telescope") then
    vim.cmd("Telescope find_files")
  else
    vim.notify("🔍 需要安装 telescope.nvim 插件", vim.log.levels.WARN)
  end
end, { desc = "🔍 搜索文件" })

keymap.set("n", "<leader>ssb", function()
  if has_plugin("telescope") then
    vim.cmd("Telescope buffers")
  else
    vim.cmd("ls")
  end
end, { desc = "🔍 浏览缓冲区" })

-- ========== 实用用户命令 ==========
-- 快速键位查看命令（增强版）
vim.api.nvim_create_user_command('ShowAllKeymaps', function(opts)
  local modes = opts.args ~= "" and {opts.args} or {'n', 'i', 'v', 'x', 't', 'c'}
  
  for _, mode in ipairs(modes) do
    local mode_name = {
      n = "📝 普通模式 (Normal)",
      i = "✍️ 插入模式 (Insert)", 
      v = "🔍 可视模式 (Visual)",
      x = "📁 可视块模式 (Visual Block)",
      t = "💻 终端模式 (Terminal)",
      c = "⚙️ 命令模式 (Command)",
      o = "🔄 操作符模式 (Operator)",
      s = "🎦 选择模式 (Select)"
    }
    
    print("\n=== " .. (mode_name[mode] or mode:upper()) .. " ===")
    
    -- 获取该模式下的所有键位映射
    local keymaps = vim.api.nvim_get_keymap(mode)
    
    if #keymaps > 0 then
      -- 按键位排序
      table.sort(keymaps, function(a, b)
        return a.lhs < b.lhs
      end)
      
      for _, keymap_item in ipairs(keymaps) do
        local desc = keymap_item.desc or "无描述"
        local rhs = keymap_item.rhs or keymap_item.callback and "<回调函数>" or "无定义"
        
        -- 格式化输出：键位 -> 命令/回调 (描述)
        if keymap_item.lhs:match("^<leader>") then
          -- 高亮 leader 键位
          print(string.format("  🔑 %-20s -> %-30s (%s)", keymap_item.lhs, rhs, desc))
        elseif keymap_item.lhs:match("^<C-") or keymap_item.lhs:match("^<A-") then
          -- 高亮 Ctrl/Alt 键位
          print(string.format("  ⚡ %-20s -> %-30s (%s)", keymap_item.lhs, rhs, desc))
        else
          print(string.format("     %-20s -> %-30s (%s)", keymap_item.lhs, rhs, desc))
        end
      end
    else
      print("  (无自定义键位映射)")
    end
  end
end, {
  nargs = '?',
  complete = function()
    return {'n', 'i', 'v', 'x', 't', 'c', 'o', 's'}
  end,
  desc = '🔍 显示所有或指定模式的键位映射'
})

-- Leader 键位总览命令（增强版）
vim.api.nvim_create_user_command('ShowLeaderKeymaps', function()
  print("\n=== 🔑 Leader 键位映射总览 ===")
  
  local leader_keymaps = {}
  local modes = {'n', 'i', 'v', 'x'}
  
  for _, mode in ipairs(modes) do
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap_item in ipairs(keymaps) do
      if keymap_item.lhs:match("^<leader>") then
        table.insert(leader_keymaps, {
          mode = mode,
          lhs = keymap_item.lhs,
          rhs = keymap_item.rhs or "<回调函数>",
          desc = keymap_item.desc or "无描述"
        })
      end
    end
  end
  
  -- 按键位分组
  table.sort(leader_keymaps, function(a, b)
    if a.lhs == b.lhs then
      return a.mode < b.mode
    end
    return a.lhs < b.lhs
  end)
  
  -- 按前缀分组显示
  local groups = {}
  for _, keymap_item in ipairs(leader_keymaps) do
    local prefix = keymap_item.lhs:match("^<leader>(%a+)")
    if prefix then
      groups[prefix] = groups[prefix] or {}
      table.insert(groups[prefix], keymap_item)
    end
  end
  
  for prefix, keymaps in pairs(groups) do
    print(string.format("\n🔍 组: <leader>%s", prefix))
    for _, keymap_item in ipairs(keymaps) do
      print(string.format("  [%s] %s - %s", keymap_item.mode:upper(), keymap_item.lhs, keymap_item.desc))
    end
  end
end, { desc = '🔑 显示所有Leader键位映射' })

-- ========== 高级功能命令 ==========
-- 清理通知命令（增强版）
vim.api.nvim_create_user_command('ClearNotifications', function()
  -- 清理所有通知
  if vim.notify and vim.notify.dismiss then
    vim.notify.dismiss()
  end
  
  -- 清理 messages
  vim.cmd('messages clear')
  
  -- 清理屏幕
  vim.cmd('redraw!')
  
  -- 清理 quickfix 列表
  vim.cmd('cclose')
  
  -- 清理 location 列表
  vim.cmd('lclose')
  
  print("✅ 所有通知和列表已清理")
end, { desc = '📢 清理所有通知和消息' })

-- 清理并检查键位命令（增强版）
vim.api.nvim_create_user_command('CleanCheckKeymap', function()
  -- 清理通知
  vim.cmd('ClearNotifications')
  
  -- 等待一秒然后检查 which-key
  vim.defer_fn(function()
    print("🔍 检查 which-key 的健康状态...")
    vim.cmd('checkhealth which-key')
  end, 1000)
end, { desc = '📢 清理通知并检查which-key状态' })

-- 键位冲突修复验证命令（增强版）
vim.api.nvim_create_user_command('VerifyKeymapFix', function()
  print("🔍 验证键位修复效果...")
  
  -- 检查是否还有冲突的键位
  local conflicts = {
    { key = "<leader>n", desc = "通知功能应该移动到 <leader>N" },
    { key = "<leader>l", desc = "LSP功能组，避免与 diagnostics/quickfix 冲突" }, 
    { key = "<leader>e", desc = "配置编辑应该移动到 <leader>C" },
    { key = "<space>l", desc = "与 LazyVim 的 Lazy 冲突" },
    { key = "<space>e", desc = "与 LazyVim 的 Explorer 冲突" },
    { key = "<space>n", desc = "与 LazyVim 的 Notification 冲突" },
  }
  
  local conflict_count = 0
  for _, conflict in ipairs(conflicts) do
    local keymap_result = vim.fn.maparg(conflict.key, 'n', false, true)
    if keymap_result and keymap_result ~= "" then
      print("⚠️  " .. conflict.key .. " 仍然存在: " .. conflict.desc)
      conflict_count = conflict_count + 1
    else
      print("✅ " .. conflict.key .. " 冲突已解决")
    end
  end
  
  -- 检查新的键位是否正确设置
  local new_keys = {
    { key = "<leader>Nh", desc = "通知历史" },
    { key = "<leader>pr", desc = "LSP重命名" },
    { key = "<leader>Cc", desc = "编辑配置" },
    { key = "<leader>F", desc = "格式化代码" },
    { key = "<leader>dd", desc = "诊断列表" },
    { key = "<leader>Gl", desc = "生命游戏" },
    { key = "<leader>Q", desc = "退出当前窗口" },
  }
  
  local success_count = 0
  for _, new_key in ipairs(new_keys) do
    local keymap_result = vim.fn.maparg(new_key.key, 'n', false, true)
    if keymap_result and keymap_result ~= "" then
      print("✅ " .. new_key.key .. " 已正确设置: " .. new_key.desc)
      success_count = success_count + 1
    else
      print("❌ " .. new_key.key .. " 未找到: " .. new_key.desc)
    end
  end
  
  print(string.format("\n📊 总结: %d/%d 冲突已解决, %d/%d 新键位已配置", 
    #conflicts - conflict_count, #conflicts, success_count, #new_keys))
  print("🎯 运行 :checkhealth which-key 查看详细状态")
end, { desc = '🔍 验证键位冲突修复效果' })

-- ========== 配置总结 ==========
-- 本配置文件完成了以下优化：
-- 1. 统一中文描述，提升用户体验
-- 2. 解决了与 LazyVim 的键位冲突
-- 3. 优化了插件检测机制
-- 4. 增强了诊断和调试功能
-- 5. 添加了实用的用户命令
-- 6. 统一了 which-key 组管理