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
    { "<leader>w", group = "windows" },
    { "<leader>q", group = "quit/session" },
    { "<leader>l", group = "lsp" },
    { "<leader>d", group = "diagnostics" },
    { "<leader>G", group = "games" },
    { "<leader>T", group = "themes" },
    { "<leader>b", group = "buffers" },
    
    -- 单独功能
    { "<leader>n", desc = "通知历史" },
    { "<leader>D", desc = "Dashboard" },
    { "<leader>e", desc = "文件树" },
    { "<leader>uc", desc = "取消高亮" },
  })
end)

-- ========== 修复 <Space> 前缀冲突 ==========
-- 原问题：多个 <Space> 前缀存在子键冲突
-- 解决方案：重新组织 <Space> 下的键位布局

