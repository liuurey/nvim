return {
{
    "mason-org/mason.nvim",
    version = "v2.0.1", -- 锁定最新稳定版本
    dependencies = {
        "mason-org/mason-lspconfig.nvim",     -- LSP 安装集成
        "mfussenegger/nvim-dap",              -- DAP 调试器核心
        "jay-babu/mason-nvim-dap.nvim",       -- DAP 调试器集成
    },
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
    build = ":MasonUpdate",  -- 确保 Mason 更新到最新版本
    keys = {
        { "leadercm", "<cmd>Mason<cr>", desc = "Mason 包管理器" },
    },
    opts = {
        -- 不确保安装任何工具，让 Mason 按需安装
        ensure_installed = {},
        max_concurrent_installers = 4,  -- 减少并行安装数量以适应移动设备
        ui = {
            check_outdated_packages_on_open = true,
            border = "rounded",
            width = 0.8,
            height = 0.8,
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            },
            keymaps = {
                toggle_package_expand = "<CR>",
                install_package = "i",
                update_package = "u",
                check_package_version = "c",
                update_all_packages = "U",
                check_outdated_packages = "C",
                uninstall_package = "X",
                cancel_installation = "<C-c>",
                apply_language_filter = "<C-f>",
                toggle_package_install_log = "<C-l>",
            },
        },
        -- 安装路径配置
        install_root_dir = vim.fn.stdpath("data") .. "/mason",
        -- 注册表
        registries = {
            "github:mason-org/mason-registry",
        },
        -- 日志级别
        log_level = vim.log.levels.WARN,  -- 减少日志输出以提高性能
    },
    config = function(_, opts)
        require("mason").setup(opts)
        
        -- 配置 mason-lspconfig (不自动安装任何 LSP 服务器)
        require("mason-lspconfig").setup({
            ensure_installed = {},
            automatic_installation = false,
            automatic_enable = false,
        })
        
        -- 配置 mason-nvim-dap
        require("mason-nvim-dap").setup({
            automatic_installation = false,
            handlers = {
                function(config)
                    require('mason-nvim-dap').default_setup(config)
                end,
            },
        })
        
        -- 优化的自动安装配置
        local mr = require("mason-registry")
        local function safe_ensure_installed()
            -- 不自动安装任何工具，让用户按需安装
        end
        
        -- 延迟执行安装检查
        vim.defer_fn(function()
            if mr.refresh then
                mr.refresh(safe_ensure_installed)
            else
                safe_ensure_installed()
            end
        end, 1000)
    end,
},
}