-- 键位配置测试脚本
-- 用于验证键位映射是否正确加载

-- 键位配置测试脚本
-- 用于验证键位映射是否正确加载和检查冲突修复效果

local function test_keymap_loading()
    print("🔍 开始键位配置测试...")
    
    -- 测试 1: 检查 keybindings.lua 是否能正确加载
    local success_keybindings, err_keybindings = pcall(function()
        return require("config.keybindings")
    end)
    
    if success_keybindings then
        print("✅ keybindings.lua 加载成功")
    else
        print("❌ keybindings.lua 加载失败: " .. tostring(err_keybindings))
    end
    
    -- 测试 2: 检查 keymaps.lua 是否能正确加载
    local success_keymaps, err_keymaps = pcall(function()
        return require("config.keymaps")
    end)
    
    if success_keymaps then
        print("✅ keymaps.lua 加载成功")
    else
        print("❌ keymaps.lua 加载失败: " .. tostring(err_keymaps))
    end
    
    -- 测试 3: 检查关键命令是否已创建
    local commands = {
        "ShowAllKeymaps",
        "ShowLeaderKeymaps", 
        "CheckKeymapConflicts",
        "FixKeyConflicts",
        "VerifyKeyFix"
    }
    
    print("\n🛠️ 检查用户命令:")
    for _, cmd in ipairs(commands) do
        local cmd_exists = vim.api.nvim_get_commands({})[cmd] ~= nil
        if cmd_exists then
            print("✅ " .. cmd .. " 命令已创建")
        else
            print("❌ " .. cmd .. " 命令未找到")
        end
    end
    
    -- 测试 4: 检查一些关键键位是否已映射
    print("\n🎯 检查关键键位映射:")
    local key_tests = {
        {"n", "<leader>lr", "LSP重命名"},
        {"n", "<leader>dd", "诊断列表"},
        {"n", "<leader>?k", "显示所有快捷键"},
        {"n", "<Esc>", "取消搜索高亮"}
    }
    
    for _, test in ipairs(key_tests) do
        local mode, key, desc = test[1], test[2], test[3]
        local keymaps = vim.api.nvim_get_keymap(mode)
        local found = false
        
        for _, keymap in ipairs(keymaps) do
            if keymap.lhs == key then
                found = true
                break
            end
        end
        
        if found then
            print("✅ " .. key .. " (" .. desc .. ") 已映射")
        else
            print("❌ " .. key .. " (" .. desc .. ") 未找到")
        end
    end
    
    -- 测试 5: 检查键位冲突修复情况
    print("\n🔧 键位冲突修复状态:")
    print("   💡 运行 :VerifyKeyFix 查看详细修复状态")
    print("   💡 运行 :checkhealth which-key 验证修复效果")
    
    print("\n🎉 键位配置测试完成!")
    
    return success_keybindings and success_keymaps
end

-- 执行测试
test_keymap_loading()