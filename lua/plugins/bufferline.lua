return {
  -- 标签栏增强 (Termux 优化版本)
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
      }
    },
    keys = {
      { "leader,p", "<cmd>BufferLineTogglePin<cr>", desc = "切换固定标签" },
      { "leader,P", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "关闭未固定的标签" },
      { "leader,o", "<cmd>BufferLineCloseOthers<cr>", desc = "关闭其他标签" },
      { "leader,r", "<cmd>BufferLineCloseRight<cr>", desc = "关闭右侧标签" },
      { "leader,l", "<cmd>BufferLineCloseLeft<cr>", desc = "关闭左侧标签" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "上一个标签" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "下一个标签" },
    },
    opts = {
      options = {
        mode = "buffers",
        -- Termux 优化设置
        numbers = "none", -- 简化显示
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        indicator = {
          style = 'icon',
          icon = '▎',
        },
        buffer_close_icon = '×', -- 简单的关闭图标
        modified_icon = '●',
        close_icon = '×', -- 简单的关闭按钮图标
        left_trunc_marker = '<',
        right_trunc_marker = '>',
        max_name_length = 12, -- 减小名称长度以适应小屏幕
        max_prefix_length = 10, -- 减小前缀长度
        tab_size = 12, -- 减小标签大小
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and "E" or "W"
          return " " .. icon .. count
        end,
        color_icons = false, -- 禁用彩色图标以提高性能
        show_buffer_icons = false, -- 禁用文件图标以提高性能
        show_buffer_close_icons = false, -- 禁用关闭图标以提高性能
        show_buffer_default_icon = false,
        show_close_icon = false, -- 禁用关闭图标以提高性能
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "thin",
        enforce_regular_tabs = false,
        always_show_bufferline = false,
        hover = {
          enabled = false, -- 禁用悬停以提高性能
          delay = 200,
          reveal = {'close'}
        },
        sort_by = 'insert_after_current',
        offsets = {
          { 
            filetype = "NvimTree", 
            text = "文件浏览器", 
            highlight = "Directory", 
            text_align = "left",
            separator = false -- 简化分隔符
          },
          {
            filetype = "neo-tree",
            text = "文件浏览器",
            highlight = "Directory",
            text_align = "left",
            separator = false
          }
        },
      },
    },
  },
  
  -- 智能文本移动增强
  {
    'chrisgrieser/nvim-spider',
    keys = {
      -- Readline风格的Ctrl+左右箭头，符合终端编辑习惯
      -- Ctrl+Left: 向后移动一个单词(开头)
      { '<C-Left>', '<cmd>lua require("spider").motion("b")<CR>', mode = { 'i', 'n', 'c' }, desc = '上一个单词(Ctrl+←)' },
      
      -- Ctrl+Right: 向前移动一个单词(开头)
      { '<C-Right>', '<cmd>lua require("spider").motion("w")<CR>', mode = { 'i', 'n', 'c' }, desc = '下一个单词(Ctrl+→)' },
      
      -- Alt+Left/Right: 在插入模式下也支持单词跳转
      { '<M-Left>', '<cmd>lua require("spider").motion("b")<CR>', mode = 'i', desc = '上一个单词(Alt+←)' },
      { '<M-Right>', '<cmd>lua require("spider").motion("w")<CR>', mode = 'i', desc = '下一个单词(Alt+→)' },
    },
    opts = {
      -- 跳过不重要的标点符号，更符合编程习惯
      skipInsignificantPunctuation = true,
    },
  }
}