local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
-- local types = require "luasnip.util.types"

ls.add_snippets("yaml", {
  -- 原有的物理公式snippet
  s(
    "inv2",
    fmt(
      [[
TMath::Sqrt(TMath::Power({}_PE+{}_PE,2)-TMath::Power({}_PX+{}_PX,2)-TMath::Power({}_PY+{}_PY,2)-TMath::Power({}_PZ+{}_PZ,2))
      ]],
      {i(1), i(2), rep(1), rep(2), rep(1), rep(2), rep(1), rep(2)}
    )
  ),
  -- 添加YAML基础snippets
  s(
    "key",
    fmt(
      [[
{}: {}
      ]],
      {i(1, "key"), i(2, "value")}
    )
  ),
  s(
    "list",
    fmt(
      [[
{}:
  - {}
  - {}
      ]],
      {i(1, "items"), i(2, "item1"), i(3, "item2")}
    )
  ),
  s(
    "docker",
    fmt(
      [[
version: '{}'
services:
  {}:
    image: {}
    ports:
      - "{}:{}"
    volumes:
      - {}:{}
    environment:
      - {}={}
      ]],
      {
        i(1, "3.8"),
        i(2, "app"),
        i(3, "nginx"),
        i(4, "80"),
        i(5, "80"),
        i(6, "./data"),
        i(7, "/app/data"),
        i(8, "ENV_VAR"),
        i(9, "value")
      }
    )
  ),
})


