--[[
文件: lua/config/templates.lua
创建时间: 2025-01-25 00:00:00
描述: Neovim 新文件模板系统
功能: 为不同文件类型提供智能模板生成
--]]

local M = {}

-- 模板配置
M.config = {
    -- 是否启用模板系统
    enabled = true,
    
    -- 默认作者信息
    author = {
        name = "CN",
        email = "chains0521@163.com",
        github = "https://github.com/SantaChains",
    },
    
    -- 时间格式
    time_format = "%Y-%m-%d %H:%M:%S",
    
    -- 是否检查文件内容防止覆盖
    prevent_overwrite = true,
    
    -- 是否自动定位光标到合适位置
    auto_cursor_position = true,
    
    -- 支持的文件类型及其配置
    filetypes = {
        -- 脚本语言
        sh = { enabled = true, shebang = "#!/bin/bash" },
        python = { enabled = true, shebang = "#!/usr/bin/env python3", encoding = "# -*- coding: utf-8 -*-" },
        ruby = { enabled = true, shebang = "#!/usr/bin/env ruby", encoding = "# encoding: utf-8" },
        
        -- Web 开发
        html = { enabled = true, lang = "zh-CN", include_css = true, include_js = true },
        css = { enabled = true, include_variables = true, include_reset = true },
        javascript = { enabled = true, use_strict = true, include_main = true },
        typescript = { enabled = true, include_interfaces = true, include_main = true },
        
        -- 编程语言
        java = { enabled = true, include_main = true, package_detection = true },
        cpp = { enabled = true, include_common_headers = true, include_main = true },
        c = { enabled = true, include_common_headers = true, include_main = true },
        go = { enabled = true, package_name = "main", include_main = true },
        lua = { enabled = true, module_style = true },
        
        -- 文档
        markdown = { enabled = true, include_toc = true, include_metadata = true },
    },
    
    -- 自定义模板路径（可选）
    custom_template_dir = nil,
}

-- 获取当前时间字符串
local function get_current_time()
    return os.date(M.config.time_format)
end

-- 获取文件信息
local function get_file_info()
    return {
        filename = vim.fn.expand("%"),
        filename_without_ext = vim.fn.expand("%:r"),
        extension = vim.fn.expand("%:e"),
        filetype = vim.bo.filetype,
    }
end

-- 检查文件是否已有内容
local function has_content()
    if not M.config.prevent_overwrite then
        return false
    end
    
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    return #lines > 0 and lines[1] ~= ""
end

-- 设置光标位置
local function set_cursor_position(filetype, line, col)
    if not M.config.auto_cursor_position then
        return
    end
    
    vim.schedule(function()
        vim.api.nvim_win_set_cursor(0, {line or 1, col or 0})
    end)
end

-- 模板生成器
local generators = {}

-- Shell 脚本模板
generators.sh = function(file_info)
    local config = M.config.filetypes.sh
    local template = {}
    
    table.insert(template, config.shebang)
    table.insert(template, "#")
    table.insert(template, "# 文件名: " .. file_info.filename)
    table.insert(template, "# 作者: " .. M.config.author.name)
    table.insert(template, "# 创建时间: " .. get_current_time())
    table.insert(template, "# 描述: ")
    table.insert(template, "#")
    table.insert(template, "")
    table.insert(template, "set -euo pipefail")
    table.insert(template, "")
    table.insert(template, "# 主函数")
    table.insert(template, "main() {")
    table.insert(template, "    echo \"脚本开始执行\"")
    table.insert(template, "    ")
    table.insert(template, "}")
    table.insert(template, "")
    table.insert(template, "# 执行主函数")
    table.insert(template, "main \"$@\"")
    
    return template, {cursor = {13, 4}}
end

-- Python 脚本模板
generators.python = function(file_info)
    local config = M.config.filetypes.python
    local template = {}
    
    table.insert(template, config.shebang)
    table.insert(template, config.encoding)
    table.insert(template, "\"\"\"")
    table.insert(template, "文件名: " .. file_info.filename)
    table.insert(template, "作者: " .. M.config.author.name)
    table.insert(template, "创建时间: " .. get_current_time())
    table.insert(template, "描述: ")
    table.insert(template, "\"\"\"")
    table.insert(template, "")
    table.insert(template, "import sys")
    table.insert(template, "import os")
    table.insert(template, "from typing import Optional, List, Dict, Any")
    table.insert(template, "")
    table.insert(template, "")
    table.insert(template, "def main() -> None:")
    table.insert(template, "    \"\"\"主函数\"\"\"")
    table.insert(template, "    print(\"Hello, World!\")")
    table.insert(template, "    ")
    table.insert(template, "")
    table.insert(template, "")
    table.insert(template, "if __name__ == \"__main__\":")
    table.insert(template, "    main()")
    
    return template, {cursor = {17, 4}}
end

-- HTML 模板
generators.html = function(file_info)
    local config = M.config.filetypes.html
    local template = {}
    
    table.insert(template, "<!DOCTYPE html>")
    table.insert(template, "<html lang=\"" .. config.lang .. "\">")
    table.insert(template, "<head>")
    table.insert(template, "    <meta charset=\"UTF-8\">")
    table.insert(template, "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">")
    table.insert(template, "    <meta name=\"description\" content=\"\">")
    table.insert(template, "    <meta name=\"author\" content=\"" .. M.config.author.name .. "\">")
    table.insert(template, "    <title>" .. file_info.filename_without_ext .. "</title>")
    
    if config.include_css then
        table.insert(template, "    <link rel=\"stylesheet\" href=\"styles.css\">")
    end
    
    table.insert(template, "</head>")
    table.insert(template, "<body>")
    table.insert(template, "    <!-- 创建时间: " .. get_current_time() .. " -->")
    table.insert(template, "    <header>")
    table.insert(template, "        <h1>" .. file_info.filename_without_ext .. "</h1>")
    table.insert(template, "    </header>")
    table.insert(template, "    ")
    table.insert(template, "    <main>")
    table.insert(template, "        <section>")
    table.insert(template, "            ")
    table.insert(template, "        </section>")
    table.insert(template, "    </main>")
    table.insert(template, "    ")
    table.insert(template, "    <footer>")
    table.insert(template, "        <p>&copy; " .. os.date("%Y") .. " " .. M.config.author.name .. "</p>")
    table.insert(template, "    </footer>")
    
    if config.include_js then
        table.insert(template, "    <script src=\"script.js\"></script>")
    end
    
    table.insert(template, "</body>")
    table.insert(template, "</html>")
    
    return template, {cursor = {19, 12}}
end

-- CSS 模板
generators.css = function(file_info)
    local config = M.config.filetypes.css
    local template = {}
    
    table.insert(template, "/**")
    table.insert(template, " * 文件: " .. file_info.filename)
    table.insert(template, " * 作者: " .. M.config.author.name)
    table.insert(template, " * 创建时间: " .. get_current_time())
    table.insert(template, " * 描述: 样式表")
    table.insert(template, " */")
    table.insert(template, "")
    
    if config.include_variables then
        table.insert(template, ":root {")
        table.insert(template, "    /* 颜色变量 */")
        table.insert(template, "    --primary-color: #333;")
        table.insert(template, "    --secondary-color: #666;")
        table.insert(template, "    --accent-color: #007bff;")
        table.insert(template, "    --background-color: #fff;")
        table.insert(template, "    --text-color: #333;")
        table.insert(template, "    ")
        table.insert(template, "    /* 字体变量 */")
        table.insert(template, "    --font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;")
        table.insert(template, "    --font-size-base: 16px;")
        table.insert(template, "    --line-height-base: 1.6;")
        table.insert(template, "}")
        table.insert(template, "")
    end
    
    if config.include_reset then
        table.insert(template, "/* 基础重置 */")
        table.insert(template, "* {")
        table.insert(template, "    box-sizing: border-box;")
        table.insert(template, "    margin: 0;")
        table.insert(template, "    padding: 0;")
        table.insert(template, "}")
        table.insert(template, "")
        table.insert(template, "body {")
        table.insert(template, "    font-family: var(--font-family);")
        table.insert(template, "    font-size: var(--font-size-base);")
        table.insert(template, "    line-height: var(--line-height-base);")
        table.insert(template, "    color: var(--text-color);")
        table.insert(template, "    background-color: var(--background-color);")
        table.insert(template, "}")
        table.insert(template, "")
    end
    
    table.insert(template, "/* 主要样式 */")
    table.insert(template, "")
    
    return template, {cursor = {#template, 0}}
end

-- Java 模板
generators.java = function(file_info)
    local config = M.config.filetypes.java
    local template = {}
    
    table.insert(template, "/**")
    table.insert(template, " * @ProjectName: " .. file_info.filename)
    table.insert(template, " * @Author: " .. M.config.author.name)
    table.insert(template, " * @Date: " .. get_current_time())
    table.insert(template, " * @Description: ")
    table.insert(template, " */")
    table.insert(template, "")
    table.insert(template, "public class " .. file_info.filename_without_ext .. " {")
    table.insert(template, "    ")
    
    if config.include_main then
        table.insert(template, "    public static void main(String[] args) {")
        table.insert(template, "        System.out.println(\"Hello, World!\");")
        table.insert(template, "        ")
        table.insert(template, "    }")
        table.insert(template, "    ")
    end
    
    table.insert(template, "}")
    
    return template, {cursor = {config.include_main and 12 or 9, 8}}
end

-- Lua 模块模板
generators.lua = function(file_info)
    local config = M.config.filetypes.lua
    local template = {}
    
    table.insert(template, "--[[")
    table.insert(template, "文件: " .. file_info.filename)
    table.insert(template, "作者: " .. M.config.author.name)
    table.insert(template, "创建时间: " .. get_current_time())
    table.insert(template, "描述: ")
    table.insert(template, "--]]")
    table.insert(template, "")
    
    if config.module_style then
        table.insert(template, "local M = {}")
        table.insert(template, "")
        table.insert(template, "-- 默认配置")
        table.insert(template, "M.config = {")
        table.insert(template, "    -- 在此添加配置项")
        table.insert(template, "}")
        table.insert(template, "")
        table.insert(template, "-- 初始化函数")
        table.insert(template, "function M.setup(opts)")
        table.insert(template, "    opts = opts or {}")
        table.insert(template, "    M.config = vim.tbl_deep_extend('force', M.config, opts)")
        table.insert(template, "    ")
        table.insert(template, "    -- 在此处添加初始化代码")
        table.insert(template, "end")
        table.insert(template, "")
        table.insert(template, "return M")
    else
        table.insert(template, "-- 在此处添加代码")
        table.insert(template, "")
    end
    
    return template, {cursor = {config.module_style and 18 or 9, 4}}
end

-- Markdown 模板
generators.markdown = function(file_info)
    local config = M.config.filetypes.markdown
    local template = {}
    
    table.insert(template, "# " .. file_info.filename_without_ext)
    table.insert(template, "")
    
    if config.include_metadata then
        table.insert(template, "> **作者**: " .. M.config.author.name)
        table.insert(template, "> **创建时间**: " .. get_current_time())
        table.insert(template, "> **更新时间**: " .. get_current_time())
        table.insert(template, "")
    end
    
    table.insert(template, "## 简介")
    table.insert(template, "")
    table.insert(template, "")
    
    if config.include_toc then
        table.insert(template, "## 目录")
        table.insert(template, "")
        table.insert(template, "- [简介](#简介)")
        table.insert(template, "- [正文](#正文)")
        table.insert(template, "- [参考资料](#参考资料)")
        table.insert(template, "")
    end
    
    table.insert(template, "## 正文")
    table.insert(template, "")
    table.insert(template, "")
    table.insert(template, "")
    table.insert(template, "## 参考资料")
    table.insert(template, "")
    table.insert(template, "- ")
    
    return template, {cursor = {config.include_metadata and 10 or 4, 0}}
end

-- 生成模板
function M.generate_template(filetype)
    if not M.config.enabled then
        return
    end
    
    if has_content() then
        return
    end
    
    local file_info = get_file_info()
    local generator = generators[filetype]
    
    if not generator or not M.config.filetypes[filetype] or not M.config.filetypes[filetype].enabled then
        return
    end
    
    local template, options = generator(file_info)
    if template then
        vim.api.nvim_buf_set_lines(0, 0, -1, false, template)
        
        if options and options.cursor then
            set_cursor_position(filetype, options.cursor[1], options.cursor[2])
        end
    end
end

-- 设置配置
function M.setup(opts)
    M.config = vim.tbl_deep_extend('force', M.config, opts or {})
end

-- 获取支持的文件类型列表
function M.get_supported_filetypes()
    local filetypes = {}
    for ft, config in pairs(M.config.filetypes) do
        if config.enabled then
            table.insert(filetypes, ft)
        end
    end
    return filetypes
end

-- 启用/禁用特定文件类型
function M.toggle_filetype(filetype, enabled)
    if M.config.filetypes[filetype] then
        M.config.filetypes[filetype].enabled = enabled
    end
end

-- 添加自定义模板生成器
function M.add_generator(filetype, generator_func)
    generators[filetype] = generator_func
    if not M.config.filetypes[filetype] then
        M.config.filetypes[filetype] = { enabled = true }
    end
end

return M