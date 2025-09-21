-- region: 主题插件配置模块 (Termux 优化版本)
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
        compile = true,  -- 启用编译以提高性能
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

  -- Catppuccin 主题 (性能优化版本)
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
        flavour = "mocha",
        background = {
          light = "latte",
          dark = "mocha",
        },
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true,
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
        -- 集成配置 (精简以提高性能)
        integrations = {
          blink_cmp = true,
          gitsigns = true,
          nvimtree = false,  -- 禁用未使用的集成
          telescope = false, -- 禁用未使用的集成
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
    lazy = false,
    priority = 1001,
    config = function()
      vim.g.hardhacker_darker = 1
      vim.g.hardhacker_hide_tilde = 1
      
      local colorscheme_status_ok, _ = pcall(vim.cmd.colorscheme, "hardhacker")
      if not colorscheme_status_ok then
        vim.cmd.colorscheme("default")
      end
    end,
  },

  -- OneDarkPro 主题 (精简版本)
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
        colors = {},
        highlights = {},
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
          comment = true,
          go = false,  -- 禁用未使用的文件类型
          html = true,
          java = true,
          javascript = true,
          json = true,
          latex = false, -- 禁用未使用的文件类型
          lua = true,
          markdown = true,
          php = false,  -- 禁用未使用的文件类型
          python = true,
          ruby = false, -- 禁用未使用的文件类型
          rust = true,
          scss = false, -- 禁用未使用的文件类型
          toml = true,
          typescript = true,
          typescriptreact = false, -- 禁用未使用的文件类型
          vue = false,  -- 禁用未使用的文件类型
          xml = false,  -- 禁用未使用的文件类型
          yaml = true,
        },
        plugins = {
          aerial = false,  -- 禁用未使用的插件
          barbar = false,  -- 禁用未使用的插件
          blink_cmp = true,
          codecompanion = false, -- 禁用未使用的插件
          copilot = true,
          dashboard = false, -- 禁用未使用的插件
          flash_nvim = false, -- 禁用未使用的插件
          gitgraph_nvim = false, -- 禁用未使用的插件
          gitsigns = true,
          hop = false, -- 禁用未使用的插件
          indentline = true,
          leap = false, -- 禁用未使用的插件
          lsp_saga = false, -- 禁用未使用的插件
          lsp_semantic_tokens = true,
          marks = false, -- 禁用未使用的插件
          mini_diff = false, -- 禁用未使用的插件
          mini_icons = false, -- 禁用未使用的插件
          mini_indentscope = true,
          mini_test = false, -- 禁用未使用的插件
          neotest = false, -- 禁用未使用的插件
          neo_tree = false, -- 禁用未使用的插件
          nvim_bqf = false, -- 禁用未使用的插件
          nvim_dap = true,
          nvim_dap_ui = true,
          nvim_hlslens = false, -- 禁用未使用的插件
          nvim_lsp = true,
          nvim_navic = false, -- 禁用未使用的插件
          nvim_notify = true,
          nvim_tree = false, -- 禁用未使用的插件
          nvim_ts_rainbow = false, -- 禁用未使用的插件
          op_nvim = false, -- 禁用未使用的插件
          packer = false, -- 禁用未使用的插件
          persisted = false, -- 禁用未使用的插件
          polygot = false, -- 禁用未使用的插件
          rainbow_delimiters = false, -- 禁用未使用的插件
          render_markdown = false, -- 禁用未使用的插件
          startify = false, -- 禁用未使用的插件
          telescope = false, -- 禁用未使用的插件
          toggleterm = true,
          treesitter = true,
          trouble = false, -- 禁用未使用的插件
          vim_ultest = false, -- 禁用未使用的插件
          vim_dadbod_ui = false, -- 禁用未使用的插件
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
    priority = 500,
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
          "catppuccin-mocha",
          "onedark",
          "vaporwave",
        },
        livePreview = false,  -- 禁用实时预览以提高性能
      })

      vim.keymap.set("n", "leaderTt", "<cmd>Themery<cr>", { desc = "打开主题选择器" })
      
      vim.keymap.set("n", "leaderTh", function()
        pcall(vim.cmd.colorscheme, "hardhacker")
      end, { desc = "切换到 HardHacker 主题" })
      
      vim.keymap.set("n", "leaderTk", function()
        pcall(vim.cmd.colorscheme, "kanagawa-wave")
      end, { desc = "切换到 Kanagawa 主题" })
      
      vim.keymap.set("n", "leaderTc", function()
        pcall(vim.cmd.colorscheme, "catppuccin-mocha")
      end, { desc = "切换到 Catppuccin 主题" })
      
      vim.keymap.set("n", "leaderTo", function()
        pcall(vim.cmd.colorscheme, "onedark")
      end, { desc = "切换到 OneDark 主题" })
      
      vim.keymap.set("n", "leaderTw", function()
        pcall(vim.cmd.colorscheme, "vaporwave")
      end, { desc = "切换到 Vaporwave 主题" })
    end,
  },
}
-- endregion