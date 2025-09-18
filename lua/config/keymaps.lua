-- 优化后的键位映射配置
-- 解决冲突，符合普通用户习惯

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- ========== 基础设置 ==========
-- hjkl 可以跨行
vim.opt.whichwrap:append("h,l,<,>,[,]")

-- ========== 插入模式 ==========
-- 快速退出插入模式
keymap.set("i", "jk", "<ESC>", { desc = "退出插入模式" })

-- Windows 风格的常用快捷键
keymap.set("i", "<C-s>", "<Cmd>w<CR>", { desc = "保存文件" })
keymap.set("i", "<C-z>", "<Esc>u<CR>i", { desc = "撤销" })

-- 插入模式下的移动（更符合习惯）
keymap.set("i", "<C-h>", "<Left>", { desc = "左移" })
keymap.set("i", "<C-l>", "<Right>", { desc = "右移" })
keymap.set("i", "<C-j>", "<Down>", { desc = "下移" })
keymap.set("i", "<C-k>", "<Up>", { desc = "上移" })

-- 行首行尾移动
keymap.set("i", "<C-a>", "<Home>", { desc = "行首" })
keymap.set("i", "<C-e>", "<End>", { desc = "行尾" })

-- 删除操作
keymap.set("i", "<C-d>", "<Del>", { desc = "删除右侧字符" })
keymap.set("i", "<C-w>", "<C-G>u<C-W>", { desc = "删除单词" })
keymap.set("i", "<C-u>", "<C-G>u<C-U>", { desc = "删除到行首" })

-- ========== 视觉模式 ==========
-- 快速退出视觉模式
keymap.set("v", "<C-c>", "<ESC>", { desc = "退出视觉模式" })

-- 移动选中的行
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "向下移动选中行" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "向上移动选中行" })

-- Windows 风格复制粘贴
keymap.set("v", "<C-c>", '"+y', { desc = "复制到系统剪贴板" })
keymap.set("v", "<C-x>", '"+d', { desc = "剪切到系统剪贴板" })
keymap.set("v", "<C-v>", '"+p', { desc = "从系统剪贴板粘贴" })

-- ========== 正常模式 ==========
-- Windows 风格操作
keymap.set("n", "<C-a>", "ggVG", { desc = "全选" })
keymap.set("n", "<C-s>", "<Cmd>w<CR>", { desc = "保存文件" })
keymap.set("n", "<C-z>", "u", { desc = "撤销" })
keymap.set("n", "<C-y>", "<C-r>", { desc = "重做" })

-- 复制粘贴
keymap.set("n", "<C-c>", '"+y', { desc = "复制到系统剪贴板" })
keymap.set("n", "<C-v>", '"+p', { desc = "从系统剪贴板粘贴" })

-- 缓冲区切换（使用 Alt 避免冲突）
keymap.set("n", "<A-l>", ":bnext<CR>", { desc = "下一个缓冲区" })
keymap.set("n", "<A-h>", ":bprevious<CR>", { desc = "上一个缓冲区" })
keymap.set("n", "<A-w>", ":bdelete<CR>", { desc = "关闭当前缓冲区" })

-- 窗口管理
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "垂直分割窗口" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "水平分割窗口" })
keymap.set("n", "<leader>sc", "<C-w>c", { desc = "关闭当前窗口" })
keymap.set("n", "<leader>so", "<C-w>o", { desc = "关闭其他窗口" })

-- 窗口间移动（使用 Ctrl + 方向键，更直观）
keymap.set("n", "<C-Left>", "<C-w>h", { desc = "移动到左窗口" })
keymap.set("n", "<C-Down>", "<C-w>j", { desc = "移动到下窗口" })
keymap.set("n", "<C-Up>", "<C-w>k", { desc = "移动到上窗口" })
keymap.set("n", "<C-Right>", "<C-w>l", { desc = "移动到右窗口" })

-- 窗口大小调整
keymap.set("n", "<A-Left>", "<C-w><", { desc = "减小窗口宽度" })
keymap.set("n", "<A-Right>", "<C-w>>", { desc = "增加窗口宽度" })
keymap.set("n", "<A-Up>", "<C-w>+", { desc = "增加窗口高度" })
keymap.set("n", "<A-Down>", "<C-w>-", { desc = "减小窗口高度" })

-- 搜索相关
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "取消高亮" })
keymap.set("n", "n", "nzzzv", { desc = "下一个搜索结果并居中" })
keymap.set("n", "N", "Nzzzv", { desc = "上一个搜索结果并居中" })

-- 页面滚动并居中
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "向下半页并居中" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "向上半页并居中" })

-- 行移动
keymap.set("n", "j", "gj", { desc = "向下移动（包括换行）" })
keymap.set("n", "k", "gk", { desc = "向上移动（包括换行）" })

-- 快速跳转
keymap.set("n", "H", "^", { desc = "跳转到行首" })
keymap.set("n", "L", "$", { desc = "跳转到行尾" })

-- 终端
keymap.set("n", "<leader>t", function()
    vim.cmd("split | terminal")
    vim.cmd("resize 15")
end, { desc = "打开终端" })

-- 退出终端模式
keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "退出终端模式" })

-- 跳转到声明
keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
-- 跳转到定义
-- keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
-- 跳转到实现
keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
-- 跳转到类型定义
-- keymap.set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
keymap.set("n", "<space>D", "<cmd>Lspsaga peek_type_definition<CR>")
-- 重命名
keymap.set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
-- 查找引用
keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
-- 显示行诊断信息
keymap.set("n", "<space>sd", "<cmd>lua vim.diagnostic.setloclist()<CR>")
keymap.set("n", "<space>sj", "<cmd>Lspsaga diagnostic_jump_next<CR>")
keymap.set("n", "<space>sk", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
-- 跳转到下一个诊断
-- keymap.set("n", "<S-C-j>", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
-- 格式化文档
keymap.set("n", "<leader>F", "<cmd>lua vim.lsp.buf.format()<CR>")
-- 建议操作
-- keymap.set("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>")
-- keymap.set("n", "<leader>a", "<cmd>Lspsaga code_action<CR>")
keymap.set("n", "<leader>ql", "<cmd>Lspsaga code_action<CR>")

-- 切换bufferline
keymap.set("n", "<C-L>", ":bnext<CR>")
keymap.set("n", "<C-H>", ":bprevious<CR>")

-- ========== Leader 键映射 ==========
-- 文件操作
keymap.set("n", "<leader>w", "<Cmd>w<CR>", { desc = "保存文件" })
keymap.set("n", "<leader>q", "<Cmd>q<CR>", { desc = "退出" })
keymap.set("n", "<leader>wq", "<Cmd>wq<CR>", { desc = "保存并退出" })

-- 路径复制
keymap.set("n", "<leader>cp", function()
    local path = vim.fn.expand("%")
    vim.fn.setreg("+", path)
    vim.notify("已复制相对路径: " .. path)
end, { desc = "复制相对路径" })

keymap.set("n", "<leader>pp", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    vim.notify("已复制绝对路径: " .. path)
end, { desc = "复制绝对路径" })

-- 错误复制
keymap.set("n", "<leader>ce", function()
    local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    if #diagnostics > 0 then
        local message = diagnostics[1].message
        vim.fn.setreg("+", message)
        vim.notify("已复制错误信息到剪贴板")
    else
        vim.notify("未找到错误信息", vim.log.levels.WARN)
    end
end, { desc = "复制最近错误" })

-- ========== 插件相关 ==========
-- 文件树
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "切换文件树" })

-- 终端
keymap.set("n", "<leader>t", function()
    vim.cmd("split | terminal")
    vim.cmd("resize 15")
end, { desc = "打开终端" })

-- 退出终端模式
keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "退出终端模式" })

-- ========== 数字递增递减 ==========
-- 恢复被覆盖的功能
keymap.set("n", "<leader>a", "<C-a>", { desc = "数字递增" })
keymap.set("n", "<leader>x", "<C-x>", { desc = "数字递减" })

-- 块选择模式
keymap.set("n", "<A-v>", "<C-v>", { desc = "块选择模式" })

-- ========== 禁用一些容易误触的键 ==========
-- 禁用 Ex 模式
keymap.set("n", "Q", "<nop>", { desc = "禁用 Ex 模式" })

-- 禁用宏录制（容易误触）
-- keymap.set("n", "q", "<nop>", { desc = "禁用宏录制" })

-- ========== 自动命令 ==========
-- 插入模式显示绝对行号，普通模式显示相对行号
vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = false
    end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
        vim.opt.relativenumber = true
    end,
})

-- 自动保存
vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
    pattern = "*",
    callback = function()
        if vim.bo.modified and vim.bo.buftype == "" then
            vim.cmd("silent! write")
        end
    end,
})