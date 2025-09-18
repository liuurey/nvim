local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

ls.add_snippets("json", {
  -- 基础对象
  s(
    "obj",
    fmt(
      [[
{{
  "{}": "{}"
}}
      ]],
      {i(1, "key"), i(2, "value")}
    )
  ),
  -- 数组
  s(
    "arr",
    fmt(
      [[
[
  "{}",
  "{}"
]
      ]],
      {i(1, "item1"), i(2, "item2")}
    )
  ),
  -- package.json模板
  s(
    "package",
    fmt(
      [[
{{
  "name": "{}",
  "version": "{}",
  "description": "{}",
  "main": "{}",
  "scripts": {{
    "start": "{}",
    "test": "{}"
  }},
  "dependencies": {{}},
  "devDependencies": {{}}
}}
      ]],
      {
        i(1, "my-project"),
        i(2, "1.0.0"),
        i(3, "Project description"),
        i(4, "index.js"),
        i(5, "node index.js"),
        i(6, "jest")
      }
    )
  ),
  -- tsconfig.json模板
  s(
    "tsconfig",
    fmt(
      [[
{{
  "compilerOptions": {{
    "target": "{}",
    "module": "{}",
    "lib": ["{}"],
    "outDir": "{}",
    "rootDir": "{}",
    "strict": {},
    "esModuleInterop": {},
    "skipLibCheck": {}
  }},
  "include": ["{}"],
  "exclude": ["{}"]
}}
      ]],
      {
        i(1, "ES2020"),
        i(2, "commonjs"),
        i(3, "ES2020"),
        i(4, "./dist"),
        i(5, "./src"),
        i(6, "true"),
        i(7, "true"),
        i(8, "true"),
        i(9, "src/**/*"),
        i(10, "node_modules")
      }
    )
  ),
})