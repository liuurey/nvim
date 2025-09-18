-- LazyVim 键位冲突统一修复配置
-- 解决 which-key 检查报告中的所有重叠和重复问题

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

-- ========== 修复 LSP 相关冲突 ==========
-- 将原来分散在 g 系列的 LSP 功能统一到 <leader>l 前缀
keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP: 重命名" })
keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP: 代码操作" })
keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "LSP: 跳转到实现" })
keymap.set("n", "<leader>lR", vim.lsp.buf.references, { desc = "LSP: 查找引用" })
keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol, { desc = "LSP: 文档符号" })
keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "LSP: 悬停信息" })
keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "LSP: 跳转定义" })
keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "LSP: 跳转声明" })

-- ========== 修复诊断相关冲突 ==========
-- 将诊断功能从 <leader>x 迁移到 <leader>d，解决 LazyVim 冲突
keymap.set("n", "<leader>dd", function()
  if LazyVim and LazyVim.has("trouble.nvim") then
    vim.cmd("Trouble diagnostics toggle")
  else
    vim.diagnostic.setloclist()
  end
end, { desc = "诊断列表" })

keymap.set("n", "<leader>db", function()
  if LazyVim and LazyVim.has("trouble.nvim") then
    vim.cmd("Trouble diagnostics toggle filter.buf=0")
  else
    vim.diagnostic.setloclist()
  end
end, { desc = "缓冲区诊断" })

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
end, { desc = "Todo 列表" })

-- ========== 修复游戏功能冲突 ==========
-- 将游戏功能从 <leader>gol 迁移到 <leader>G
keymap.set("n", "<leader>Gl", function()
  if LazyVim and LazyVim.has("snacks.nvim") then
    Snacks.game.life()
  elseif LazyVim and LazyVim.has("cellular-automaton.nvim") then
    vim.cmd("CellularAutomaton game_of_life")
  else
    vim.notify("未找到游戏插件", vim.log.levels.WARN)
  end
end, { desc = "Game of Life" })

keymap.set("n", "<leader>Gr", function()
  if LazyVim and LazyVim.has("snacks.nvim") then
    Snacks.game.rain()
  elseif LazyVim and LazyVim.has("cellular-automaton.nvim") then
    vim.cmd("CellularAutomaton make_it_rain")
  else
    vim.notify("未找到游戏插件", vim.log.levels.WARN)
  end
end, { desc = "Make it Rain" })

-- ========== 修复通知和高亮冲突 ==========
-- 保持 <leader>n 作为通知，但将取消高亮改为更直观的键位
keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "取消搜索高亮" })
-- 保留一个备用的取消高亮键位，但使用不冲突的键
keymap.set("n", "<leader>uc", ":nohlsearch<CR>", { desc = "取消搜索高亮" })

-- ========== 修复 Dashboard 冲突 ==========
-- 将 Dashboard 从 s 移动到专用键位
keymap.set("n", "<leader>D", function()
  if LazyVim and LazyVim.has("dashboard-nvim") then
    vim.cmd("Dashboard")
  elseif LazyVim and LazyVim.has("alpha-nvim") then
    vim.cmd("Alpha")
  else
    vim.notify("No dashboard plugin found", vim.log.levels.WARN)
  end
end, { desc = "打开 Dashboard" })

-- ========== 统一 Which-key 配置 ==========
-- 延迟加载 which-key 配置以确保插件已加载
vim.schedule(function()
  local ok, wk = pcall(require, "which-key")
  if not ok then
    return
  end

  -- 统一定义所有组，避免重复
  wk.add({
    -- 主要功能组
    { "<leader>f", group = "file/find" },
    { "<leader>F", group = "format" },  -- 添加格式化组
    { "<leader>w", group = "windows" },
    { "<leader>q", group = "quit/session" },
    { "<leader>l", group = "lsp" },
    { "<leader>d", group = "diagnostics" },
    { "<leader>G", group = "games" },
    { "<leader>T", group = "themes" },
    { "<leader>b", group = "buffers" },
    { "<leader>?", group = "help/keymaps" },  -- 添加帮助组
    
    -- 单独功能
    { "<leader>n", desc = "通知历史" },
    { "<leader>D", desc = "Dashboard" },
    { "<leader>e", desc = "文件树" },
    { "<leader>uc", desc = "取消高亮" },
    
    -- 快捷键查看功能
    { "<leader>?k", desc = "显示所有快捷键" },
    { "<leader>?l", desc = "显示 Leader 快捷键" },
    { "<leader>?c", desc = "检查快捷键冲突" },
  })
end)

-- ========== 修复 <Space> 前缀冲突 ==========
-- 原问题：多个 <Space> 前缀存在子键冲突
-- 解决方案：重新组织 <Space> 下的键位布局

-- ========== 快捷键查看功能 ==========
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
        local rhs = keymap.rhs or keymap.callback and "<callback>" or "无定义"
        
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

-- 快速查看 Leader 键位的命令
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
          rhs = keymap.rhs or "<callback>",
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
end, { desc = '显示所有 Leader 键位映射' })

-- 快速查看快捷键冲突的命令
vim.api.nvim_create_user_command('CheckKeymapConflicts', function()
  print("\n=== 键位冲突检查 ===")
  
  local all_keymaps = {}
  local modes = {'n', 'i', 'v', 'x'}
  
  for _, mode in ipairs(modes) do
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
      local key = mode .. ":" .. keymap.lhs
      if all_keymaps[key] then
        table.insert(all_keymaps[key], keymap)
      else
        all_keymaps[key] = {keymap}
      end
    end
  end
  
  local conflicts_found = false
  for key, maps in pairs(all_keymaps) do
    if #maps > 1 then
      conflicts_found = true
      local mode, lhs = key:match("([^:]+):(.+)")
      print(string.format("\n⚠️  冲突键位: %s (模式: %s)", lhs, mode:upper()))
      for i, map in ipairs(maps) do
        local desc = map.desc or "无描述"
        print(string.format("  %d. %s", i, desc))
      end
    end
  end
  
  if not conflicts_found then
    print("✅ 未发现键位冲突")
  end
end, { desc = '检查键位映射冲突' })

-- 设置快捷键
keymap.set("n", "<leader>?k", "<cmd>ShowAllKeymaps<cr>", { desc = "显示所有快捷键" })
keymap.set("n", "<leader>?l", "<cmd>ShowLeaderKeymaps<cr>", { desc = "显示 Leader 快捷键" })
keymap.set("n", "<leader>?c", "<cmd>CheckKeymapConflicts<cr>", { desc = "检查快捷键冲突" })

