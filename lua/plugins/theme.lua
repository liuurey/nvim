-- region: 主题插件配置模块
-- 主题插件配置
return {
  -- Kanagawa 主题
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = true,
    priority = 1000,
    config = function()
      local status_ok, kanagawa = pcall(require, "kanagawa")
      if not status_ok then
        vim.notify("Failed to load kanagawa theme", vim.log.levels.ERROR)
        return
      end
      
      kanagawa.setup({
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
    lazy = true,
    priority = 999,
    config = function()
      local status_ok, monokai = pcall(require, 'monokai')
      if not status_ok then
        vim.notify("Failed to load monokai theme", vim.log.levels.ERROR)
        return
      end
      
      monokai.setup({
        palette = monokai.pro
      })
    end,
  },

  -- Tokyo Night 主题
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 998,
    config = function()
      local status_ok, tokyonight = pcall(require, "tokyonight")
      if not status_ok then
        vim.notify("Failed to load tokyonight theme", vim.log.levels.ERROR)
        return
      end
      
      tokyonight.setup({
        style = "moon", -- storm, moon, night, day
        light_style = "day",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark", -- dark, transparent, normal
          floats = "dark", -- dark, transparent, normal
        },
        sidebars = { "qf", "help", "vista_kind", "terminal", "packer" },
        day_brightness = 0.3, -- 0.1 - 1.0
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
        
        -- 自定义颜色覆盖
        on_colors = function(colors)
          -- 可以在这里自定义颜色
        end,
        
        -- 自定义高亮组
        on_highlights = function(highlights, colors)
          -- 可以在这里自定义高亮
        end,
      })
    end,
  },

  -- Catppuccin 主题
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 997,
    config = function()
      local status_ok, catppuccin = pcall(require, "catppuccin")
      if not status_ok then
        vim.notify("Failed to load catppuccin theme", vim.log.levels.ERROR)
        return
      end
      
      catppuccin.setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true, -- 修复：启用终端颜色
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
        -- 集成配置
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          telescope = true,
          notify = true,
          mini = true,
        },
      })
    end,
  },

  -- HardHacker 主题（默认主题）
  {
    "hardhackerlabs/theme-vim",
    name = "hardhacker",
    lazy = false, -- 默认主题不延迟加载
    priority = 1001, -- 最高优先级
    config = function()
      -- 安全设置全局变量
      vim.g.hardhacker_darker = 1
      vim.g.hardhacker_hide_tilde = 1
      
      -- 安全设置配色方案
      local colorscheme_status_ok, _ = pcall(vim.cmd.colorscheme, "hardhacker")
      if not colorscheme_status_ok then
        vim.notify("Failed to set hardhacker colorscheme, using default", vim.log.levels.WARN)
        vim.cmd.colorscheme("default")
      else
        vim.notify("HardHacker theme loaded as default", vim.log.levels.INFO)
      end
    end,
  },

  -- GitHub 主题
  {
    "projekt0n/github-nvim-theme",
    lazy = true,
    priority = 996,
    config = function()
      local status_ok, github_theme = pcall(require, 'github-theme')
      if not status_ok then
        vim.notify("Failed to load github-theme", vim.log.levels.ERROR)
        return
      end
      
      github_theme.setup({
        options = {
          compile_path = vim.fn.stdpath('cache') .. '/github-theme',
          compile_file_suffix = '_compiled',
          hide_end_of_buffer = true,
          hide_nc_statusline = true,
          transparent = false,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
          styles = {
            comments = 'italic',
            functions = 'NONE',
            keywords = 'bold',
            conditionals = 'NONE',
            constants = 'NONE',
            numbers = 'NONE',
            operators = 'NONE',
            strings = 'NONE',
            types = 'NONE',
            variables = 'NONE',
          },
        },
      })
    end,
  },

  -- Monet 主题
  {
    "fynnfluegge/monet.nvim",
    lazy = true,
    priority = 995,
    config = function()
      local status_ok, monet = pcall(require, "monet")
      if not status_ok then
        vim.notify("Failed to load monet theme", vim.log.levels.ERROR)
        return
      end
      
      monet.setup({
        transparent_background = false,
        dark_mode = true,
        semantic_tokens = true,
        highlight_overrides = {},
        color_overrides = {},
        styles = {
          comments = { italic = true },
          keywords = { bold = true },
          functions = {},
          variables = {},
        },
      })
    end,
  },

  -- Rose Pine 主题
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 994,
    config = function()
      local status_ok, rose_pine = pcall(require, "rose-pine")
      if not status_ok then
        vim.notify("Failed to load rose-pine theme", vim.log.levels.ERROR)
        return
      end
      
      rose_pine.setup({
        variant = "auto", -- auto, main, moon, dawn
        dark_variant = "main", -- main, moon, dawn
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
        
        enable = {
          terminal = true,
          legacy_highlights = true,
          migrations = true,
        },
        
        styles = {
          bold = true,
          italic = true,
          transparency = false,
        },
        
        groups = {
          border = "muted",
          link = "iris",
          panel = "surface",
          
          error = "love",
          hint = "iris",
          info = "foam",
          note = "pine",
          todo = "rose",
          warn = "gold",
          
          git_add = "foam",
          git_change = "rose",
          git_delete = "love",
          git_dirty = "rose",
          git_ignore = "muted",
          git_merge = "iris",
          git_rename = "pine",
          git_stage = "iris",
          git_text = "rose",
          git_untracked = "subtle",
        },
      })
    end,
  },

  -- Everforest 主题
  {
    "neanias/everforest-nvim",
    lazy = true,
    priority = 993,
    config = function()
      local status_ok, everforest = pcall(require, "everforest")
      if not status_ok then
        vim.notify("Failed to load everforest theme", vim.log.levels.ERROR)
        return
      end
      
      everforest.setup({
        background = "medium", -- hard, medium, soft
        transparent_background_level = 0, -- 0, 1, 2
        italics = true,
        disable_italic_comments = false,
        sign_column_background = "none", -- none, grey
        ui_contrast = "low", -- low, high
        dim_inactive_windows = false,
        diagnostic_text_highlight = false,
        diagnostic_virtual_text = "coloured", -- grey, coloured
        diagnostic_line_highlight = false,
        spell_foreground = false,
        show_eob = true,
        float_style = "bright", -- bright, dim
      })
    end,
  },

  -- Nightfox 主题
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    priority = 992,
    config = function()
      local status_ok, nightfox = pcall(require, "nightfox")
      if not status_ok then
        vim.notify("Failed to load nightfox theme", vim.log.levels.ERROR)
        return
      end
      
      nightfox.setup({
        options = {
          compile_path = vim.fn.stdpath("cache") .. "/nightfox",
          compile_file_suffix = "_compiled",
          transparent = false,
          terminal_colors = true,
          dim_inactive = false,
          module_default = true,
          colorblind = {
            enable = false,
            simulate_only = false,
            severity = {
              protan = 0,
              deutan = 0,
              tritan = 0,
            },
          },
          styles = {
            comments = "italic",
            conditionals = "NONE",
            constants = "NONE",
            functions = "NONE",
            keywords = "bold",
            numbers = "NONE",
            operators = "NONE",
            strings = "NONE",
            types = "NONE",
            variables = "NONE",
          },
          inverse = {
            match_paren = false,
            visual = false,
            search = false,
          },
        },
        palettes = {},
        specs = {},
        groups = {},
      })
    end,
  },

  -- OneDarkPro 主题
  {
    "olimorris/onedarkpro.nvim",
    lazy = true,
    priority = 991,
    config = function()
      local status_ok, onedarkpro = pcall(require, "onedarkpro")
      if not status_ok then
        vim.notify("Failed to load onedarkpro theme", vim.log.levels.ERROR)
        return
      end
      
      onedarkpro.setup({
        colors = {}, -- 自定义颜色覆盖
        highlights = {}, -- 自定义高亮覆盖
        styles = {
          types = "NONE",
          methods = "NONE",
          numbers = "NONE",
          strings = "NONE",
          comments = "italic",
          keywords = "bold,italic",
          constants = "NONE",
          functions = "italic",
          operators = "NONE",
          variables = "NONE",
          parameters = "NONE",
          conditionals = "italic",
          virtual_text = "NONE",
        },
        filetypes = {
          c = true,
          cpp = true,
          cs = true,
          java = true,
          javascript = true,
          lua = true,
          markdown = true,
          php = true,
          python = true,
          ruby = true,
          rust = true,
          typescript = true,
          vue = true,
          yaml = true,
        },
        plugins = {
          aerial = true,
          barbar = true,
          copilot = true,
          dashboard = true,
          flash_nvim = true,
          gitsigns = true,
          hop = true,
          indentline = true,
          leap = true,
          lsp_saga = true,
          marks = true,
          mini_indentscope = true,
          neotest = true,
          neo_tree = true,
          nvim_cmp = true,
          nvim_bqf = true,
          nvim_dap = true,
          nvim_dap_ui = true,
          nvim_hlslens = true,
          nvim_lsp = true,
          nvim_navic = true,
          nvim_notify = true,
          nvim_tree = true,
          nvim_ts_rainbow = true,
          op_nvim = true,
          packer = true,
          polygot = true,
          rainbow_delimiters = true,
          startify = true,
          telescope = true,
          toggleterm = true,
          treesitter = true,
          trouble = true,
          vim_ultest = true,
          which_key = true,
        },
        options = {
          cursorline = false,
          transparency = false,
          terminal_colors = true,
          lualine_transparency = false,
          highlight_inactive_windows = false,
        }
      })
    end,
  },

  -- Themery 主题管理器
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 500, -- 确保在主题插件之后加载
    config = function()
      local status_ok, themery = pcall(require, "themery")
      if not status_ok then
        vim.notify("Failed to load themery theme manager", vim.log.levels.ERROR)
        return
      end
      
      themery.setup({
        themes = {
          "hardhacker",
          "kanagawa-wave",
          "kanagawa-dragon", 
          "kanagawa-lotus",
          "tokyonight",
          "tokyonight-storm",
          "tokyonight-moon",
          "tokyonight-day",
          "catppuccin-latte",
          "catppuccin-frappe", 
          "catppuccin-macchiato",
          "catppuccin-mocha",
          "github_dark",
          "github_light",
          "github_dark_dimmed",
          "rose-pine",
          "rose-pine-moon",
          "rose-pine-dawn",
          "nightfox",
          "dayfox",
          "dawnfox", 
          "duskfox",
          "nordfox",
          "terafox",
          "carbonfox",
          "onedarkpro",
          "monokai_pro",
          "monet",
          "everforest",
        },
        livePreview = true,
      })

      -- 全局主题切换快捷键
      vim.keymap.set("n", "<leader>Tt", "<cmd>Themery<cr>", { desc = "打开主题选择器" })
      
      -- 直接使用 vim.cmd.colorscheme 切换主题（避免 Themery API 问题）
      vim.keymap.set("n", "<leader>Th", function()
        pcall(vim.cmd.colorscheme, "hardhacker")
        vim.notify("Switched to HardHacker", vim.log.levels.INFO)
      end, { desc = "切换到 HardHacker 主题" })
      
      vim.keymap.set("n", "<leader>Tk", function()
        pcall(vim.cmd.colorscheme, "kanagawa-wave")
        vim.notify("Switched to Kanagawa Wave", vim.log.levels.INFO)
      end, { desc = "切换到 Kanagawa 主题" })
      
      vim.keymap.set("n", "<leader>Tc", function()
        pcall(vim.cmd.colorscheme, "catppuccin-mocha")
        vim.notify("Switched to Catppuccin Mocha", vim.log.levels.INFO)
      end, { desc = "切换到 Catppuccin 主题" })
      
      vim.keymap.set("n", "<leader>Tn", function()
        pcall(vim.cmd.colorscheme, "tokyonight-moon")
        vim.notify("Switched to Tokyo Night Moon", vim.log.levels.INFO)
      end, { desc = "切换到 Tokyo Night 主题" })
      
      vim.keymap.set("n", "<leader>Tr", function()
        pcall(vim.cmd.colorscheme, "rose-pine")
        vim.notify("Switched to Rose Pine", vim.log.levels.INFO)
      end, { desc = "切换到 Rose Pine 主题" })
      
      vim.keymap.set("n", "<leader>Tg", function()
        pcall(vim.cmd.colorscheme, "github_dark")
        vim.notify("Switched to GitHub Dark", vim.log.levels.INFO)
      end, { desc = "切换到 GitHub 主题" })
      
      vim.keymap.set("n", "<leader>To", function()
        pcall(vim.cmd.colorscheme, "onedarkpro")
        vim.notify("Switched to OneDarkPro", vim.log.levels.INFO)
      end, { desc = "切换到 OneDarkPro 主题" })
    end,
  },
}
-- endregion