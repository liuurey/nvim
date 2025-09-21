-- TreeSitter 配置 (Termux 优化版本)
-- 提供语法高亮、代码折叠、增量选择等功能

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = {
    "TSInstall",
    "TSInstallInfo", 
    "TSUpdate",
    "TSBufEnable",
    "TSBufDisable",
    "TSModuleInfo"
  },
  dependencies = {
    -- 额外的 TreeSitter 模块
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  
  ---@type TSConfig
  opts = {
    -- 不确保安装任何语言解析器，让 TreeSitter 按需安装
    ensure_installed = {},
    
    -- 启用自动安装缺失的解析器
    auto_install = true,
    
    -- 启用语法高亮
    highlight = {
      enable = true,
      -- 对于大文件禁用以提升性能
      disable = function(lang, buf)
        -- 大文件性能优化 (更严格的限制)
        local max_filesize = 50 * 1024 -- 50 KB (比之前更严格)
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
        -- LaTeX文件禁用（避免权限问题）
        if lang == "latex" then
          return true
        end
      end,
      -- 使用 Vim 的正则表达式引擎作为后备
      additional_vim_regex_highlighting = false,
    },
    
    -- 启用增量选择
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "C-space",
        node_incremental = "C-space",
        scope_incremental = false,
        node_decremental = "bs",
      },
    },
    
    -- 启用基于 TreeSitter 的缩进
    indent = {
      enable = false,  -- 默认禁用以提高性能
      -- 某些语言的缩进可能有问题，可以在这里禁用
      disable = { "python", "yaml" },
    },
    
    -- 文本对象配置
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
        },
        goto_next_end = {
        },
        goto_previous_start = {
        },
        goto_previous_end = {
        },
      },
    },
    
    -- Termux 性能优化配置
    matchup = {
      enable = false,  -- 禁用复杂匹配以提高性能
    },
    playground = {
      enable = false,  -- 禁用游乐场以节省资源
    },
  },
  
  config = function(_, opts)
    -- 加载 treesitter 配置
    require("nvim-treesitter").setup(opts)
    
    -- 手动注册TSInstallInfo命令
    vim.api.nvim_create_user_command('TSInstallInfo', function()
      local configs = require('nvim-treesitter.config')
      local parsers = configs.get_installed()
      
      print("已安装的TreeSitter解析器:")
      for _, lang in ipairs(parsers) do
        print(string.format("  %s", lang))
      end
      
      local available = configs.get_available()
      local not_installed = {}
      for _, lang in ipairs(available) do
        if not vim.tbl_contains(parsers, lang) then
          table.insert(not_installed, lang)
        end
      end
      
      if #not_installed > 0 then
        print("\n可安装的解析器:")
        for _, lang in ipairs(not_installed) do
          print(string.format("  %s", lang))
        end
      end
    end, {
      desc = 'Show treesitter parser install info',
    })
    
    -- 添加LaTeX问题修复命令
    vim.api.nvim_create_user_command('TSFixLatex', function()
      require('plugins.treesitter-fix').fix_latex_parser()
    end, {
      desc = 'Fix LaTeX treesitter parser permission issues',
    })
  end,
}