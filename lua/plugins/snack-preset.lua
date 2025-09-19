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
            { icon = "󰓙 ", key = "h", desc = "Check Health", action = function()
              -- 安全地执行健康检查，避免 dashboard 关闭时的 autocmd 错误
              local function safe_check_health()
                -- 检查是否在 dashboard 中
                if vim.bo.filetype == 'snacks_dashboard' then
                  -- 获取当前窗口信息
                  local current_win = vim.api.nvim_get_current_win()
                  local current_buf = vim.api.nvim_get_current_buf()
                  
                  -- 先保存当前窗口布局信息
                  local win_valid = vim.api.nvim_win_is_valid(current_win)
                  
                  -- 延迟执行健康检查，确保 dashboard 完全关闭
                  vim.defer_fn(function()
                    -- 如果窗口仍然有效，安全关闭它
                    if win_valid and vim.api.nvim_win_is_valid(current_win) then
                      pcall(function()
                        vim.api.nvim_win_close(current_win, true)
                      end)
                    end
                    
                    -- 延迟执行健康检查，给 dashboard 清理时间
                    vim.defer_fn(function()
                      vim.cmd('checkhealth')
                    end, 100)
                  end, 50)
                else
                  -- 不在 dashboard 中，直接执行健康检查
                  vim.cmd('checkhealth')
                end
              end
              
              -- 使用 pcall 包装整个操作，防止任何错误
              local ok, err = pcall(safe_check_health)
              if not ok then
                vim.notify('Health check failed: ' .. tostring(err), vim.log.levels.ERROR)
                -- 如果失败，至少尝试执行基本的健康检查
                pcall(function() vim.cmd('checkhealth') end)
              end
            end },
            { icon = "󰦤 ", key = "m", desc = "Mason Tools", action = ":Mason" },
            -- { icon = "󰔛 ", key = "t", desc = "Tree Sitter", action = function()
            --   -- TreeSitter 信息命令 - 简化版本
            --   vim.schedule(function()
            --     if vim.fn.exists(':TSInstallInfo') > 0 then
            --       vim.cmd('TSInstallInfo')
            --     else
            --       vim.notify('TreeSitter 命令未就绪，请等待插件加载完成', vim.log.levels.INFO)
            --     end
            --   end)
            -- end },
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
    -- 预先创建所有需要的 augroup，避免在 autocmd 中重复创建
    local startup_group = vim.api.nvim_create_augroup("SaninsStartupTime", { clear = true })
    local dashboard_group = vim.api.nvim_create_augroup("SaninsDashboard", { clear = true })
    local cleanup_group = vim.api.nvim_create_augroup("SaninsCleanup", { clear = true })
    local dashboard_cleanup_group = vim.api.nvim_create_augroup("SaninsDashboardCleanup", { clear = true })
    
    local ok, snacks = pcall(require, "snacks")
    if not ok then
      vim.notify("Failed to load snacks.nvim", vim.log.levels.ERROR)
      return
    end
    
    -- 安全地设置 snacks，避免内部 autocmd 冲突
    local success, err = pcall(function()
      snacks.setup(opts)
    end)
    
    if not success then
      vim.notify("Snacks setup error: " .. tostring(err), vim.log.levels.WARN)
    end
    
    -- 监听 LazyVimStarted 事件来更新启动时间
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      group = startup_group,
      callback = function()
        cache.startup_ready = true
        cache.stats = nil  -- 清空缓存以获取最新的 startuptime
        
        -- 如果当前在 dashboard 中，刷新显示
        if vim.bo.filetype == 'snacks_dashboard' then
          vim.schedule(function()
            pcall(function()
              snacks.dashboard()
            end)
          end)
        end
      end,
    })
    
    -- 优化的启动时dashboard显示
    vim.api.nvim_create_autocmd("VimEnter", {
      group = dashboard_group,
      callback = function()
        -- 更准确的启动检查：无参数且当前buffer为空
        if vim.fn.argc() == 0 and vim.api.nvim_buf_get_name(0) == "" and vim.api.nvim_buf_line_count(0) <= 1 then
          local line = vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] or ""
          if line == "" then
            vim.defer_fn(function()
              pcall(function()
                snacks.dashboard()
              end)
            end, 100)
          end
        end
      end,
    })
    
    -- 安全地处理 dashboard 关闭，避免 autocmd 错误
    vim.api.nvim_create_autocmd("BufWipeout", {
      group = dashboard_cleanup_group,
      pattern = "*",
      callback = function(args)
        -- 如果 dashboard buffer 被销毁，清理相关状态
        if vim.bo[args.buf].filetype == 'snacks_dashboard' then
          -- 添加调试信息
          vim.schedule(function()
            vim.notify("Dashboard buffer wiped out, cleaning up...", vim.log.levels.DEBUG)
          end)
          
          -- 延迟清理，避免在 autocmd 执行期间删除 augroup
          vim.defer_fn(function()
            -- 安全地清理可能的 dashboard 状态
            local cleanup_ok, cleanup_err = pcall(function()
              -- 这里可以添加任何必要的清理代码
              -- 例如：清理 dashboard 相关的内部状态
              
              -- 检查 snacks 是否可用
              local snacks_ok, snacks_module = pcall(require, "snacks")
              if snacks_ok and snacks_module then
                -- 安全地关闭任何残留的 dashboard 窗口
                pcall(function()
                  -- 如果有 dashboard 函数可用，尝试清理
                  if snacks_module.dashboard then
                    -- 不直接调用 dashboard()，避免重新创建
                  end
                end)
              end
            end)
            
            if not cleanup_ok then
              vim.notify("Dashboard cleanup error: " .. tostring(cleanup_err), vim.log.levels.WARN)
            end
          end, 100)  -- 增加延迟时间到 100ms
        end
      end,
    })
    
    -- 缓存清理（可选，用于长时间运行的session）
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = cleanup_group,
      callback = function()
        cache.stats = nil
        cache.startup_ready = false
      end,
    })
  end,
}