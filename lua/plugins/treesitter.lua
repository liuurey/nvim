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
    auto_install = true,
    
    -- 启用语法高亮
    highlight = {
      enable = true,
      -- 对于大文件禁用以提升性能
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
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
    -- 安全加载 treesitter - 延迟加载确保插件就绪
    vim.schedule(function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        -- 插件未安装时不显示警告，静默返回
        return
      end
      
      -- 设置 treesitter 配置
      configs.setup(opts)
    end)
    
    -- 创建自动命令来处理 TreeSitter 相关事件
    local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
    
    -- 确保 TreeSitter 命令可用 - 延迟检查（静默模式）
    vim.api.nvim_create_autocmd("VimEnter", {
      group = group,
      callback = function()
        -- 延迟检查以确保插件完全加载
        vim.defer_fn(function()
          -- 检查 TreeSitter 是否可用（静默检查，不显示警告）
          local ts_ok = pcall(require, "nvim-treesitter.configs")
          if ts_ok and vim.fn.exists(':TSInstallInfo') == 0 then
            -- 仅当插件存在但命令未就绪时显示信息提示
            vim.notify("TreeSitter 命令未就绪，请等待插件初始化完成", vim.log.levels.INFO)
          end
        end, 2000)  -- 延迟时间2秒
      end,
    })
    
    -- 在文件类型检测后启用 TreeSitter
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local ft = vim.bo[buf].filetype
        
        -- 对于支持的文件类型，确保 TreeSitter 已启用
        if ft and ft ~= "" then
          vim.defer_fn(function()
            if vim.api.nvim_buf_is_valid(buf) then
              pcall(vim.cmd, "TSBufEnable highlight")
            end
          end, 100)
        end
      end,
    })
    
    -- 提供一个健康检查函数
    vim.api.nvim_create_user_command("TSHealth", function()
      local installed = require("nvim-treesitter.info").installed_parsers()
      local available = require("nvim-treesitter.parsers").available_parsers()
      
      print("=== TreeSitter 健康检查 ===")
      print("已安装的解析器数量: " .. #installed)
      print("可用的解析器数量: " .. #available)
      print("\n已安装的解析器:")
      for _, parser in ipairs(installed) do
        print("  ✓ " .. parser)
      end
      
      -- 检查常用解析器是否已安装
      local required = { "lua", "vim", "vimdoc", "query" }
      print("\n必需解析器检查:")
      for _, parser in ipairs(required) do
        local status = vim.tbl_contains(installed, parser) and "✓" or "✗"
        print("  " .. status .. " " .. parser)
      end
    end, { desc = "检查 TreeSitter 状态" })
    
    -- 更新 textobjects 配置为最新格式
    local textobjects = opts.textobjects
    if textobjects then
      -- 更新 select.keymaps 为新的 table 格式
      if textobjects.select and textobjects.select.keymaps then
        local new_keymaps = {}
        for key, query in pairs(textobjects.select.keymaps) do
          if type(query) == "string" then
            new_keymaps[key] = { query = query, desc = query:gsub("^@", ""):gsub("%.", " ") }
          else
            new_keymaps[key] = query
          end
        end
        textobjects.select.keymaps = new_keymaps
      end
      
      -- 添加交换功能配置 - 按键已注释避免冲突
      textobjects.swap = {
        enable = true,
        swap_next = {
          -- ["<leader>a"] = "@parameter.inner",  -- 已注释避免按键冲突
        },
        swap_previous = {
          -- ["<leader>A"] = "@parameter.inner",  -- 已注释避免按键冲突
        },
      }
      
      -- 更新 move 配置为新的 table 格式
      if textobjects.move then
        for _, section in ipairs({"goto_next_start", "goto_next_end", "goto_previous_start", "goto_previous_end"}) do
          if textobjects.move[section] then
            local new_section = {}
            for key, query in pairs(textobjects.move[section]) do
              if type(query) == "string" then
                new_section[key] = { query = query, desc = query:gsub("^@", ""):gsub("%.", " ") }
              else
                new_section[key] = query
              end
            end
            textobjects.move[section] = new_section
          end
        end
      end
      
      -- 添加LSP交互功能 - 按键已注释避免冲突
      textobjects.lsp_interop = {
        enable = true,
        border = 'rounded',  -- 使用圆角边框
        floating_opts = {},
        peek_definition_code = {
          -- ["<leader>df"] = "@function.outer",  -- 已注释避免按键冲突
          -- ["<leader>dF"] = "@class.outer",   -- 已注释避免按键冲突
        },
      }
    end
  end,
}