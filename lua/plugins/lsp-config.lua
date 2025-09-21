-- LSP 统一配置文件 (Termux 优化版本)
-- 基于 Neovim 0.11+ 和 nvim-lspconfig 2024 最新标准
-- 职责：统一管理所有 LSP 服务器配置，避免重复和冲突
-- 参考：https://github.com/neovim/nvim-lspconfig#quickstart

-- Termux 工具检测
local function get_termux_tool_path(tool_name, fallback_cmd)
  -- 优先使用 Mason 安装的工具
  local mason_path = vim.fn.stdpath("data") .. "/mason/bin/" .. tool_name
  if vim.fn.executable(mason_path) == 1 then
    return mason_path
  end
  
  -- 回退到系统 PATH 中的工具
  if vim.fn.executable(tool_name) == 1 then
    return tool_name
  end
  
  -- 使用提供的备用命令
  return fallback_cmd or tool_name
end

return {
  -- nvim-lspconfig：提供预配置的 LSP 服务器配置
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      {
        "folke/neoconf.nvim", 
        cmd = "Neoconf", 
        config = false,
      },
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv", "vim%.loop" } },
            { path = "LazyVim", words = { "LazyVim" } },
            { path = "lazy.nvim", words = { "Lazy" } },
          },
        },
      },
      -- 可选：JSON/YAML schema 支持
      {
        "b0o/schemastore.nvim",
        lazy = true,
      },
    },
    
    opts = function()
      return {
        -- 诊断配置 (现代化版本)
        diagnostics = {
          underline = true,
          update_in_insert = false, -- 推荐：减少干扰
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          },
          severity_sort = true, -- 按严重程度排序
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = "E",
              [vim.diagnostic.severity.WARN] = "W",
              [vim.diagnostic.severity.HINT] = "H",
              [vim.diagnostic.severity.INFO] = "I",
            },
          },
          float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
            max_width = 60,  -- 减小宽度以适应移动屏幕
            max_height = 15, -- 减小高度以适应移动屏幕
          },
        },
        
        -- 内联提示配置 (Neovim 0.10+)
        inlay_hints = {
          enabled = false,  -- 默认禁用以提高性能
          exclude = { "vue" },
        },
        
        -- Codelens 配置
        codelens = {
          enabled = false,  -- 默认禁用以提高性能
        },
        
        -- 文档高亮配置
        document_highlight = {
          enabled = true,
        },
        
        -- 不预定义任何服务器配置，让 LSP 按需启用
        servers = {},
        
        -- 服务器设置函数
        setup = {},
      }
    end,
    config = function(_, opts)
      -- 设置诊断符号
      local signs = {
        { name = "DiagnosticSignError", text = "E" },
        { name = "DiagnosticSignWarn", text = "W" },
        { name = "DiagnosticSignHint", text = "H" },
        { name = "DiagnosticSignInfo", text = "I" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      -- 配置诊断
      vim.diagnostic.config(opts.diagnostics or {
        virtual_text = {
          prefix = "●",
        },
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })

      -- LSP 处理器配置
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })

      -- 设置 LSP 快捷键
      local function on_attach(client, bufnr)
        local keymap_opts = { noremap = true, silent = true, buffer = bufnr }
        
        -- 核心导航快捷键
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Goto Declaration" }))
        vim.keymap.set("n", "gd", function()
          -- 优先使用 snacks.picker，回退到内置
          if pcall(require, "snacks") then
            require('snacks').picker.lsp_definitions()
          else
            vim.lsp.buf.definition()
          end
        end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Goto Definition" }))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Hover Documentation" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Goto Implementation" }))
        vim.keymap.set("n", "C-k", vim.lsp.buf.signature_help, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Signature Help" }))
        
        -- 编辑操作
        vim.keymap.set("n", "leaderD", vim.lsp.buf.type_definition, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Type Definition" }))
        vim.keymap.set("n", "leaderrn", vim.lsp.buf.rename, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Rename" }))
        vim.keymap.set("n", "leaderca", vim.lsp.buf.code_action, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Code Action" }))
        
        -- 引用和格式化
        vim.keymap.set("n", "gr", function()
          if pcall(require, "snacks") then
            require('snacks').picker.lsp_references()
          else
            vim.lsp.buf.references()
          end
        end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: References" }))
        vim.keymap.set("n", "leaderF", function()
          vim.lsp.buf.format({ async = true })
        end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Format" }))
        
        -- 诊断快捷键
        vim.keymap.set("n", "leaderld", function()
          vim.diagnostic.open_float({ source = true })
        end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Open Diagnostic" }))
        vim.keymap.set("n", "leadertd", function()
          local current_config = vim.diagnostic.config()
          if current_config.virtual_text then
            vim.diagnostic.config({ virtual_text = false, signs = false, underline = false })
            vim.notify("Diagnostics disabled", vim.log.levels.INFO)
          else
            vim.diagnostic.config({ virtual_text = true, signs = true, underline = true })
            vim.notify("Diagnostics enabled", vim.log.levels.INFO)
          end
        end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Toggle Diagnostics" }))
        
        -- 启用文档高亮
        if opts.document_highlight and opts.document_highlight.enabled then
          if client.supports_method("textDocument/documentHighlight") then
            local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = group,
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              group = group,
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end
        
        -- 内联提示切换
        if opts.inlay_hints and opts.inlay_hints.enabled and vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          vim.keymap.set("n", "leaderth", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
          end, vim.tbl_extend("force", keymap_opts, { desc = "LSP: Toggle Inlay Hints" }))
        end
      end

      -- 获取默认 capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      
      -- 如果使用 blink.cmp，添加其 capabilities
      if pcall(require, "blink.cmp") then
        capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
      end
      
      -- 添加折叠支持
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- 使用新的 vim.lsp.config API 配置所有 LSP 服务器 (Neovim 0.11+)
      -- 不预定义任何服务器，让 LSP 按需启用
      for server, config in pairs(opts.servers) do
        local server_config = vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = capabilities,
        }, config)
        
        -- 定义 LSP 配置
        vim.lsp.config(server, server_config)
        
        -- 启用 LSP 配置 (Neovim 0.11+ 必须显式启用)
        vim.lsp.enable(server)
      end
    end,
  },
}