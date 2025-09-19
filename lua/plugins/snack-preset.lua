-- 性能优化：缓存 lazy stats，避免重复计算
local cache = {
  stats = nil,
  stats_time = 0,
  startup_ready = false, -- 标记启动时间是否已经准备好
}

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
local function generate_footer()
  local stats = get_lazy_stats()
  local ms = stats.startuptime
  
  -- 如果启动时间为 0 且还没有准备好，显示等待信息
  if ms == 0 and not cache.startup_ready then
    return string.format("⚡ SANINS loaded %d/%d plugins (calculating...)", 
      stats.loaded, stats.count)
  end
  
  -- 正常显示启动时间
  local formatted_ms = math.floor(ms * 100 + 0.5) / 100
  return string.format("⚡ SANINS loaded %d/%d plugins in %sms", 
    stats.loaded, stats.count, formatted_ms)
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = function()
    
    return {
      -- SANINS 个性化配置
      bigfile = { enabled = true },
      dashboard = {
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
          keys = {
            { icon = "󰈞 ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "󰈔 ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = "󰊄 ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = "󰋚 ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = "󰒓 ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = "󰑓 ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy Manager", action = ":Lazy" },
            { icon = "󰓙 ", key = "h", desc = "Check Health", action = ":checkhealth" },
            { icon = "󰦤 ", key = "m", desc = "Mason Tools", action = ":Mason" },
            { icon = "󰔛 ", key = "t", desc = "Tree Sitter", action = ":TSInstallInfo" },
            { icon = "󰗼 ", key = "q", desc = "Quit", action = ":qa" },
          },
          footer = function()
            return generate_footer()
          end,
        },
      },
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
    
    -- 监听 LazyVimStarted 事件来更新启动时间
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      group = vim.api.nvim_create_augroup("SaninsStartupTime", { clear = true }),
      callback = function()
        cache.startup_ready = true
        cache.stats = nil  -- 清空缓存以获取最新的 startuptime
        
        -- 如果当前在 dashboard 中，刷新显示
        if vim.bo.filetype == 'snacks_dashboard' then
          vim.schedule(function()
            snacks.dashboard()
          end)
        end
      end,
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
        cache.startup_ready = false
      end,
    })
  end,
}