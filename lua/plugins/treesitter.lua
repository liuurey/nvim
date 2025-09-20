-- TreeSitter 配置
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
    -- 确保安装的语言解析器
    ensure_installed = {
      "lua",
      "vim", 
      "vimdoc",
      "query",
      "markdown",
      "markdown_inline",
      "bash",
      "python",
      "javascript",
      "typescript",
      "json",
      "yaml",
      "toml",
      "html",
      "css",
      "c",
      "cpp",
      "rust",
      "go",
    },
    
    -- 自动安装缺失的解析器
    auto_install = false,
    
    -- 启用语法高亮
    highlight = {
      enable = true,
      -- 对于大文件禁用以提升性能
      disable = function(lang, buf)
        -- 大文件性能优化
        local max_filesize = 100 * 1024 -- 100 KB
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
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
    
    -- 启用基于 TreeSitter 的缩进
    indent = {
      enable = true,
      -- 某些语言的缩进可能有问题，可以在这里禁用
      disable = { "python", "yaml" },
    },
    
    -- 文本对象配置 - 按键配置已注释，避免重复定义
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- 自动跳转到下一个文本对象
        keymaps = {
          -- 函数相关 - 已注释避免按键冲突
          -- ["af"] = "@function.outer",
          -- ["if"] = "@function.inner",
          -- 类相关 - 已注释避免按键冲突  
          -- ["ac"] = "@class.outer",
          -- ["ic"] = "@class.inner",
          -- 参数相关 - 已注释避免按键冲突
          -- ["aa"] = "@parameter.outer",
          -- ["ia"] = "@parameter.inner",
          -- 条件语句 - 已注释避免按键冲突
          -- ["a?"] = "@conditional.outer",
          -- ["i?"] = "@conditional.inner",
          -- 循环 - 已注释避免按键冲突
          -- ["al"] = "@loop.outer",
          -- ["il"] = "@loop.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- 是否在跳转列表中设置跳转
        goto_next_start = {
          -- 已注释避免按键冲突
          -- ["]f"] = "@function.outer",
          -- ["]c"] = "@class.outer",
        },
        goto_next_end = {
          -- 已注释避免按键冲突
          -- ["]F"] = "@function.outer", 
          -- ["]C"] = "@class.outer",
        },
        goto_previous_start = {
          -- 已注释避免按键冲突
          -- ["[f"] = "@function.outer",
          -- ["[c"] = "@class.outer",
        },
        goto_previous_end = {
          -- 已注释避免按键冲突
          -- ["[F"] = "@function.outer",
          -- ["[C"] = "@class.outer",
        },
      },
    },
  },
  
  config = function(_, opts)
    -- 加载 treesitter 配置 - 官方推荐简洁方式
    require("nvim-treesitter").setup(opts)
    
    -- 手动注册TSInstallInfo命令（新版TreeSitter缺失此命令）
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