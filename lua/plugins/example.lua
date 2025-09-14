return { 
-- 完整的 Mason 包管理配置
{
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",  -- LSP 安装集成
        "mfussenegger/nvim-dap",              -- DAP 调试器核心
        "jay-babu/mason-nvim-dap.nvim",       -- DAP 调试器集成
        "jose-elias-alvarez/null-ls.nvim",    -- 代码格式化和诊断集成
    },
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
    build = ":MasonUpdate",  -- 确保 Mason 更新到最新版本
    keys = {
        { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason 包管理器" },
    },
    opts = {
        ensure_installed = {
            -- 格式化工具
            "stylua",           -- Lua 格式化
            "shfmt",            -- Shell 格式化
            "prettier",         -- Web 前端格式化
            "black",            -- Python 格式化
            "ruff",             -- Python 快速格式化和诊断
            "isort",            -- Python 导入排序
            "beautysh",         -- Bash 美化
            "clang-format",     -- C/C++/Java 格式化
            "gofumpt",          -- Go 增强格式化
            "rustfmt",          -- Rust 格式化
            
            -- LSP 服务器
            "lua-language-server",          -- Lua
            "pyright",                      -- Python 类型检查
            "ruff-lsp",                     -- Python 快速 LSP
            "typescript-language-server",   -- TypeScript/JavaScript
            "gopls",                        -- Go
            "rust-analyzer",                -- Rust
            "clangd",                       -- C/C++
            "jdtls",                        -- Java
            "html-lsp",                     -- HTML
            "css-lsp",                      -- CSS
            "bash-language-server",         -- Bash
            "json-lsp",                     -- JSON
            "yaml-language-server",         -- YAML
            "dockerfile-language-server",   -- Dockerfile
            "marksman",                     -- Markdown
            "sqlls",                        -- SQL
            
            -- DAP 调试器
            "debugpy",          -- Python 调试
            "codelldb",         -- C/C++/Rust 调试
            "delve",            -- Go 调试
            "js-debug-adapter", -- JavaScript/TypeScript 调试
            
            -- Linter 和诊断工具
            "eslint-lsp",                   -- JavaScript/TypeScript 代码检查
            "golangci-lint-langserver",     -- Go 代码检查
            "shellcheck",                   -- Shell 脚本检查
            "flake8",                       -- Python 代码检查
            "hadolint",                     -- Dockerfile 检查
            "vale",                         -- 文档和 Markdown 检查
            "markdownlint",                 -- Markdown 检查
            "jsonlint",                     -- JSON 检查
            "yamllint",                     -- YAML 检查
        },
        max_concurrent_installers = 8,  -- 并行安装加速
        ui = {
            check_outdated_packages_on_open = true,  -- 打开时检查过期包
            border = "rounded",
            width = 0.8,
            height = 0.8,
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            },
            keymaps = {
                toggle_package_expand = "<CR>",  -- 展开包详情
                install_package = "i",           -- 安装包
                update_package = "u",            -- 更新包
                check_package_version = "c",     -- 检查版本
                update_all_packages = "U",       -- 更新所有包
                check_outdated_packages = "C",   -- 检查过期包
                uninstall_package = "X",         -- 卸载包
                cancel_installation = "<C-c>",   -- 取消安装
                apply_language_filter = "<C-f>", -- 语言过滤
                toggle_package_install_log = "<C-l>", -- 显示安装日志
            },
        },
        -- 安装路径配置
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
        -- 自定义包安装程序
        registries = {
            "github:mason-org/mason-registry",  -- 默认注册表
        },
        -- 代理设置 (如果需要)
        -- http_proxy = "http://proxy.example.com:8080",
        -- https_proxy = "http://proxy.example.com:8080",
        -- no_proxy = "localhost,127.0.0.1",
        
        -- 日志级别
        log_level = vim.log.levels.INFO,
    },
    config = function(_, opts)
        require("mason").setup(opts)
        
        -- 配置 mason-lspconfig
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",          -- lua-language-server
                "pyright",         -- pyright
                "ruff_lsp",        -- ruff-lsp
                "tsserver",        -- typescript-language-server
                "gopls",           -- gopls
                "rust_analyzer",   -- rust-analyzer
                "clangd",          -- clangd
                "jdtls",           -- jdtls
                "html",            -- html-lsp
                "cssls",           -- css-lsp
                "bashls",          -- bash-language-server
                "jsonls",          -- json-lsp
                "yamlls",          -- yaml-language-server
                "dockerls",        -- dockerfile-language-server
                "marksman",        -- marksman
                "sqlls",           -- sqlls
                "eslint",          -- eslint-lsp
                "golangci_lint_ls", -- golangci-lint-langserver
            },
            automatic_installation = true,
        })
        
        -- 配置 mason-nvim-dap
        require("mason-nvim-dap").setup({
            ensure_installed = {
                "debugpy",          -- Python 调试
                "codelldb",         -- C/C++/Rust 调试
                "delve",            -- Go 调试
                "js-debug-adapter", -- JavaScript/TypeScript 调试
            },
            automatic_installation = true,
            handlers = {},
        })
        
        -- 自动安装配置
        local mr = require("mason-registry")
        local function ensure_installed()
            for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)
                if not p:is_installed() then
                    p:install()
                end
            end
        end
        
        -- 如果 Mason 已经准备好，立即安装
        if mr.refresh then
            mr.refresh(ensure_installed)
        else
            ensure_installed()
        end
    end,
},

    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        {
            "williamboman/mason.nvim",
            cmd = "Mason",
            build = ":MasonUpdate",
        },
        {
            "williamboman/mason-lspconfig.nvim",
            event = { "BufReadPre", "BufNewFile" },
        },
        {
            "folke/neoconf.nvim", 
            cmd = "Neoconf", 
            config = false,
        },
        {
            "folke/neodev.nvim", 
            opts = {},
        },
    },
    opts = {
        autoformat = false, -- 由 conform 接管
        servers = {
            html = {},
            cssls = {},
            tsserver = {},
            pyright = {},
            rust_analyzer = {},
            gopls = {},
            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {"vim"}
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = vim.api.nvim_get_runtime_file("", true)
                        },
                        telemetry = {
                            enable = false
                        }
                    }
                }
            }
        }
    },
    config = function(_, opts)
        require("mason").setup()
        require("mason-lspconfig").setup()
        for server, s_opts in pairs(opts.servers) do
            require("lspconfig")[server].setup(s_opts)
        end
    end
}