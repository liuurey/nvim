-- 主题插件配置
return {
  -- Kanagawa 主题
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,             -- 启用编译以提高性能
        undercurl = true,            -- 启用下划线
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true},
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,         -- 不使用透明背景
        dimInactive = false,         -- 不使非活动窗口变暗
        terminalColors = true,       -- 定义 vim.g.terminal_color_{0,17}
        colors = {                   -- 添加/修改主题和调色板颜色
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors) -- 添加/修改高亮组
          return {}
        end,
        theme = "wave",              -- 加载 "wave" 主题变体
        background = {               -- 映射背景设置
          dark = "wave",             -- 尝试 "lotus" 以获得浅色变体
          light = "lotus"
        },
      })
       vim.cmd("colorscheme kanagawa-wave")  -- 暂时注释，避免加载错误
    end,
  },

  -- Monokai 主题
  {
    "tanvirtin/monokai.nvim",
    priority = 1000,
    config = function()
      require('monokai').setup {
        palette = require('monokai').pro
      }
      -- vim.cmd("colorscheme monokai")  -- 暂时注释
    end,
  },

  -- Tokyo Night 主题
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon", -- storm, moon, night, day
        light_style = "day",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark", -- style for sidebars, see below
          floats = "dark", -- style for floating windows
        },
        sidebars = { "qf", "help" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
      })
      -- vim.cmd("colorscheme tokyonight-moon")  -- 激活 Tokyo Night 主题
    end,
  },

  -- Catppuccin 主题
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = false,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,
        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },
      })
      -- vim.cmd("colorscheme catppuccin")  -- 暂时注释
    end,
  },
}