-- 插件冲突解决方案
-- 解决 autopairs、mini.pairs 等插件的键位冲突

local M = {}

-- 禁用冲突的插件功能
function M.setup()
    -- 1. 禁用可能导致菜单错误的功能
    vim.g.autopairs_disable_in_macro = 1
    vim.g.tmux_navigator_no_mappings = 1
    
    -- 2. 延迟执行冲突解决，确保所有插件都已加载
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.defer_fn(function()
                M.resolve_conflicts()
            end, 100)  -- 延迟100ms执行
        end,
    })

    -- 3. 禁用所有菜单映射（解决 Menu not defined 错误）
    pcall(function()
        vim.cmd([[
            silent! aunmenu *
            silent! iunmenu *
            silent! cunmenu *
            silent! vunmenu *
        ]])
    end)
end

-- 解决具体的插件冲突
function M.resolve_conflicts()
    -- 1. 处理 autopairs 和 mini.pairs 冲突
    local has_mini_pairs = pcall(require, "mini.pairs")
    local has_npairs, npairs = pcall(require, "nvim-autopairs")
    
    if has_mini_pairs and has_npairs then
        -- 重新配置 nvim-autopairs，减少冲突
        npairs.setup({
            map_cr = false,  -- 禁用 CR 映射，避免与 blink.cmp 冲突
            map_bs = false,  -- 让 mini.pairs 处理
            map_c_h = false,
            map_c_w = false,
            disable_filetype = { "TelescopePrompt", "vim", "dashboard" },
            disable_in_macro = true,
            disable_in_visualblock = true,
            ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
            enable_moveright = false,
            enable_afterquote = false,
            enable_check_bracket_line = false,
            enable_bracket_in_quote = false,
            break_undo = true,
            check_ts = false,
            map_char = {
                all = false,  -- 完全禁用字符映射
            }
        })
    end

    -- 2. 清理冲突的键位映射
    local conflicting_keys = {
        { mode = "i", key = "<C-h>" },
        { mode = "i", key = "<C-j>" },
        { mode = "i", key = "<C-k>" },
        { mode = "i", key = "<C-l>" },
    }

    for _, mapping in ipairs(conflicting_keys) do
        pcall(vim.keymap.del, mapping.mode, mapping.key)
    end

    -- 3. 重新设置我们需要的映射
    vim.keymap.set("i", "<C-h>", "<Left>", { desc = "左移", silent = true })
    vim.keymap.set("i", "<C-j>", "<Down>", { desc = "下移", silent = true })
    vim.keymap.set("i", "<C-k>", "<Up>", { desc = "上移", silent = true })
    vim.keymap.set("i", "<C-l>", "<Right>", { desc = "右移", silent = true })

    -- 4. 确保 blink.cmp 的键位映射正常工作
    local has_blink, blink = pcall(require, "blink.cmp")
    if has_blink then
        -- 确保 blink.cmp 的 CR 映射优先级最高
        vim.keymap.set("i", "<CR>", function()
            if blink.is_visible() then
                return blink.accept()
            else
                return "<CR>"
            end
        end, { expr = true, silent = true, desc = "Accept completion or newline" })
    end
end

-- 修复 WakaTime API 密钥问题
function M.fix_wakatime()
    local wakatime_cfg = vim.fn.expand("~/.wakatime.cfg")
    if vim.fn.filereadable(wakatime_cfg) == 0 then
        local config_content = [[
[settings]
debug = false
hidefilenames = false
ignore = 
    COMMIT_EDITMSG$
    PULLREQ_EDITMSG$
    MERGE_MSG$
    TAG_EDITMSG$
api_key = your-api-key-here
]]
        vim.fn.writefile(vim.split(config_content, "\n"), wakatime_cfg)
        vim.notify("已创建 WakaTime 配置文件，请在 ~/.wakatime.cfg 中设置您的 API 密钥", vim.log.levels.WARN)
    end
end

-- 清理可能导致问题的自动命令
function M.cleanup_autocmds()
    vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            -- 确保普通文件是可编辑的
            if vim.bo.buftype == "" and vim.bo.filetype ~= "help" and vim.bo.filetype ~= "dashboard" then
                vim.bo.modifiable = true
            end
        end,
    })

    -- 清理可能的错误状态
    vim.api.nvim_create_autocmd("CmdlineEnter", {
        callback = function()
            vim.cmd("silent! redraw")
        end,
    })
end

-- 优化 blink.cmp 配置 - 修复重复配置问题
function M.optimize_blink_cmp()
    vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpReady",
        callback = function()
            -- 只处理键位映射冲突，不重新配置插件
            local has_blink, blink = pcall(require, "blink.cmp")
            if has_blink then
                -- 确保 blink.cmp 键位映射优先级，但不调用 setup
                vim.notify("blink.cmp 已就绪，键位映射已优化", vim.log.levels.INFO)
                
                -- 只处理必要的键位冲突解决
                vim.keymap.set("i", "<CR>", function()
                    if blink.is_visible and blink.is_visible() then
                        return blink.accept()
                    else
                        return "<CR>"
                    end
                end, { expr = true, silent = true, desc = "Accept completion or newline" })
            end
        end,
    })
end

return M
