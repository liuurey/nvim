# 🚀 Personal Neovim Configuration

基于 LazyVim 的个人 Neovim 配置，提供现代化的开发体验和高效的编程环境。

## ✨ 特性

### 📦 核心功能
- 🎯 **基于 LazyVim** - 使用现代化的 LazyVim 框架
- 🔧 **LSP 集成** - 完整的语言服务器支持
- 🧠 **智能补全** - 基于 blink.cmp 的高性能补全系统
- 🎨 **语法高亮** - nvim-treesitter 提供精确的语法解析
- 📁 **代码片段** - LuaSnip 驱动的智能代码片段
- 🔍 **模糊搜索** - Telescope 提供强大的文件和内容搜索

### 🎮 增强功能
- 🚪 **智能退出** - `<leader>Q` 快速退出，`:Q` 智能退出所有
- 🎯 **键位优化** - 解决键位冲突，提供语义化快捷键
- 📊 **启动页面** - Snacks dashboard 提供美观的启动界面
- 🖼️ **图像支持** - Snacks.image 支持图像和图表渲染
- 🔄 **自动命令** - 智能的文件处理和环境优化

### 🛠️ 开发工具
- 🐍 **Python 开发** - 完整的 Python 开发环境
- 🔧 **C/C++ 支持** - clangd 提供的强大 C/C++ 支持
- 🌐 **Web 开发** - JavaScript/TypeScript/HTML/CSS 支持
- 📝 **文档编写** - Markdown/LaTeX 支持
- 🦀 **Rust 开发** - 完整的 Rust 开发工具链

## 📋 系统要求

### 必须
- **Neovim** >= 0.9.0
- **Git** - 用于插件管理
- **Node.js** >= 16.x - 用于某些 LSP 服务器
- **Python** >= 3.8 - 用于 Python 开发支持

### 推荐
- **Rust & Cargo** - 用于某些 Rust 工具
- **Go** >= 1.19 - 用于 Go 开发
- **ripgrep** - 更快的文件搜索
- **fd** - 更快的文件查找

### 可选工具
- **ImageMagick** - 图像处理支持
- **Ghostscript** - PDF 文件支持
- **Tectonic** - LaTeX 编译器
- **Mermaid CLI** - 图表渲染

## 🚀 安装

### 1. 备份现有配置
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

### 2. 克隆此配置
```bash
git clone https://github.com/SantaChains/nvim.git ~/.config/nvim
```

### 3. 启动 Neovim
```bash
nvim
```

首次启动时，LazyVim 会自动安装所有插件。

### 4. 安装 LSP 服务器
在 Neovim 中运行：
```vim
:Mason
```
然后安装需要的语言服务器。

### 5. 安装 Treesitter 解析器
```vim
:TSInstallInfo
```
选择并安装需要的语法解析器。

## ⌨️ 键位映射

### 基础操作
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>Q` | 退出当前窗口 | 快速退出 |
| `:Q` | 智能退出所有 | 检查未保存文件 |
| `<leader>D` | 启动页面 | 打开 dashboard |

### LSP 功能 (Programming)
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>pr` | 重命名符号 | LSP 重命名 |
| `<leader>pa` | 代码操作 | 显示可用操作 |
| `<leader>pd` | 跳转定义 | 跳转到定义 |
| `<leader>pR` | 查找引用 | 查找所有引用 |
| `<leader>ph` | 悬停信息 | 显示文档 |
| `<leader>pi` | 跳转实现 | 跳转到实现 |
| `<leader>ps` | 文档符号 | 文档符号列表 |
| `<leader>pD` | 跳转声明 | 跳转到声明 |
| `<leader>pf` | 格式化 | 格式化代码 |
| `<leader>F` | 全局格式化 | 格式化代码 |

### 诊断和调试
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>dd` | 诊断列表 | 显示诊断信息 |
| `<leader>db` | 缓冲区诊断 | 当前文件诊断 |
| `<leader>dj` | 下一个诊断 | 跳转到下一个问题 |
| `<leader>dk` | 上一个诊断 | 跳转到上一个问题 |
| `<leader>de` | 诊断详情 | 显示详细诊断 |

### Python 调试
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>pyb` | 切换断点 | 设置/移除断点 |
| `<leader>pyc` | 继续执行 | 调试继续 |

### 配置管理
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>Cc` | 编辑配置 | 编辑 init.lua |
| `<leader>Cv` | 编辑键位 | 编辑键位配置 |
| `<leader>Cp` | 编辑插件 | 编辑插件配置 |
| `<leader>Cs` | 编辑片段 | 编辑代码片段 |
| `<leader>Cr` | 重载配置 | 重新加载配置 |

### 搜索和浏览
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>sss` | 全局搜索 | 内容搜索 |
| `<leader>ssf` | 文件搜索 | 查找文件 |
| `<leader>ssb` | 缓冲区列表 | 打开的文件 |

## 📁 配置结构

```
~/.config/nvim/
├── init.lua                    # 主入口文件
├── lua/
│   ├── config/
│   │   ├── autocmds.lua        # 自动命令
│   │   ├── keybindings.lua     # 键位映射
│   │   ├── lazy.lua            # 插件管理器配置
│   │   └── options.lua         # Neovim 选项
│   └── plugins/
│       ├── blink-cmp.lua       # 补全系统
│       ├── essential.lua       # 核心插件
│       ├── lsp-config.lua      # LSP 配置
│       ├── mason.lua           # LSP 管理器
│       ├── quicker.lua         # 快速工具
│       ├── snacks.lua          # UI 增强
│       └── theme.lua           # 主题配置
├── snippets/                   # 代码片段
│   ├── lua.lua
│   ├── python.lua
│   └── ...
└── LSP/                        # LSP 配置
    ├── python.lua
    ├── lua.lua
    └── ...
```

## 🔧 自定义

### 添加新的语言支持
1. 在 `LSP/` 目录添加语言配置文件
2. 在 `snippets/` 目录添加代码片段
3. 更新 treesitter 配置以包含新语言
4. 通过 Mason 安装相应的 LSP 服务器

### 修改键位映射
编辑 `lua/config/keybindings.lua` 文件，按照现有模式添加或修改键位。

### 添加插件
在 `lua/plugins/` 目录中创建新文件或修改现有文件，按照 lazy.nvim 的格式配置插件。

## 🛠️ 实用命令

### Treesitter 管理
- `:TSStatus` - 显示解析器状态
- `:TSInstallLatex` - 安装 LaTeX 解析器
- `:TSHealth` - 检查 Treesitter 健康状态

### 键位检查
- `:ShowAllKeymaps` - 显示所有键位映射
- `:ShowLeaderKeymaps` - 显示 Leader 键位
- `:VerifyKeymapFix` - 验证键位修复

### 系统检查
- `:checkhealth` - 检查系统健康状态
- `:checkhealth which-key` - 检查键位系统
- `:checkhealth snacks` - 检查 UI 功能

## 🎨 主题和外观

配置支持多种主题，默认使用现代化的配色方案。可以通过修改 `lua/plugins/theme.lua` 来自定义外观。

### Neovide 支持
如果使用 Neovide GUI，配置文件包含专门的 GUI 优化设置，包括：
- 透明度控制
- 动画效果
- 字体配置
- 窗口行为

## 🐛 故障排除

### 常见问题

1. **插件安装失败**
   ```vim
   :Lazy sync
   ```

2. **LSP 不工作**
   ```vim
   :LspInfo
   :Mason
   ```

3. **键位冲突**
   ```vim
   :VerifyKeymapFix
   ```

4. **补全不工作**
   ```vim
   :checkhealth blink
   ```

### 日志查看
- Lazy 插件日志：`:Lazy log`
- LSP 日志：`:LspLog`
- Neovim 消息：`:messages`

## 📊 性能优化

配置包含多项性能优化：
- 懒加载插件系统
- 高性能补全引擎
- 优化的启动时间
- 智能文件处理

## 🤝 贡献

欢迎提交 Issues 和 Pull Requests 来改进这个配置！

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

感谢以下项目：
- [LazyVim](https://github.com/LazyVim/LazyVim) - 现代 Neovim 配置框架
- [folke/lazy.nvim](https://github.com/folke/lazy.nvim) - 插件管理器
- [Saghen/blink.cmp](https://github.com/Saghen/blink.cmp) - 高性能补全
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - 语法解析
- 以及所有其他优秀的插件开发者们

---

⭐ 如果这个配置对您有帮助，请给个星星！