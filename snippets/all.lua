local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local types = require "luasnip.util.types"

-- 全局snippets选择快捷键
vim.keymap.set({ "i", "s" }, "<A-n>", function()
  if ls.choice_active() then ls.change_choice(1) end
end, { silent = true })

-- 全局可用的snippets
ls.add_snippets("all", {
  s("p3", t "lb-conda default/2023-04-26 python3"),
  -- 添加时间戳snippet
  s(
    "timestamp",
    fmt("{}", { t(tostring(os.date("%Y-%m-%d %H:%M:%S"))) })
  ),
  -- 添加简单的注释块
  s(
    "todo",
    fmt("TODO: {}", { i(1, "待办事项") })
  ),
})
