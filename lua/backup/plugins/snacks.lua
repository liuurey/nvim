-- 缓存全局状态和常用函数
local M = {}
local cache = {
  stats = nil,
  stats_time = 0,
}

-- 性能优化：缓存 lazy stats，避免重复计算
local function get_lazy_stats()
  local current_time = vim.loop.hrtime()
  -- 缓存 100ms，减少重复计算
  if not cache.stats or (current_time - cache.stats_time) > 100000000 then
    cache.stats = require("lazy").stats()
    cache.stats_time = current_time
  end
  return cache.stats
end

-- 统一的 footer 生成函数
local function generate_footer(mode)
  local stats = get_lazy_stats()
  local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
  return string.format("⚡ SANINS [%s] loaded %d/%d plugins in %sms", 
    mode:upper(), stats.loaded, stats.count, ms)
end

-- 安全的插件检查函数
local function has_plugin(name)
  return pcall(require, name)
end

-- 优化的模式切换函数
local function toggle_dashboard_mode()
  local current_mode = vim.g.dashboard_mode or "preset"
  local new_mode = (current_mode == "preset") and "sections" or "preset"
  vim.g.dashboard_mode = new_mode
  
  -- 安全的buffer检查和关闭
  if vim.bo.filetype == 'snacks_dashboard' then
    pcall(vim.cmd, 'bd')
  end
  
  -- 重新加载dashboard
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.dashboard then
    snacks.dashboard()
    vim.notify("Dashboard mode: " .. new_mode:upper(), vim.log.levels.INFO)
  end
end

-- 模块化的键位配置
local function get_common_keys()
  return {
    { icon = "󰈞 ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
    { icon = "󰈔 ", key = "n", desc = "New File", action = ":ene | startinsert" },
    { icon = "󰊄 ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
    { icon = "󰋚 ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
    { icon = "󰒓 ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
    { icon = "󰑓 ", key = "s", desc = "Restore Session", section = "session" },
    { icon = "󰒲 ", key = "l", desc = "Lazy Manager", action = ":Lazy", enabled = has_plugin("lazy") },
    { icon = "󰓙 ", key = "h", desc = "Health Check", action = ":checkhealth" },
    { icon = "󰦤 ", key = "m", desc = "Mason Tools", action = ":Mason" },
    { icon = "󰔛 ", key = "t", desc = "TreeSitter", action = ":TSInstallInfo" },
    { icon = "󰗼 ", key = "q", desc = "Quit", action = ":qa" },
    { icon = "🔄 ", key = "<F12>", desc = "Toggle Mode", action = toggle_dashboard_mode },
  }
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = function()
    -- 初始化模式（使用vim.g而不是_G避免全局污染）
    vim.g.dashboard_mode = vim.g.dashboard_mode or "preset"
    
    -- Preset 配置方案
    local preset_config = {
      enabled = true,
      preset = {
        header = [[
    ┌─────────────────────────────────────────────────────────────┐
    │  ░██████╗░█████╗░███╗░░██╗██╗███╗░░██╗░██████╝  ▄██████▄  │
    │  ██╔════╝██╔══██╗████╗░██║██║████╗░██║██╔════╝ ██╔════██╗ │
    │  ╚█████╗░███████║██╔██╗██║██║██╔██╗██║╚█████╗░ ██║    ██║ │
    │  ░╚═══██╗██╔══██║██║╚████║██║██║╚████║░╚═══██╗ ██║    ██║ │
    │  ██████╔╝██║░░██║██║░╚███║██║██║░╚███║██████╔╝ ╚██████╔╝  │
    │  ╚═════╝░╚═╝░░╚═╝╚═╝░░╚══╝╚═╝╚═╝░░╚══╝╚═════╝░  ╚═════╝   │
    │            ▓▓▓ Next-Gen Neovim Experience ▓▓▓             │
    └─────────────────────────────────────────────────────────────┘
        ]],
        keys = get_common_keys(),
        footer = function()
          return generate_footer("preset")
        end,
      },
    }
    
    -- Sections 配置方案（优化版）
    local sections_config = {
      enabled = true,
      sections = {
        -- Header 分区
        {
          section = "header",
          text = [[
    ╔═══════════════════════════════════════════════════════════╗
    ║  ▓██████▓ ▓█████▄ ██▓███▓ ▓█████▄██   ██▓██████▓█████▄  ║
    ║  ██▓       ██▓ ▓██▓██▓███▓   ▓ ██▓ ▓██▓▓██ ██▓▓   ██▓ ▓██▓ ║
    ║  ▓█████▓ ▓█████▓▓██▓ ▓██▓ ▓██▓▓█████▓█████▓█████▓▓ ║
    ║       ▓██▓██▓ ▓██▓██▓   ▓▓██▓ ▓██▓▓██▓██▓     ▓██▓██▓ ▓██▓ ║
    ║  ▓██████▓▓██▓ ▓██▓██▓███▓▓██▓ ▓██▓▓██▓ ██▓██████▓▓██▓ ▓██▓ ║
    ║            ⟨⟨⟨ Advanced Sections Layout ⟩⟩⟩             ║
    ╚═══════════════════════════════════════════════════════════╝
          ]],
          align = "center",
          padding = 1,
        },
        
        -- 插件统计信息（使用优化的缓存函数）
        {
          text = function()
            return generate_footer("sections")
          end,
          align = "center",
          padding = 1,
        },
        
        -- 功能按键分区（左侧）
        {
          pane = 1,
          title = "🚀 Quick Actions",
          padding = 1,
        },
        { pane = 1, icon = "󰈞 ", title = "Find File", desc = "Search files", action = ":lua Snacks.dashboard.pick('files')", key = "f" },
        { pane = 1, icon = "󰈔 ", title = "New File", desc = "Create new", action = ":ene | startinsert", key = "n" },
        { pane = 1, icon = "󰊄 ", title = "Find Text", desc = "Search text", action = ":lua Snacks.dashboard.pick('live_grep')", key = "g" },
        { pane = 1, icon = "󰒓 ", title = "Config", desc = "Edit config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})", key = "c" },
        
        -- 工具分区（右侧）
        {
          pane = 2,
          title = "🔧 Development Tools",
          padding = 1,
        },
        { pane = 2, icon = "󰒲 ", title = "Lazy Manager", desc = "Plugin manager", action = ":Lazy", key = "l" },
        { pane = 2, icon = "󰓙 ", title = "Health Check", desc = "System health", action = ":checkhealth", key = "h" },
        { pane = 2, icon = "󰦤 ", title = "Mason Tools", desc = "LSP manager", action = ":Mason", key = "m" },
        { pane = 2, icon = "󰔛 ", title = "TreeSitter", desc = "Parser info", action = ":TSInstallInfo", key = "t" },
        
        -- Recent Files 分区
        {
          pane = 2,
          title = "📁 Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 1,
          limit = 5,
        },
        
        -- 切换按键
        {
          text = "Press <F12> to switch to PRESET mode",
          align = "center",
          padding = 1,
          hl = "Comment",
        },
      },
    }
    
    -- 根据模式返回对应配置
    local dashboard_config = (vim.g.dashboard_mode == "sections") and sections_config or preset_config
    
    return {
      -- SANINS 个性化配置
      bigfile = { enabled = true },
      dashboard = dashboard_config,
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      image = { enabled = true }, -- 启用图像显示功能
    }
  end,
  
  config = function(_, opts)
    local ok, snacks = pcall(require, "snacks")
    if not ok then
      vim.notify("Failed to load snacks.nvim", vim.log.levels.ERROR)
      return
    end
    
    snacks.setup(opts)
    
    -- 添加优化的切换命令
    vim.api.nvim_create_user_command("DashboardToggle", toggle_dashboard_mode, {
      desc = "Toggle dashboard mode between preset and sections"
    })
    
    -- 添加F12键位映射（统一使用toggle函数）
    vim.keymap.set("n", "<F12>", toggle_dashboard_mode, {
      desc = "Toggle dashboard mode",
      silent = true
    })
    
    -- 优化的启动时dashboard显示
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("SaninsDashboard", { clear = true }),
      callback = function()
        -- 更准确的启动检查：无参数且当前buffer为空
        if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" and vim.api.nvim_buf_line_count(0) <= 1 then
          local line = vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] or ""
          if line == "" then
            snacks.dashboard()
          end
        end
      end,
    })
    
    -- 缓存清理（可选，用于长时间运行的session）
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = vim.api.nvim_create_augroup("SaninsCleanup", { clear = true }),
      callback = function()
        cache.stats = nil
      end,
    })
  end,
}