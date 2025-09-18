local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("css", {
  -- CSS规则
  s(
    "rule",
    fmt(
      [[
{} {{
    {}: {};
}}
      ]],
      {i(1, ".class"), i(2, "property"), i(3, "value")}
    )
  ),
  -- Flexbox容器
  s(
    "flex",
    fmt(
      [[
display: flex;
justify-content: {};
align-items: {};
      ]],
      {i(1, "center"), i(2, "center")}
    )
  ),
  -- Grid布局
  s(
    "grid",
    fmt(
      [[
display: grid;
grid-template-columns: {};
grid-gap: {};
      ]],
      {i(1, "repeat(3, 1fr)"), i(2, "1rem")}
    )
  ),
  -- CSS变量定义
  s(
    "var",
    fmt("--{}: {};", {i(1, "variable-name"), i(2, "value")})
  ),
  -- 媒体查询
  s(
    "media",
    fmt(
      [[
@media ({}) {{
    {}
}}
      ]],
      {i(1, "max-width: 768px"), i(2, "/* styles */")}
    )
  ),
  -- 动画关键帧
  s(
    "keyframes",
    fmt(
      [[
@keyframes {} {{
    0% {{
        {}
    }}
    100% {{
        {}
    }}
}}
      ]],
      {i(1, "animationName"), i(2, "transform: translateX(0);"), i(3, "transform: translateX(100px);")}
    )
  ),
  -- 盒阴影
  s(
    "shadow",
    fmt("box-shadow: {} {} {} {};", {i(1, "0"), i(2, "2px"), i(3, "4px"), i(4, "rgba(0,0,0,0.1)")})
  ),
})