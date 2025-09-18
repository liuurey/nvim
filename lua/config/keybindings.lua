-- Neovim 键位配置优化 - 中文描述 + 冲突解决
-- 统一所有键位描述为中文，避免功能重叠和按键冲突

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ========== 核心策略 ==========
-- 1. 统一管理所有 which-key 组定义，避免重复
-- 2. 解决键位重叠问题
-- 3. 移除冲突的旧键位
-- 4. 保持功能完整性

-- ========== 移除冲突的旧键位 ==========
-- 先清理可能存在的冲突键位
local function safe_unmap(mode, key)
  pcall(vim.keymap.del, mode, key)
end

-- 清理可能导致冲突的旧键位
safe_unmap("n", "<leader>gol")
safe_unmap("n", "<leader>golr")
safe_unmap("n", "s")  -- 只清理如果被重新定义的 s

-- ========== LSP 功能统一配置 ==========
-- 统一 LSP 功能到 <leader>l 前缀，避免与其他功能冲突
keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "重命名符号" })
keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "代码操作" })
keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "跳转到实现" })
keymap.set("n", "<leader>lR", vim.lsp.buf.references, { desc = "查找引用" })
keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol, { desc = "文档符号" })
keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "悬停信息" })
keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "跳转到定义" })
keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "跳转到声明" })
keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { desc = "格式化代码" })

-- ========== 诊断和调试功能 ==========
-- 统一诊断功能到 <leader>d 前缀，与调试功能共存
keymap.set("n", "<leader>dd", function()
  if LazyVim and LazyVim.has("trouble.nvim") then
    vim.cmd("Trouble diagnostics toggle")
  else
    vim.diagnostic.setloclist()
  end
end, { desc = "诊断问题列表" })

keymap.set("n", "<leader>db", function()
  if LazyVim and LazyVim.has("trouble.nvim") then
    vim.cmd("Trouble diagnostics toggle filter.buf=0")
  else
    vim.diagnostic.setloclist()
  end
end, { desc = "当前缓冲区诊断" })

keymap.set("n", "<leader>dq", function()
  if LazyVim and LazyVim.has("trouble.nvim") then
    vim.cmd("Trouble qflist toggle")
  else
    vim.cmd("copen")
  end
end, { desc = "快速修复列表" })

keymap.set("n", "<leader>dt", function()
  if LazyVim and LazyVim.has("trouble.nvim") then
    vim.cmd("Trouble todo toggle")
  end
end, { desc = "待办事项列表" })

-- 诊断跳转
keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { desc = "下一个诊断" })
keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { desc = "上一个诊断" })
keymap.set("n", "<leader>de", vim.diagnostic.open_float, { desc = "显示诊断详情" })

-- ========== 趣味游戏功能 ==========
-- 整合娱乐功能到 <leader>G 前缀
keymap.set("n", "<leader>Gl", function()
  if LazyVim and LazyVim.has("snacks.nvim") then
    Snacks.game.life()
  elseif LazyVim and LazyVim.has("cellular-automaton.nvim") then
    vim.cmd("CellularAutomaton game_of_life")
  else
    vim.notify("未找到游戏插件", vim.log.levels.WARN)
  end
end, { desc = "生命游戏" })

keymap.set("n", "<leader>Gr", function()
  if LazyVim and LazyVim.has("snacks.nvim") then
    Snacks.game.rain()
  elseif LazyVim and LazyVim.has("cellular-automaton.nvim") then
    vim.cmd("CellularAutomaton make_it_rain")
  else
    vim.notify("未找到游戏插件", vim.log.levels.WARN)
  end
end, { desc = "代码雨动画" })

-- ========== 搜索和高亮控制 ==========
-- 优化搜索高亮的管理
keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "取消搜索高亮" })
keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "取消搜索高亮" })

-- ========== 仪表盘和启动页 ==========
-- Dashboard 启动页快捷访问
keymap.set("n", "<leader>D", function()
  if LazyVim and LazyVim.has("dashboard-nvim") then
    vim.cmd("Dashboard")
  elseif LazyVim and LazyVim.has("alpha-nvim") then
    vim.cmd("Alpha")
  else
    vim.notify("未找到仪表盘插件", vim.log.levels.WARN)
  end
end, { desc = "打开仪表盘" })

-- ========== which-key 组统一配置 ==========
-- 延迟加载 which-key 配置以确保插件已加载
-- 只定义必要的自定义组，避免与 LazyVim 默认组重复
vim.schedule(function()
  local ok, wk = pcall(require, "which-key")
  if not ok then
    return
  end

  -- 只添加 LazyVim 中不存在的自定义组
  wk.add({
    -- Python 调试专用组（使用 py 前缀避免冲突）
    { "<leader>py", group = "🐍 Python调试" },
    
    -- 趣味游戏功能组
    { "<leader>G", group = "🎮 趣味游戏" },
    
    -- 主题切换组
    { "<leader>T", group = "🎨 主题切换" },
  })
end)

-- ========== 移除冲突的 Space 键位 ==========
-- 移除与 LazyVim 默认键位冲突的 <Space> 前缀映射
local function remove_conflicting_space_keymaps()
  -- 移除与 <Space>l (Lazy) 冲突的 LSP 键位
  local space_l_keys = {
    "<space>lf", "<space>ls", "<space>li", "<space>ld", 
    "<space>lr", "<space>la", "<space>lR", "<space>lh", "<space>lD"
  }
  
  -- 移除与 <Space>e (Explorer) 冲突的键位
  local space_e_keys = { "<space>ev", "<space>ec" }
  
  -- 移除与 <Space>n (Notification) 冲突的键位
  local space_n_keys = { "<space>nh" }
  
  local all_conflicting_keys = {}
  vim.list_extend(all_conflicting_keys, space_l_keys)
  vim.list_extend(all_conflicting_keys, space_e_keys)
  vim.list_extend(all_conflicting_keys, space_n_keys)
  
  for _, key in ipairs(all_conflicting_keys) do
    pcall(vim.keymap.del, "n", key)
  end
end

-- 立即执行清理
remove_conflicting_space_keymaps()

-- ========== 帮助和诊断工具 ==========
-- 统一的快捷键查看命令，支持查看所有模式的键位映射
vim.api.nvim_create_user_command('ShowAllKeymaps', function(opts)
  local modes = opts.args ~= "" and {opts.args} or {'n', 'i', 'v', 'x', 't', 'c'}
  
  for _, mode in ipairs(modes) do
    local mode_name = {
      n = "普通模式 (Normal)",
      i = "插入模式 (Insert)", 
      v = "可视模式 (Visual)",
      x = "可视块模式 (Visual Block)",
      t = "终端模式 (Terminal)",
      c = "命令模式 (Command)",
      o = "操作符模式 (Operator)",
      s = "选择模式 (Select)"
    }
    
    print("\n=== " .. (mode_name[mode] or mode:upper()) .. " ===")
    
    -- 获取该模式下的所有键位映射
    local keymaps = vim.api.nvim_get_keymap(mode)
    
    if #keymaps > 0 then
      -- 按键位排序
      table.sort(keymaps, function(a, b)
        return a.lhs < b.lhs
      end)
      
      for _, keymap in ipairs(keymaps) do
        local desc = keymap.desc or "无描述"
        local rhs = keymap.rhs or keymap.callback and "<回调函数>" or "无定义"
        
        -- 格式化输出：键位 -> 命令/回调 (描述)
        if keymap.lhs:match("^<leader>") then
          -- 高亮 leader 键位
          print(string.format("  🔑 %-20s -> %-30s (%s)", keymap.lhs, rhs, desc))
        elseif keymap.lhs:match("^<C-") or keymap.lhs:match("^<A-") then
          -- 高亮 Ctrl/Alt 键位
          print(string.format("  ⚡ %-20s -> %-30s (%s)", keymap.lhs, rhs, desc))
        else
          print(string.format("     %-20s -> %-30s (%s)", keymap.lhs, rhs, desc))
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
  desc = '显示所有或指定模式的键位映射'
})

-- Leader 键位总览命令
vim.api.nvim_create_user_command('ShowLeaderKeymaps', function()
  print("\n=== Leader 键位映射总览 ===")
  
  local leader_keymaps = {}
  local modes = {'n', 'i', 'v', 'x'}
  
  for _, mode in ipairs(modes) do
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs:match("^<leader>") then
        table.insert(leader_keymaps, {
          mode = mode,
          lhs = keymap.lhs,
          rhs = keymap.rhs or "<回调函数>",
          desc = keymap.desc or "无描述"
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
  
  local current_key = ""
  for _, keymap in ipairs(leader_keymaps) do
    if keymap.lhs ~= current_key then
      current_key = keymap.lhs
      print(string.format("\n🔑 %s", keymap.lhs))
    end
    print(string.format("  [%s] %s", keymap.mode:upper(), keymap.desc))
  end
end, { desc = '显示所有Leader键位映射' })

-- 快捷键冲突检查命令
-- ========== 用户命令 ==========
-- 清理通知命令
vim.api.nvim_create_user_command('ClearNotifications', function()
  -- 清理所有通知
  if vim.notify and vim.notify.dismiss then
    vim.notify.dismiss()
  end
  
  -- 清理 messages
  vim.cmd('messages clear')
  
  -- 清理屏幕
  vim.cmd('redraw!')
  
  print("✅ 所有通知已清理")
end, { desc = '清理所有通知和消息' })

-- 清理并检查键位命令
vim.api.nvim_create_user_command('CleanCheckKeymap', function()
  -- 清理通知
  vim.cmd('ClearNotifications')
  
  -- 等待一秒然后检查 which-key
  vim.defer_fn(function()
    vim.cmd('checkhealth which-key')
  end, 1000)
end, { desc = '清理通知并检查which-key状态' })

-- ========== 基本功能键位 ==========
-- 只保留与 LazyVim 不冲突的必要键位

-- 搜索高亮管理（保留主要功能）
keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "取消搜索高亮" })
keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "💡 取消搜索高亮" })

-- 快速编辑配置文件（避免与 <space>e 冲突）
keymap.set("n", "<leader>ec", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "⚙️ 编辑配置文件" })

keymap.set("n", "<leader>sv", function()
  vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
  vim.notify("✅ 配置文件已重新加载")
end, { desc = "🔄 重新加载配置" })

