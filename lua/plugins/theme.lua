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
          blink_cmp = true,  -- 使用 blink.cmp 而不是 nvim-cmp
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

  -- OneDarkPro 主题 (升级版)
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
        -- 自定义颜色覆盖 - 可以指定特定主题的颜色
        colors = {
          -- 全局颜色覆盖
          -- red = "#FF6B6B",
          -- green = "#51CF66",
          
          -- 按主题指定颜色
          onedark = {
            -- bg = "#1e2124", -- 更深的背景色
          },
          onelight = {
            -- bg = "#fafafa", -- 更亮的背景色
          },
          onedark_vivid = {
            -- 鲜艳主题的自定义颜色
          },
          onedark_dark = {
            -- 深色主题的自定义颜色
          },
          vaporwave = {
            -- 蒸汽波主题的自定义颜色
          },
        },
        
        -- 自定义高亮组覆盖
        highlights = {
          -- 示例：自定义注释颜色
          -- Comment = { fg = "${gray}", italic = true },
          -- 示例：自定义错误高亮
          -- Error = { fg = "${red}", bg = "${bg}", bold = true },
        },
        
        -- 代码样式配置
        styles = {
          types = "NONE",              -- 类型样式
          methods = "NONE",            -- 方法样式
          numbers = "NONE",            -- 数字样式
          strings = "NONE",            -- 字符串样式
          comments = "italic",         -- 注释样式
          keywords = "bold,italic",    -- 关键字样式
          constants = "NONE",          -- 常量样式
          functions = "italic",        -- 函数样式
          operators = "NONE",          -- 操作符样式
          variables = "NONE",          -- 变量样式
          parameters = "NONE",         -- 参数样式
          conditionals = "italic",     -- 条件语句样式
          virtual_text = "NONE",       -- 虚拟文本样式
        },
        
        -- 文件类型支持 (新增更多文件类型)
        filetypes = {
          c = true,
          comment = true,             -- 新增
          go = true,                  -- 新增
          html = true,                -- 新增
          java = true,
          javascript = true,
          json = true,                -- 新增
          latex = true,               -- 新增
          lua = true,
          markdown = true,
          php = true,
          python = true,
          ruby = true,
          rust = true,
          scss = true,                -- 新增
          toml = true,                -- 新增
          typescript = true,
          typescriptreact = true,     -- 新增
          vue = true,
          xml = true,                 -- 新增
          yaml = true,
        },
        
        -- 插件支持 (新增更多插件)
        plugins = {
          aerial = true,
          barbar = true,
          blink_cmp = true,           -- 新增：新的补全插件
          codecompanion = true,       -- 新增：AI 代码助手
          copilot = true,
          dashboard = true,
          flash_nvim = true,
          gitgraph_nvim = true,       -- 新增：Git 图形化
          gitsigns = true,
          hop = true,
          indentline = true,
          leap = true,
          lsp_saga = true,
          lsp_semantic_tokens = true, -- 新增：LSP 语义令牌支持
          marks = true,
          mini_diff = true,           -- 新增：Mini.nvim diff
          mini_icons = true,          -- 新增：Mini.nvim 图标
          mini_indentscope = true,
          mini_test = true,           -- 新增：Mini.nvim 测试
          neotest = true,
          neo_tree = true,
          
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
          persisted = true,           -- 新增：会话持久化
          polygot = true,
          rainbow_delimiters = true,
          render_markdown = true,     -- 新增：Markdown 渲染
          startify = true,
          telescope = true,
          toggleterm = true,
          treesitter = true,
          trouble = true,
          vim_ultest = true,
          vim_dadbod_ui = true,       -- 新增：数据库 UI
          which_key = true,
        },
        
        -- 选项配置
        options = {
          cursorline = false,                    -- 光标行高亮
          transparency = false,                  -- 透明背景
          terminal_colors = true,                -- 终端颜色
          lualine_transparency = false,          -- Lualine 透明度
          highlight_inactive_windows = false,    -- 非活动窗口高亮
        }
      })
      
      -- 添加主题切换命令
      vim.api.nvim_create_user_command("OneDarkProTheme", function(opts)
        local theme = opts.args
        if theme == "" then
          theme = "onedark"
        end
        
        local valid_themes = {
          "onedark",
          "onelight", 
          "onedark_vivid",
          "onedark_dark",
          "vaporwave"
        }
        
        local is_valid = false
        for _, valid_theme in ipairs(valid_themes) do
          if theme == valid_theme then
            is_valid = true
            break
          end
        end
        
        if is_valid then
          vim.cmd.colorscheme(theme)
          vim.notify("Switched to " .. theme, vim.log.levels.INFO)
        else
          vim.notify("Invalid theme. Available: " .. table.concat(valid_themes, ", "), vim.log.levels.ERROR)
        end
      end, {
        nargs = "?",
        complete = function()
          return {"onedark", "onelight", "onedark_vivid", "onedark_dark", "vaporwave"}
        end,
        desc = "Switch OneDarkPro theme variant"
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
          -- OneDarkPro 主题变体
          "onedark",
          "onelight",
          "onedark_vivid",
          "onedark_dark",
          "vaporwave",
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
      
      -- OneDarkPro 主题变体快捷键
      vim.keymap.set("n", "<leader>To", function()
        pcall(vim.cmd.colorscheme, "onedark")
        vim.notify("Switched to OneDark", vim.log.levels.INFO)
      end, { desc = "切换到 OneDark 主题" })
      
      vim.keymap.set("n", "<leader>Tw", function()
        pcall(vim.cmd.colorscheme, "vaporwave")
        vim.notify("Switched to Vaporwave", vim.log.levels.INFO)
      end, { desc = "切换到 Vaporwave 主题" })
    end,
  },
}
-- endregion