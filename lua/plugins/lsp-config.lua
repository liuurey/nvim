-- 现代化 LSP 配置文件 (基于最新官方最佳实践)
-- 支持 Neovim 0.10+ 的所有新功能
-- 注意: Go 语言支持已被注释 (gopls, gofumpt, delve 等工具因 GOSUMDB 问题暂时禁用)
-- 如需启用 Go 支持，请参考 docs/go-setup.md 手动安装相关工具

return {
  -- 现代化 LSP 配置
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
              [vim.diagnostic.severity.ERROR] = " ",
              [vim.diagnostic.severity.WARN] = " ",
              [vim.diagnostic.severity.HINT] = " ",
              [vim.diagnostic.severity.INFO] = " ",
            },
          },
          float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
            max_width = 80,
            max_height = 20,
          },
        },
        
        -- 内联提示配置 (Neovim 0.10+)
        inlay_hints = {
          enabled = true,
          exclude = { "vue" },
        },
        
        -- Codelens 配置
        codelens = {
          enabled = true,
        },
        
        -- 文档高亮配置
        document_highlight = {
          enabled = true,
        },
        
        
        -- 服务器配置映射 (保留所有原有功能并增强)
        servers = {
          -- Lua LSP 增强配置
          lua_ls = {
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { 
                  globals = { "vim" },
                  disable = { "missing-fields" },
                },
                workspace = {
                  checkThirdParty = false,
                  library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = { enable = false },
                completion = {
                  callSnippet = "Replace",
                },
                hint = {
                  enable = true,
                  arrayIndex = "Auto",
                  await = true,
                  paramName = "All",
                  paramType = true,
                  semicolon = "All",
                },
              },
            },
          },
          
          -- Python LSP 增强配置
          pyright = {
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "basic",
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  autoImportCompletions = true,
                  diagnosticMode = "workspace",
                },
              },
            },
          },
          
          -- 保留所有原有服务器
          -- ruff = {},  -- 已移除，Python 快速检查工具
          ts_ls = {
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                },
              },
            },
          },
          rust_analyzer = {
            settings = {
              ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                inlayHints = {
                  chainingHints = { enable = true },
                  parameterHints = { enable = true },
                  typeHints = { enable = true },
                },
              },
            },
          },
          clangd = {
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--header-insertion=iwyu",
              "--completion-style=detailed",
              "--function-arg-placeholders=true",  -- 修复：添加缺失的值
            },
            capabilities = {
              offsetEncoding = { "utf-16" },
            },
          },
          jdtls = {},
          html = {},
          cssls = {},
          bashls = {},
          jsonls = {
            on_new_config = function(new_config)
              new_config.settings.json.schemas = new_config.settings.json.schemas or {}
              vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
            end,
            settings = {
              json = {
                format = { enable = true },
                validate = { enable = true },
              },
            },
          },
          yamlls = {
            on_new_config = function(new_config)
              new_config.settings.yaml.schemas = vim.tbl_deep_extend(
                "force",
                new_config.settings.yaml.schemas or {},
                require("schemastore").yaml.schemas()
              )
            end,
            settings = {
              yaml = {
                keyOrdering = false,
                format = { enable = true },
                validate = true,
                schemaStore = { enable = false, url = "" },
              },
            },
          },
          dockerls = {},
          marksman = {},
          sqlls = {},
          eslint = {
            settings = {
              workingDirectories = { mode = "auto" },
            },
          },
        },
        
        -- 服务器设置函数
        setup = {},
      }
    end,
    config = function(_, opts)
      -- 设置诊断符号
      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
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
        
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymap_opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, keymap_opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, keymap_opts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, keymap_opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, keymap_opts)
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, keymap_opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, keymap_opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, keymap_opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, keymap_opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, keymap_opts)
        
        -- 启用文档高亮和内联提示 (如果支持的话)
        if opts.document_highlight and opts.document_highlight.enabled then
          if client.supports_method("textDocument/documentHighlight") then
            vim.api.nvim_create_augroup("lsp_document_highlight", { clear = false })
            vim.api.nvim_clear_autocmds({ buffer = bufnr, group = "lsp_document_highlight" })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = "lsp_document_highlight",
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              group = "lsp_document_highlight",
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end
        
        if opts.inlay_hints and opts.inlay_hints.enabled and vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      -- 获取默认 capabilities (使用 Neovim 内置)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      
      -- 如果使用 blink.cmp，可以在这里添加其 capabilities
      if pcall(require, "blink.cmp") then
        capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
      end

      -- 使用新的 vim.lsp.config API 配置所有 LSP 服务器
      for server, config in pairs(opts.servers) do
        local server_config = vim.tbl_deep_extend("force", {
          on_attach = on_attach,
          capabilities = capabilities,
        }, config)
        
        vim.lsp.config(server, server_config)
      end
    end,
  },
}