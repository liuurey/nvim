-- 优化配置测试脚本
-- 运行此脚本来验证所有优化是否正常工作

local M = {}

-- 测试结果收集
local test_results = {}

-- 添加测试结果
local function add_result(test_name, success, message)
    table.insert(test_results, {
        name = test_name,
        success = success,
        message = message or ""
    })
end

-- 测试插件冲突解决
local function test_plugin_conflicts()
    local success, plugin_conflicts = pcall(require, "config.plugin_conflicts")
    if success then
        add_result("插件冲突模块加载", true, "plugin_conflicts.lua 加载成功")
        
        -- 测试主要函数是否存在
        local functions = {"setup", "fix_wakatime", "cleanup_autocmds", "optimize_blink_cmp"}
        for _, func_name in ipairs(functions) do
            if type(plugin_conflicts[func_name]) == "function" then
                add_result("函数检查: " .. func_name, true, "函数存在且可调用")
            else
                add_result("函数检查: " .. func_name, false, "函数不存在或不可调用")
            end
        end
    else
        add_result("插件冲突模块加载", false, "无法加载 plugin_conflicts.lua: " .. tostring(plugin_conflicts))
    end
end

-- 测试优化配置初始化
local function test_init_optimized()
    local success, init_optimized = pcall(require, "config.init_optimized")
    if success then
        add_result("优化初始化模块加载", true, "init_optimized.lua 加载成功")
        
        if type(init_optimized.setup) == "function" then
            add_result("setup 函数检查", true, "setup 函数存在")
        else
            add_result("setup 函数检查", false, "setup 函数不存在")
        end
    else
        add_result("优化初始化模块加载", false, "无法加载 init_optimized.lua: " .. tostring(init_optimized))
    end
end

-- 测试用户命令
local function test_user_commands()
    local commands = {"ReloadConfig", "CleanPlugins", "HealthCheck", "FixConflicts", "ShowMappings"}
    
    for _, cmd in ipairs(commands) do
        local exists = vim.fn.exists(':' .. cmd) == 2
        if exists then
            add_result("用户命令: " .. cmd, true, "命令已注册")
        else
            add_result("用户命令: " .. cmd, false, "命令未注册")
        end
    end
end

-- 测试关键键位映射
local function test_key_mappings()
    local key_tests = {
        {mode = "n", key = "<C-s>", desc = "普通模式保存"},
        {mode = "i", key = "<C-s>", desc = "插入模式保存"},
        {mode = "n", key = "<C-z>", desc = "撤销"},
        {mode = "n", key = "<C-y>", desc = "重做"},
    }
    
    for _, test in ipairs(key_tests) do
        local mappings = vim.api.nvim_get_keymap(test.mode)
        local found = false
        
        for _, mapping in ipairs(mappings) do
            if mapping.lhs == test.key then
                found = true
                break
            end
        end
        
        add_result("键位映射: " .. test.desc, found, test.key .. " 在 " .. test.mode .. " 模式")
    end
end

-- 测试基础选项设置
local function test_basic_options()
    local options = {
        {name = "updatetime", expected = 250, desc = "更新时间"},
        {name = "timeoutlen", expected = 300, desc = "超时时间"},
        {name = "ignorecase", expected = true, desc = "忽略大小写"},
        {name = "smartcase", expected = true, desc = "智能大小写"},
    }
    
    for _, opt in ipairs(options) do
        local current_value = vim.opt[opt.name]:get()
        local matches = current_value == opt.expected
        
        add_result("选项设置: " .. opt.desc, matches, 
                  string.format("%s = %s (期望: %s)", opt.name, tostring(current_value), tostring(opt.expected)))
    end
end

-- 测试插件状态
local function test_plugin_status()
    -- 检查 lazy.nvim 是否可用
    local lazy_available = pcall(require, "lazy")
    add_result("Lazy.nvim 可用性", lazy_available, "插件管理器状态")
    
    -- 检查关键插件
    local key_plugins = {"blink.cmp", "nvim-autopairs", "mini.pairs"}
    
    for _, plugin in ipairs(key_plugins) do
        local available = pcall(require, plugin)
        add_result("插件检查: " .. plugin, available, "插件加载状态")
    end
end

-- 运行所有测试
function M.run_all_tests()
    print("🧪 开始运行优化配置测试...")
    print("=" .. string.rep("=", 50))
    
    test_results = {} -- 清空之前的结果
    
    -- 运行各项测试
    test_plugin_conflicts()
    test_init_optimized()
    test_user_commands()
    test_key_mappings()
    test_basic_options()
    test_plugin_status()
    
    -- 显示结果
    local passed = 0
    local failed = 0
    
    print("\n📊 测试结果:")
    print("-" .. string.rep("-", 50))
    
    for _, result in ipairs(test_results) do
        local status = result.success and "✅ 通过" or "❌ 失败"
        local message = result.message ~= "" and " - " .. result.message or ""
        
        print(string.format("%s %s%s", status, result.name, message))
        
        if result.success then
            passed = passed + 1
        else
            failed = failed + 1
        end
    end
    
    print("-" .. string.rep("-", 50))
    print(string.format("📈 总计: %d 个测试, %d 通过, %d 失败", 
                       passed + failed, passed, failed))
    
    if failed == 0 then
        print("🎉 所有测试通过! 优化配置工作正常。")
    else
        print("⚠️  有 " .. failed .. " 个测试失败，请检查配置。")
    end
    
    return failed == 0
end

-- 快速检查函数
function M.quick_check()
    print("🔍 快速检查优化配置状态...")
    
    -- 检查关键模块
    local modules = {
        "config.plugin_conflicts",
        "config.init_optimized"
    }
    
    local all_good = true
    
    for _, module in ipairs(modules) do
        local success, _ = pcall(require, module)
        if success then
            print("✅ " .. module .. " - 正常")
        else
            print("❌ " .. module .. " - 加载失败")
            all_good = false
        end
    end
    
    -- 检查用户命令
    local commands = {"ReloadConfig", "FixConflicts", "ShowMappings"}
    for _, cmd in ipairs(commands) do
        if vim.fn.exists(':' .. cmd) == 2 then
            print("✅ :" .. cmd .. " - 可用")
        else
            print("❌ :" .. cmd .. " - 不可用")
            all_good = false
        end
    end
    
    if all_good then
        print("🎉 快速检查通过!")
    else
        print("⚠️  发现问题，建议运行完整测试: :lua require('test_optimizations').run_all_tests()")
    end
    
    return all_good
end

-- 创建用户命令
vim.api.nvim_create_user_command('TestOptimizations', function()
    M.run_all_tests()
end, { desc = '运行优化配置测试' })

vim.api.nvim_create_user_command('QuickCheck', function()
    M.quick_check()
end, { desc = '快速检查优化配置' })

return M