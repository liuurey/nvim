# LSP服务器问题

<cite>
**本文档引用的文件**
- [lsp-config.lua](file://lua/plugins/lsp-config.lua)
- [mason.lua](file://lua/plugins/mason.lua)
</cite>

## 目录
1. [LSP服务器启动失败的常见原因](#lsp服务器启动失败的常见原因)
2. [使用Mason检查语言服务器安装状态](#使用mason检查语言服务器安装状态)
3. [验证lsp-config.lua中的服务器配置](#验证lsp-configlua中的服务器配置)
4. [使用:LspInfo诊断LSP连接状态](#使用lsppinfo诊断lsp连接状态)
5. [主要语言服务器的调试命令与配置修复示例](#主要语言服务器的调试命令与配置修复示例)
6. [总结与建议](#总结与建议)

## LSP服务器启动失败的常见原因

LSP（Language Server Protocol）服务器在Neovim中未能成功启动，通常由以下几类问题导致：

1. **语言服务器未通过Mason正确安装**：Mason作为包管理器，负责统一安装LSP服务器、DAP调试器、格式化工具等。若未正确安装或安装不完整，将导致LSP无法启动。
2. **PATH路径配置错误**：某些语言服务器需要系统PATH中包含可执行文件路径，否则Neovim无法调用。
3. **初始化参数异常**：`lsp-config.lua`中对服务器的配置（如`settings`、`cmd`、`capabilities`）存在错误或不兼容，导致服务器拒绝启动。
4. **自动安装被禁用**：在`mason.lua`中，`automatic_installation = false`和`automatic_enable = false`明确禁用了自动安装和启用，需手动确保服务器已安装。
5. **Neovim版本与API不兼容**：当前配置基于Neovim 0.11+，若版本过低可能导致`vim.lsp.enable()`等新API不可用。

**Section sources**
- [mason.lua](file://lua/plugins/mason.lua#L27-L78)
- [lsp-config.lua](file://lua/plugins/lsp-config.lua#L300-L323)

## 使用Mason检查语言服务器安装状态

Mason提供了直观的UI界面来管理所有语言工具。可通过以下步骤检查LSP服务器安装状态：

1. 打开Neovim后，执行`:Mason`命令，打开Mason包管理器界面。
2. 在列表中查找目标语言服务器，如`pyright`、`lua-language-server`、`rust-analyzer`等。
3. 查看其状态：
   - ✓ 表示已安装
   - ➜ 表示正在安装
   - ✗ 表示未安装
4. 若未安装，可使用`i`键进行安装；若版本过旧，使用`u`键更新。

配置文件中已通过`ensure_installed`字段预设了所有常用LSP服务器，确保在首次启动时自动安装（延迟1秒执行以避免初始化冲突）。

**Section sources**
- [mason.lua](file://lua/plugins/mason.lua#L27-L78)
- [mason.lua](file://lua/plugins/mason.lua#L100-L168)

## 保留所有原有服务器（移除已注释的 ruff）
ts_ls = {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
  },
},
rust_analyzer = {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      inlayHints = {
        chainingHints = { enable = true },
        parameterHints = { enable = true },
        typeHints = { enable = true },
      },
    },
  },
},
clangd = {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders=true",  -- 修复：添加缺失的值
  },
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
},
jdtls = {},
html = {},
cssls = {},
bashls = {},
jsonls = {
  on_new_config = function(new_config)
    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
    vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
  end,
  settings = {
    json = {
      format = { enable = true },
      validate = { enable = true },
    },
  },
},
yamlls = {
  on_new_config = function(new_config)
    new_config.settings.yaml.schemas = vim.tbl_deep_extend(
      "force",
      new_config.settings.yaml.schemas or {},
      require("schemastore").yaml.schemas()
    )
  end,
  settings = {
    yaml = {
      keyOrdering = false,
      format = { enable = true },
      validate = true,
      schemaStore = { enable = false, url = "" },
    },
  },
},
dockerls = {},
marksman = {},
sqlls = {},
eslint = {
  settings = {
    workingDirectories = { mode = "auto" },
  },
},

## 使用:LspInfo诊断LSP连接状态

`:LspInfo`是Neovim内置命令，用于查看当前缓冲区中所有已连接的LSP服务器状态。执行该命令后，将显示以下信息：

- 已激活的LSP服务器列表
- 每个服务器的PID、端口、根目录
- capabilities支持情况
- `on_attach`回调是否成功执行

若某语言文件未显示对应LSP服务器，说明服务器未成功启动。此时应结合`:messages`查看错误日志，或检查Mason安装状态。

在`lsp-config.lua`中，所有服务器均通过`vim.lsp.config()`定义，并显式调用`vim.lsp.enable(server)`启用，确保配置生效。

**Section sources**
- [lsp-config.lua](file://lua/plugins/lsp-config.lua#L300-L323)

## 主要语言服务器的调试命令与配置修复示例

### Python (pyright)

- **安装命令**：`:MasonInstall pyright`
- **配置文件**：`lsp-config.lua`中`pyright`服务器已配置`typeCheckingMode = "basic"`，确保基础类型检查。
- **调试命令**：
  - `:LspInfo` 确认pyright是否运行
  - `:checkhealth` 查看Python环境是否正常
  - `:e test.py` 打开Python文件后观察诊断信息

### Lua (lua_ls)

- **安装命令**：`:MasonInstall lua-language-server`
- **配置文件**：`lsp-config.lua`中`lua_ls`配置了`runtime.version = "LuaJIT"`和`telemetry.enable = false`，符合Neovim环境。
- **调试命令**：
  - `:LspInfo` 确认lua_ls是否运行
  - `:lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))` 查看工作区路径
  - `:e init.lua` 测试Lua文件诊断

### Rust (rust_analyzer)

- **安装命令**：`:MasonInstall rust-analyzer`
- **配置文件**：`lsp-config.lua`中`rust_analyzer`启用了`cargo.allFeatures = true`和内联提示。
- **调试命令**：
  - `:LspInfo` 确认rust_analyzer是否运行
  - `:e main.rs` 打开Rust文件后观察`inlayHints`是否显示类型和参数
  - `:LspRestart` 重启服务器以应用新配置

**Section sources**
- [lsp-config.lua](file://lua/plugins/lsp-config.lua#L100-L250)
- [mason.lua](file://lua/plugins/mason.lua#L27-L78)

## 总结与建议

为确保LSP服务器稳定运行，建议遵循以下最佳实践：

1. **定期使用`:Mason`检查安装状态**，确保所有LSP服务器已正确安装。
2. **避免自动安装冲突**：当前配置禁用`automatic_installation`，由Mason手动管理更稳定。
3. **使用`:LspInfo`快速诊断**：当LSP未生效时，第一时间使用该命令确认连接状态。
4. **保持Neovim版本更新**：确保支持`vim.lsp.enable()`等新API，避免兼容性问题。
5. **检查`on_attach`回调**：确保快捷键和功能（如文档高亮、内联提示）正确绑定。

通过以上步骤，可系统性排查并解决LSP服务器启动失败问题，提升开发体验。

**Section sources**
- [lsp-config.lua](file://lua/plugins/lsp-config.lua#L255-L323)
- [mason.lua](file://lua/plugins/mason.lua#L100-L168)