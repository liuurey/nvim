-- 社区推荐插件集合
-- 包含：快速跳转、多光标、AI代码助手等热门插件
-- 从 recommend.lua 重命名而来
-- 社区推荐插件组合（2025年适用）
return { -- 1. 快速跳转：flash.nvim
{
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
        modes = {
            normal = {
                jump_labels = true,
                matchers = {"f", "F", "t", "T"}
            },
            visual = {
                jump_labels = true,
                highlight = {
                    backdrop = true
                }
            }
        },
        label = {
            uppercase = false,
            chars = {"f", "j", "d", "k", "s", "l", "a", ";"}
        }
    },
    keys = {{
        "s",
        mode = {"n", "x", "o"},
        function()
            require("flash").jump()
        end,
        desc = "Flash: 快速跳转"
    }, {
        "S",
        mode = {"n", "x", "o"},
        function()
            require("flash").treesitter()
        end,
        desc = "Flash: 按语法节点跳转"
    }}
}, -- 3. 多光标：vim-visual-multi
{
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
        vim.g.VM_maps = {
            ["Find Under"] = "<C-d>",
            ["Find Subword Under"] = "<C-d>",
            ["Find Above"] = "<C-u>",
            ["Add Cursor Down"] = "<M-j>",
            ["Add Cursor Up"] = "<M-k>",
            ["Skip Region"] = "q",
            ["Remove Region"] = "Q",
            ["Visual Regex"] = "<M-r>"
        }
        vim.g.VM_leader = "\\"
        vim.g.VM_theme = "iceblue"
        vim.g.VM_highlight_matches = "underline"
    end
}, {
    'greggh/claude-code.nvim',
    config = true
}}
