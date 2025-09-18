local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("html", {
  -- HTML5基础模板
  s(
    "html5",
    fmt(
      [[
<!DOCTYPE html>
<html lang="{}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{}</title>
    {}
</head>
<body>
    {}
</body>
</html>
      ]],
      {
        i(1, "zh-CN"),
        i(2, "Page Title"),
        i(3, ""),
        i(4, "<h1>Hello World</h1>")
      }
    )
  ),
  -- div标签
  s(
    "div",
    fmt('<div class="{}">{}</div>', {i(1, "container"), i(2, "")})
  ),
  -- 带id的div
  s(
    "divid",
    fmt('<div id="{}">{}</div>', {i(1, "myId"), i(2, "")})
  ),
  -- 链接
  s(
    "a",
    fmt('<a href="{}">{}</a>', {i(1, "#"), i(2, "链接文本")})
  ),
  -- 图片
  s(
    "img",
    fmt('<img src="{}" alt="{}">', {i(1, "image.jpg"), i(2, "描述")})
  ),
  -- 表单
  s(
    "form",
    fmt(
      [[
<form action="{}" method="{}">
    {}
    <input type="submit" value="{}">
</form>
      ]],
      {
        i(1, "#"),
        i(2, "POST"),
        i(3, '<input type="text" name="username" placeholder="用户名">'),
        i(4, "提交")
      }
    )
  ),
  -- 输入框
  s(
    "input",
    fmt('<input type="{}" name="{}" placeholder="{}">', {i(1, "text"), i(2, "name"), i(3, "输入...")})
  ),
})