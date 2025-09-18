local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("dockerfile", {
  -- 基础Dockerfile模板
  s(
    "dockerfile",
    fmt(
      [[
FROM {}
WORKDIR {}
COPY {} .
RUN {}
EXPOSE {}
CMD ["{}"]
      ]],
      {
        i(1, "node:18-alpine"),
        i(2, "/app"),
        i(3, "package*.json"),
        i(4, "npm install"),
        i(5, "3000"),
        i(6, "npm", "start")
      }
    )
  ),
  -- FROM指令
  s(
    "from",
    fmt("FROM {}", {i(1, "ubuntu:latest")})
  ),
  -- RUN指令
  s(
    "run",
    fmt("RUN {}", {i(1, "apt-get update")})
  ),
  -- COPY指令
  s(
    "copy",
    fmt("COPY {} {}", {i(1, "src"), i(2, "dest")})
  ),
  -- WORKDIR指令
  s(
    "workdir",
    fmt("WORKDIR {}", {i(1, "/app")})
  ),
  -- ENV指令
  s(
    "env",
    fmt("ENV {}={}", {i(1, "NODE_ENV"), i(2, "production")})
  ),
  -- EXPOSE指令
  s(
    "expose",
    fmt("EXPOSE {}", {i(1, "80")})
  ),
})