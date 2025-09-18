return {
  'gen740/SmoothCursor.nvim',
  config = function()
    require('smoothcursor').setup({
      -- 光标类型设置
      type = "default",           -- "default" | "exp" (exponential) | "matrix" | "horizontal-line" | "vertical-line"
      
      -- 光标外观
      cursor = "",              -- 光标字符 (可以使用 emoji 或特殊字符)
      texthl = "SmoothCursor",   -- 高亮组名称
      linehl = nil,              -- 行高亮 (通常设为 nil)
      
      -- 动画设置
      fancy = {
        enable = true,           -- 启用花哨效果
        head = { cursor = "▷", texthl = "SmoothCursorRed", linehl = nil },
        body = {
          { cursor = "󰝥", texthl = "SmoothCursorOrange" },
          { cursor = "●", texthl = "SmoothCursorYellow" },
          { cursor = "●", texthl = "SmoothCursorGreen" },
          { cursor = "•", texthl = "SmoothCursorAqua" },
          { cursor = ".", texthl = "SmoothCursorBlue" },
          { cursor = ".", texthl = "SmoothCursorPurple" },
        },
        tail = { cursor = nil, texthl = "SmoothCursorGrey" }
      },
      
      -- 矩阵效果 (当 type = "matrix" 时)
      matrix = {
        head = {
          cursor = require('smoothcursor.matrix_chars'),
          texthl = {
            "SmoothCursorGreen",
          },
          linehl = nil,
        },
        body = {
          length = 6,
          cursor = require('smoothcursor.matrix_chars'),
          texthl = {
            "SmoothCursorGreen",
          },
        },
        tail = {
          cursor = nil,
          texthl = {
            "SmoothCursorGreen",
          },
        },
        unstop = false,  -- 矩阵效果是否持续
      },
      
      -- 自动命令设置
      autostart = true,          -- 自动启动
      always_redraw = true,      -- 总是重绘
      flyin_effect = nil,        -- 飞入效果 (nil | "bottom" | "top" | "left" | "right")
      speed = 25,                -- 动画速度 (数值越大越快)
      intervals = 35,            -- 更新间隔 (毫秒)
      priority = 10,             -- 优先级
      timeout = 3000,            -- 超时时间 (毫秒)
      threshold = 3,             -- 移动阈值 (光标移动多少行才触发动画)
      max_threshold = nil,       -- 最大阈值
      disable_float_win = false, -- 禁用浮动窗口中的效果
      enabled_filetypes = nil,   -- 启用的文件类型 (nil 表示所有)
      disabled_filetypes = nil,  -- 禁用的文件类型
      
      -- 显示模式设置
      show_last_positions = nil, -- 显示最后位置
    })
    
    -- 设置自定义高亮颜色
    local autocmd = vim.api.nvim_create_autocmd
    autocmd({ "ColorScheme", "VimEnter" }, {
      callback = function()
        vim.api.nvim_set_hl(0, "SmoothCursorRed", { fg = "#ff5f87" })
        vim.api.nvim_set_hl(0, "SmoothCursorOrange", { fg = "#ffaf5f" })
        vim.api.nvim_set_hl(0, "SmoothCursorYellow", { fg = "#ffff87" })
        vim.api.nvim_set_hl(0, "SmoothCursorGreen", { fg = "#87ff5f" })
        vim.api.nvim_set_hl(0, "SmoothCursorAqua", { fg = "#5fffaf" })
        vim.api.nvim_set_hl(0, "SmoothCursorBlue", { fg = "#5f87ff" })
        vim.api.nvim_set_hl(0, "SmoothCursorPurple", { fg = "#af5fff" })
        vim.api.nvim_set_hl(0, "SmoothCursorGrey", { fg = "#6b6b6b" })
      end,
    })
  end
}