-- 主题插件配置
return {
  -- Kanagawa 主题
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = false,
        undercurl = true,
        commentStyle = { italic = true },
        functionStyle = {},
        keywordStyle = { italic = true },
        statementStyle = { bold = true },
        typeStyle = {},
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
          palette = {},
          theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
        },
        overrides = function(colors)
          return {}
        end,
        theme = "wave",
        background = {
          dark = "wave",
          light = "lotus"
        },
      })
    end,
  },

  -- Monokai 主题
  {
    "tanvirtin/monokai.nvim",
    priority = 1000,
    config = function()
      require('monokai').setup({
        palette = require('monokai').pro
      })
    end,
  },

  -- Tokyo Night 主题
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon",
        light_style = "day",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
      })
    end,
  },

  -- Catppuccin 主题
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
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
    end,
  },

  -- HardHacker 主题（默认主题）
  {
    "hardhackerlabs/theme-vim",
    name = "hardhacker",
    priority = 1000,
    config = function()
      vim.g.hardhacker_darker = 1
      vim.g.hardhacker_hide_tilde = 1
      vim.cmd.colorscheme("hardhacker")
    end,
  },

  -- GitHub 主题
  {
    "projekt0n/github-nvim-theme",
    priority = 1000,
    config = function()
      require('github-theme').setup({})
    end,
  },

  -- Monet 主题
  {
    "fynnfluegge/monet.nvim",
    priority = 1000,
    config = function()
      require("monet").setup({
        transparent_background = false,
        dark_mode = true,
        semantic_tokens = true,
        highlight_overrides = {},
        color_overrides = {},
        styles = {},
      })
    end,
  },

  -- Rose Pine 主题
  {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000,
    config = function()
      require("rose-pine").setup({})
    end,
  },

  -- Everforest 主题
  {
    "neanias/everforest-nvim",
    priority = 1000,
    config = function()
      require("everforest").setup({})
    end,
  },

  -- Nightfox 主题
  {
    "EdenEast/nightfox.nvim",
    priority = 1000,
    config = function()
      require("nightfox").setup({})
    end,
  },

  -- Themery 主题管理器
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 999, -- 确保在主题插件之后加载
    config = function()
      require("themery").setup({
        themes = {
          -- HardHacker 主题
          {
            name = "HardHacker",
            colorscheme = "hardhacker",
          },
          
          -- Kanagawa 主题变体
          {
            name = "Kanagawa Wave",
            colorscheme = "kanagawa-wave",
          },
          {
            name = "Kanagawa Dragon",
            colorscheme = "kanagawa-dragon",
          },
          {
            name = "Kanagawa Lotus",
            colorscheme = "kanagawa-lotus",
          },
          
          -- Tokyo Night 主题变体
          {
            name = "Tokyo Night",
            colorscheme = "tokyonight",
          },
          {
            name = "Tokyo Night Storm",
            colorscheme = "tokyonight-storm",
          },
          {
            name = "Tokyo Night Moon",
            colorscheme = "tokyonight-moon",
          },
          {
            name = "Tokyo Night Day",
            colorscheme = "tokyonight-day",
          },
          
          -- Catppuccin 主题变体
          {
            name = "Catppuccin Latte",
            colorscheme = "catppuccin-latte",
          },
          {
            name = "Catppuccin Frappe",
            colorscheme = "catppuccin-frappe",
          },
          {
            name = "Catppuccin Macchiato",
            colorscheme = "catppuccin-macchiato",
          },
          {
            name = "Catppuccin Mocha",
            colorscheme = "catppuccin-mocha",
          },
          
          -- GitHub 主题变体
          {
            name = "GitHub Dark",
            colorscheme = "github_dark",
          },
          {
            name = "GitHub Light",
            colorscheme = "github_light",
          },
          {
            name = "GitHub Dark Dimmed",
            colorscheme = "github_dark_dimmed",
          },
          
          -- Rose Pine 主题变体
          {
            name = "Rose Pine",
            colorscheme = "rose-pine",
          },
          {
            name = "Rose Pine Moon",
            colorscheme = "rose-pine-moon",
          },
          {
            name = "Rose Pine Dawn",
            colorscheme = "rose-pine-dawn",
          },
          
          -- Nightfox 主题变体
          {
            name = "Nightfox",
            colorscheme = "nightfox",
          },
          {
            name = "Dayfox",
            colorscheme = "dayfox",
          },
          {
            name = "Dawnfox",
            colorscheme = "dawnfox",
          },
          {
            name = "Duskfox",
            colorscheme = "duskfox",
          },
          {
            name = "Nordfox",
            colorscheme = "nordfox",
          },
          {
            name = "Terafox",
            colorscheme = "terafox",
          },
          {
            name = "Carbonfox",
            colorscheme = "carbonfox",
          },
          
          -- 其他主题
          {
            name = "Monokai Pro",
            colorscheme = "monokai_pro",
          },
          {
            name = "Monet",
            colorscheme = "monet",
          },
          {
            name = "Everforest",
            colorscheme = "everforest",
          },
        },
        
        -- 全局配置
        globalBefore = [[
          vim.cmd("hi clear")
        ]],
        globalAfter = [[
          vim.cmd("doautocmd ColorScheme")
        ]],
        
        -- 启用实时预览
        livePreview = true,
      })

      -- 全局主题切换快捷键
      vim.keymap.set("n", "<leader>tt", "<cmd>Themery<cr>", { desc = "打开主题选择器" })
      
      -- 快速切换到常用主题
      vim.keymap.set("n", "<leader>th", function()
        require("themery").setThemeByName("HardHacker", true)
      end, { desc = "切换到 HardHacker 主题" })
      
      vim.keymap.set("n", "<leader>tk", function()
        require("themery").setThemeByName("Kanagawa Wave", true)
      end, { desc = "切换到 Kanagawa 主题" })
      
      vim.keymap.set("n", "<leader>tc", function()
        require("themery").setThemeByName("Catppuccin Mocha", true)
      end, { desc = "切换到 Catppuccin 主题" })
      
      vim.keymap.set("n", "<leader>tn", function()
        require("themery").setThemeByName("Tokyo Night Moon", true)
      end, { desc = "切换到 Tokyo Night 主题" })
      
      vim.keymap.set("n", "<leader>tr", function()
        require("themery").setThemeByName("Rose Pine", true)
      end, { desc = "切换到 Rose Pine 主题" })
      
      vim.keymap.set("n", "<leader>tg", function()
        require("themery").setThemeByName("GitHub Dark", true)
      end, { desc = "切换到 GitHub 主题" })
    end,
  },
}