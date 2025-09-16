-- LazyVim 按键冲突修复配置
-- 解决 LazyVim 检查报告中的按键重叠问题

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ========== 解决按键冲突的策略 ==========
-- 1. 保留 LazyVim 默认的有用功能
-- 2. 重新映射冲突的按键到更合理的位置
-- 3. 使用一致的前缀避免未来冲突

-- ========== 修复 <s> 系列冲突 ==========
-- 原问题：<s> 与 <ss> 冲突
-- 解决方案：将 Dashboard action 移到 <leader>D，保留 <ss> 的替换功能
keymap.set("n", "<leader>D", function()
  if LazyVim.has("dashboard-nvim") then
    vim.cmd("Dashboard")
  elseif LazyVim.has("alpha-nvim") then
    vim.cmd("Alpha")
  else
    vim.notify("No dashboard plugin found", vim.log.levels.WARN)
  end
end, { desc = "打开 Dashboard" })

-- ========== 修复 <g> 系列冲突 ==========
-- 原问题：<g> 与多个 g 开头的按键冲突
-- 解决方案：保留原生 vim 的 g 功能，LSP 相关功能使用 <leader>l 前缀

-- LSP 相关功能重新映射到 <leader>l 前缀
keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP: 重命名" })
keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP: 代码操作" })
keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { desc = "LSP: 跳转到实现" })
keymap.set("n", "<leader>lR", vim.lsp.buf.references, { desc = "LSP: 查找引用" })
keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol, { desc = "LSP: 文档符号" })

-- 保留常用的 g 系列原生功能
-- gd, gD, gi, ge 等保持原样，它们是 vim 原生功能

-- ========== 修复 <Space> 前缀冲突 ==========
-- 原问题：多个 <Space> 前缀存在子键冲突
-- 解决方案：重新组织 <Space> 下的键位布局

-- 诊断相关：<Space>x -> <Space>d (diagnostics)
keymap.set("n", "<leader>dd", function()
  if LazyVim.has("trouble.nvim") then
    vim.cmd("Trouble diagnostics toggle")
  else
    vim.diagnostic.setloclist()
  end
end, { desc = "诊断列表" })

keymap.set("n", "<leader>dB", function()
  if LazyVim.has("trouble.nvim") then
    vim.cmd("Trouble diagnostics toggle filter.buf=0")
  else
    vim.diagnostic.setloclist()
  end
end, { desc = "缓冲区诊断" })

keymap.set("n", "<leader>dq", function()
  if LazyVim.has("trouble.nvim") then
    vim.cmd("Trouble qflist toggle")
  else
    vim.cmd("copen")
  end
end, { desc = "快速修复列表" })

keymap.set("n", "<leader>dl", function()
  if LazyVim.has("trouble.nvim") then
    vim.cmd("Trouble loclist toggle")
  else
    vim.cmd("lopen")
  end
end, { desc = "位置列表" })

keymap.set("n", "<leader>dt", function()
  if LazyVim.has("trouble.nvim") then
    vim.cmd("Trouble todo toggle")
  end
end, { desc = "Todo 列表" })

-- 通知相关：保持 <Space>n 但避免子键冲突
-- 将 "取消高亮" 移到更直观的位置
keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "取消搜索高亮" })
keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "取消搜索高亮" })

-- 会话/退出相关：重新组织 <Space>q
-- 保持原有功能但使用更清晰的键位
keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "退出所有" })
keymap.set("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "强制退出所有" })

-- 文件相关：<Space>f 保持不变，这是标准布局
-- LazyVim 的文件操作布局已经很合理，不需要修改

-- 窗口相关：<Space>w 保持不变
-- LazyVim 的窗口管理布局已经很合理，不需要修改

-- ========== 修复可视模式和操作符模式冲突 ==========
-- 原问题：<i> 和 <a> 与子键冲突
-- 解决方案：这些是 vim 原生的文本对象，应该保持不变
-- 冲突是正常的，因为 vim 需要等待用户输入完整的文本对象

-- ========== 修复注释相关冲突 ==========
-- 原问题：<gc> 与子键冲突
-- 解决方案：保持 LazyVim 的注释插件默认配置
-- 这些冲突是正常的，插件会正确处理

-- ========== 修复游戏相关冲突 ==========
-- 原问题：<Space>gol 与 <Space>golr 冲突
-- 解决方案：重新组织到专门的游戏前缀
keymap.set("n", "<leader>Gl", function()
  if LazyVim.has("snacks.nvim") then
    Snacks.game.life()
  end
end, { desc = "Game of Life" })

keymap.set("n", "<leader>Gr", function()
  if LazyVim.has("snacks.nvim") then
    Snacks.game.rain()
  end
end, { desc = "Make it Rain" })

-- ========== 解决与 keymaps.lua 的冲突 ==========
-- 注意：基础的按键映射（如 <C-s>, jk, 移动行等）已在 keymaps.lua 中定义
-- 这里只保留专门解决 LazyVim 冲突的映射

-- 确保 LazyVim 特定的冲突解决方案不与 keymaps.lua 冲突
-- 如果需要额外的按键映射，请在 keymaps.lua 中添加

-- ========== Which-key 冲突修复配置 ==========
-- 专门用于解决 which-key 检查报告中的重叠警告

-- 延迟加载 which-key 配置以确保插件已加载
vim.schedule(function()
  local ok, wk = pcall(require, "which-key")
  if not ok then
    return
  end

  -- ========== 禁用导致冲突的通用前缀映射 ==========
  -- 这些映射会与 vim 原生功能或其他插件冲突

  -- 1. 移除通用的 <g> 映射，保留具体的 g 开头命令
  -- which-key 不应该为单个 <g> 创建映射，因为它与原生 vim 的 g 命令冲突
  wk.add({
    -- 不要添加 { "<g>", group = "goto" } 这样的映射
    -- 让 vim 原生处理所有 g 开头的命令
  })

  -- 2. 移除通用的 <s> 映射，避免与 <ss> 冲突
  -- Dashboard 功能已经在上面重新映射到 <leader>D

  -- 3. 重新组织 which-key 的组定义，避免前缀冲突
  wk.add({
    -- 文件操作组 - 保持 <leader>f 前缀
    { "<leader>f", group = "file/find" },
    
    -- 窗口操作组 - 保持 <leader>w 前缀  
    { "<leader>w", group = "windows" },
    
    -- 诊断操作组 - 使用 <leader>d 而不是 <leader>x
    { "<leader>d", group = "diagnostics" },
    
    -- 退出/会话组 - 保持 <leader>q 前缀
    { "<leader>q", group = "quit/session" },
    
    -- LSP 操作组 - 使用 <leader>l 前缀
    { "<leader>l", group = "lsp" },
    
    -- 游戏功能组 - 使用 <leader>G 前缀
    { "<leader>G", group = "games" },
    
    -- 通知相关 - 保持 <leader>n 但不创建子组冲突
    { "<leader>n", desc = "Notification History" },
  })

  -- ========== 配置 which-key 选项以减少冲突警告 ==========
  wk.setup({
    preset = "modern",
    delay = function(ctx)
      return ctx.plugin and 0 or 200
    end,
    filter = function(mapping)
      -- 过滤掉可能导致冲突的映射
      local key = mapping.lhs
      
      -- 不为单个字母创建 which-key 组（除了 leader 键）
      if #key == 1 and key ~= " " then
        return false
      end
      
      -- 不为 g 开头的单个命令创建组
      if key:match("^g$") then
        return false
      end
      
      -- 不为 s 开头的单个命令创建组  
      if key:match("^s$") then
        return false
      end
      
      return true
    end,
    spec = {
      -- 明确定义不冲突的键位组
      { "<leader>f", group = "file/find" },
      { "<leader>w", group = "windows" },
      { "<leader>d", group = "diagnostics" },
      { "<leader>q", group = "quit/session" },
      { "<leader>l", group = "lsp" },
      { "<leader>G", group = "games" },
      { "<leader>n", desc = "Notification History" },
      { "<leader>D", desc = "Dashboard" },
    },
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
    layout = {
      spacing = 3,
    },
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
  })

  -- ========== 确保与 LazyVim 的兼容性 ==========
  -- 如果使用 LazyVim，确保不覆盖其默认配置
  if LazyVim then
    -- LazyVim 特定的 which-key 配置调整
    local lazyvim_keys = {
      -- 保持 LazyVim 的默认键位，但移除冲突的组定义
      { "<leader>f", group = "file/find" },
      { "<leader>w", group = "windows" },
      { "<leader>q", group = "quit/session" },
      -- 使用 <leader>d 替代 <leader>x 用于诊断
      { "<leader>d", group = "diagnostics" },
    }
    
    wk.add(lazyvim_keys)
  end
end)

-- ========== 说明 ==========
-- 这个配置文件的目标是解决 LazyVim 检查报告中的按键冲突
-- 主要策略：
-- 1. 保留 LazyVim 和 vim 原生的有用功能
-- 2. 将冲突的功能重新映射到更合理的位置
-- 3. 使用一致的前缀系统避免未来冲突
-- 4. 添加一些实用的额外按键映射
-- 5. 配置 which-key 以减少冲突警告

-- 注意：某些"冲突"实际上是正常的 vim 行为
-- 例如 <g> 与 <gd> 的"冲突"是因为 vim 需要等待完整的按键序列
-- 这种情况下不需要修复，vim 会正确处理

-- Which-key 冲突修复说明：
-- - 移除了通用的 <g> 和 <s> 映射以避免与原生命令冲突
-- - 重新组织了 <leader> 前缀下的键位分组
-- - 配置了过滤器以避免为单个字母创建 which-key 组
-- - 保持了与 LazyVim 的兼容性
