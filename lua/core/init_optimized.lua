-- 优化配置初始化文件
-- 在您的 init.lua 中引用此文件来应用所有优化

local M = {}

function M.setup()
    -- 1. 首先设置基础配置，避免后续冲突
    M.setup_basic_options()
    
    -- 2. 解决插件冲突（优先级最高）
    local plugin_conflicts = require("config.plugin_conflicts")
    plugin_conflicts.setup()
    plugin_conflicts.fix_wakatime()
    plugin_conflicts.cleanup_autocmds()
    plugin_conflicts.optimize_blink_cmp()
    
    -- 3. 加载优化的键位映射（在插件冲突解决后）
    vim.defer_fn(function()
        require("config.keymaps")  -- 使用当前的 keymaps.lua
    end, 200)
    
    -- 4. 设置剪贴板和其他系统集成
    M.setup_system_integration()
    
    -- 5. 创建有用的命令
    M.create_user_commands()
    
    -- 6. 设置自动命令
    M.setup_autocmds()
    
    -- 7. 最后的优化设置
    M.final_optimizations()
    
    vim.notify("✅ 优化配置已加载完成", vim.log.levels.INFO)
end

-- 基础选项设置
function M.setup_basic_options()
    -- 提高响应速度
    vim.opt.updatetime = 250
    vim.opt.timeoutlen = 300
    
    -- 更好的搜索体验
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.hlsearch = true
    vim.opt.incsearch = true
    
    -- 更好的编辑体验
    vim.opt.scrolloff = 8
    vim.opt.sidescrolloff = 8
    vim.opt.wrap = false
    vim.opt.linebreak = true
    
    -- 自动保存设置
    vim.opt.autowrite = true
    vim.opt.autowriteall = true
    
    -- 禁用一些可能导致问题的功能
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    
    -- 防止菜单错误
    vim.opt.wildmenu = false
    vim.opt.wildmode = ""
end

-- 系统集成设置
function M.setup_system_integration()
    -- 设置剪贴板
    if vim.fn.has('wsl') == 1 then
        vim.g.clipboard = {
            name = 'WslClipboard',
            copy = {
                ['+'] = 'clip.exe',
                ['*'] = 'clip.exe',
            },
            paste = {
                ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            },
            cache_enabled = 0,
        }
    else
        vim.opt.clipboard = "unnamedplus"
    end
    
    -- Windows 特定优化
    if vim.fn.has('win32') == 1 then
        vim.opt.shell = 'powershell'
        vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
        vim.opt.shellquote = ''
        vim.opt.shellxquote = ''
    end
end

-- 创建用户命令
function M.create_user_commands()
    vim.api.nvim_create_user_command('ReloadConfig', function()
        vim.cmd('source $MYVIMRC')
        vim.notify('配置已重新加载', vim.log.levels.INFO)
    end, { desc = '重新加载配置' })
    
    vim.api.nvim_create_user_command('CleanPlugins', function()
        vim.cmd('Lazy clean')
        vim.notify('插件清理完成', vim.log.levels.INFO)
    end, { desc = '清理未使用的插件' })
    
    vim.api.nvim_create_user_command('HealthCheck', function()
        vim.cmd('checkhealth')
    end, { desc = '运行健康检查' })
    
    vim.api.nvim_create_user_command('FixConflicts', function()
        require("config.plugin_conflicts").resolve_conflicts()
        vim.notify('插件冲突已修复', vim.log.levels.INFO)
    end, { desc = '修复插件冲突' })
    
    vim.api.nvim_create_user_command('ShowMappings', function()
        -- 显示所有模式的键位映射
        print("=== 插入模式键位映射 ===")
        vim.cmd('imap')
        print("\n=== 普通模式键位映射 ===")
        vim.cmd('nmap')
        print("\n=== 可视模式键位映射 ===")
        vim.cmd('vmap')
    end, { desc = '显示键位映射' })
end

-- 设置自动命令
function M.setup_autocmds()
    local augroup = vim.api.nvim_create_augroup('OptimizedConfig', { clear = true })
    
    -- 文本文件特殊设置
    vim.api.nvim_create_autocmd('BufEnter', {
        group = augroup,
        pattern = { '*.txt', '*.md', '*.markdown' },
        callback = function()
            vim.opt_local.wrap = true
            vim.opt_local.linebreak = true
        end,
    })
    
    -- 记住光标位置
    vim.api.nvim_create_autocmd('BufReadPost', {
        group = augroup,
        callback = function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            local lcount = vim.api.nvim_buf_line_count(0)
            if mark[1] > 0 and mark[1] <= lcount then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end,
    })
    
    -- 高亮复制的文本
    vim.api.nvim_create_autocmd('TextYankPost', {
        group = augroup,
        callback = function()
            vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
        end,
    })
    
    -- 自动清理错误状态
    vim.api.nvim_create_autocmd('VimEnter', {
        group = augroup,
        callback = function()
            vim.defer_fn(function()
                vim.cmd('silent! redraw')
                vim.cmd('silent! messages clear')
            end, 1000)
        end,
    })
    
    -- 插入模式行号切换
    vim.api.nvim_create_autocmd('InsertEnter', {
        group = augroup,
        callback = function()
            vim.opt.relativenumber = false
        end,
    })
    
    vim.api.nvim_create_autocmd('InsertLeave', {
        group = augroup,
        callback = function()
            vim.opt.relativenumber = true
        end,
    })
end

-- 最终优化
function M.final_optimizations()
    -- 延迟执行一些可能冲突的设置
    vim.defer_fn(function()
        -- 确保所有插件都已加载后再进行最终优化
        pcall(function()
            -- 清理可能的错误状态
            vim.cmd('silent! redraw')
            
            -- 确保关键键位映射正确
            local key_mappings = {
                { mode = "i", key = "<C-s>", cmd = "<Cmd>w<CR>", desc = "保存文件" },
                { mode = "n", key = "<C-s>", cmd = "<Cmd>w<CR>", desc = "保存文件" },
                { mode = "n", key = "<C-z>", cmd = "u", desc = "撤销" },
                { mode = "n", key = "<C-y>", cmd = "<C-r>", desc = "重做" },
            }
            
            for _, mapping in ipairs(key_mappings) do
                vim.keymap.set(mapping.mode, mapping.key, mapping.cmd, { 
                    desc = mapping.desc, 
                    silent = true, 
                    noremap = true 
                })
            end
        end)
    end, 500)
end

return M
