return {
-- 代码格式化
---------------------------------------------------------------------------
{
    "stevearc/conform.nvim",
    event = {"BufWritePre"},
    opts = {
        formatters_by_ft = {
            lua = {"stylua"},
            python = {"ruff_format"},  -- 使用 ruff_format 解决用户名空格问题
            javascript = {"prettier"},
            typescript = {"prettier"},
            html = {"prettier"},
            css = {"prettier"}
        },
        -- 移除 format_on_save 配置，由 LazyVim 统一管理
        
        -- 针对用户名包含空格的修复（使用 PowerShell 包装）
        formatters = {
            ruff_format = {
                -- 使用 PowerShell 包装命令，解决空格问题
                command = "powershell.exe",
                args = {
                    "-NoProfile",
                    "-Command",
                    "& \"$env:LOCALAPPDATA\\nvim-data\\mason\\bin\\ruff.CMD\" format --stdin-filename '$env:FILENAME' -"
                },
                stdin = true,
                env = {
                    FILENAME = "$FILENAME",
                },
            },
            black = {
                -- 如果需要使用 black，使用 PowerShell 包装
                command = "powershell.exe",
                args = {
                    "-NoProfile",
                    "-Command",
                    "& \"$env:LOCALAPPDATA\\nvim-data\\mason\\bin\\black.CMD\" --stdin-filename '$env:FILENAME' -"
                },
                stdin = true,
                env = {
                    FILENAME = "$FILENAME",
                },
            },
        },
    }
}, ---------------------------------------------------------------------------
-- 语法高亮 & 缩进
---------------------------------------------------------------------------
{
    "nvim-treesitter/nvim-treesitter",
    event = {"BufReadPost", "BufNewFile"},
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
        ensure_installed = {"bash", "c", "go", "html", "javascript", "json", "lua", "markdown", "markdown_inline",
                            "python", "rust", "typescript", "vimdoc", "vue"},
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = false,
                node_decremental = "<bs>",
            },
        },
    },
    main = "nvim-treesitter.configs",
    -- 现代 nvim-treesitter 配置方式：使用 main 指定模块
}, ---------------------------------------------------------------------------
-- 补全引擎
---------------------------------------------------------------------------
--  {
--     "hrsh7th/nvim-cmp",
--     event = "InsertEnter",
--     dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-emoji",
--                     "hrsh7th/cmp-cmdline", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip"},
--     opts = function()
--         local cmp = require("cmp")
--         return {
--             snippet = {
--                 expand = function(args)
--                     require("luasnip").lsp_expand(args.body)
--                 end
--             },
--             sources = cmp.config.sources({{
--                 name = "nvim_lsp"
--             }, {
--                 name = "luasnip"
--             }, {
--                 name = "emoji"
--             }}, {{
--                 name = "buffer"
--             }, {
--                 name = "path"
--             }}),
--             mapping = cmp.mapping.preset.insert({})
--         }
--     end,
--     config = function(_, opts)
--         local cmp = require("cmp")
--         cmp.setup(opts)
--         cmp.setup.cmdline("/", {
--             mapping = cmp.mapping.preset.cmdline(),
--             sources = {{
--                 name = "buffer"
--             }}
--         })
--         cmp.setup.cmdline(":", {
--             mapping = cmp.mapping.preset.cmdline(),
--             sources = cmp.config.sources({{
--                 name = "path"
--             }}, {{
--                 name = "cmdline"
--             }})
--         })
--     end
--  }, ---------------------------------------------------------------------------
-- 文件浏览器
---------------------------------------------------------------------------
{
    "nvim-tree/nvim-tree.lua",
    cmd = {"NvimTreeToggle", "NvimTreeFindFile"},
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {{
        "<leader>e",
        "<cmd>NvimTreeToggle<cr>",
        desc = "Explorer"
    }},
    opts = {
        filters = {
            dotfiles = false
        },
        view = {
            side = "left",
            width = 30
        },
        actions = {
            open_file = {
                resize_window = true
            }
        }
    }
}, ---------------------------------------------------------------------------
-- 模糊查找
---------------------------------------------------------------------------
{
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {"nvim-lua/plenary.nvim", "nvim-telescope/telescope-project.nvim"},
    keys = {{
        "<leader>ff",
        "<cmd>Telescope find_files<cr>",
        desc = "Find Files"
    }, {
        "<leader>fg",
        "<cmd>Telescope live_grep<cr>",
        desc = "Live Grep"
    }, {
        "<leader>fb",
        "<cmd>Telescope buffers<cr>",
        desc = "Buffers"
    }, {
        "<leader>fh",
        "<cmd>Telescope help_tags<cr>",
        desc = "Help Tags"
    }, {
        "<leader>fp",
        "<cmd>Telescope project<cr>",
        desc = "Project"
    }},
    opts = {
        extensions = {
            project = {
                base_dirs = {"~/projects", "~/work"},
                hidden_files = true
            }
        }
    },
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("project")
    end
}, ---------------------------------------------------------------------------
-- 终端
---------------------------------------------------------------------------
{
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {{
        "<C-\\>",
        "<cmd>ToggleTerm<cr>",
        desc = "Terminal"
    }},
    opts = {
        open_mapping = [[<c-\>]],
        direction = "float",
        float_opts = {
            border = "curved"
        }
    }
}, ---------------------------------------------------------------------------
-- 注释
---------------------------------------------------------------------------
{
    "numToStr/Comment.nvim",
    keys = {{
        "gcc",
        mode = "n",
        desc = "Line Comment"
    }, {
        "gc",
        mode = "v",
        desc = "Comment Selection"
    }, {
        "gbc",
        mode = "n",
        desc = "Block Comment Line"
    }, {
        "gb",
        mode = "v",
        desc = "Block Comment Selection"
    }},
    opts = {
        mappings = {
            basic = true,
            extra = false
        }
    },
    config = function(_, opts)
        require("Comment").setup(opts)
        -- 将 gbc 映射到 g<C-b> 避免与 gb 冲突
        vim.keymap.set("n", "g<C-b>", function()
            require("Comment.api").toggle.blockwise.current()
        end, {
            desc = "Toggle Block Comment"
        })
    end
}, ---------------------------------------------------------------------------
-- 自动括号
---------------------------------------------------------------------------
{
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
        check_ts = true,
        ts_config = {
            lua = {"string", "source"},
            javascript = {"string", "template_string"}
        },
        disable_filetype = {"TelescopePrompt", "spectre_panel"},
        fast_wrap = {
            map = "<M-e>",
            chars = {"{", "[", "(", '"', "'"},
            pattern = [[ [%'%"%)%>%]%)%}%,] ]],
            offset = 0,
            end_key = "$",
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            check_comma = true,
            highlight = "PmenuSel",
            highlight_grey = "LineNr"
        }
    }
}, ---------------------------------------------------------------------------
-- 项目管理
---------------------------------------------------------------------------
{
    "ahmedkhalf/project.nvim",
    config = function()
        require("project_nvim").setup({
            detection_methods = {"pattern", "lsp"},
            patterns = {".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "go.mod"},
            show_hidden = true
        })
    end
}}
