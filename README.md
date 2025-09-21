# 🚀 Neovim 配置 - Termux/Android 优化版

基于 LazyVim 的个人 Neovim 配置，专为 **Android Termux** 环境优化，提供现代化的开发体验和高效的移动编程环境。

## ✨ 核心特性

### 📱 Termux/Android 优化
- 🔋 **性能优化** - 针对移动设备性能调优，减少内存占用
- 📱 **触摸友好** - 优化的界面和键位，适配触摸操作
- ⚡ **快速启动** - 懒加载插件系统，快速启动和响应
- 🔧 **Termux 集成** - 深度集成 Termux 环境，支持 bash/zsh
- 📶 **离线支持** - 优化的离线使用体验

### 🎯 现代化开发环境
- 🧠 **智能补全** - blink.cmp 高性能补全系统，Termux 优化
- 🔍 **LSP 支持** - 完整的语言服务器支持，支持多种编程语言
- 🎨 **语法高亮** - nvim-treesitter 精确语法解析，移动设备优化
- 📁 **文件管理** - NvimTree 和 Telescope 文件浏览增强
- 🐛 **调试支持** - nvim-dap 调试器，支持 Python/C++/Rust 等

### 🎮 增强功能
- 🚪 **智能退出** - `<leader>Q` 快速退出，`:Q` 智能退出所有
- 🎯 **语义化键位** - 解决键位冲突，提供直观的快捷键
- 📊 **启动界面** - Snacks dashboard 美观启动界面
- 🖼️ **图像支持** - 支持图像和图表渲染（Termux 优化）
- 🔄 **自动命令** - 智能文件处理和环境优化

## 📋 系统要求

### 必须环境
- **Android** 7.0+ 设备
- **Termux** 最新版本
- **Neovim** >= 0.9.0
- **Git** - 插件管理
- **zsh** 或 **bash** - Shell 环境

### 推荐工具
- **Node.js** >= 16.x - JavaScript/TypeScript 支持
- **Python** >= 3.8 - Python 开发和 LSP 支持
- **ripgrep** - 快速文件搜索
- **fd** - 快速文件查找

### 可选工具
- **Rust & Cargo** - Rust 开发
- **Go** >= 1.19 - Go 开发
- **C/C++ 编译器** - C/C++ 开发支持

## 🚀 Termux 安装指南

### 1. Termux 环境准备
```bash
# 更新 Termux 包管理器
pkg update && pkg upgrade

# 安装必要工具
pkg install git neovim zsh curl wget

# 安装推荐工具（可选）
pkg install nodejs python ripgrep fd-find

# 安装 zsh（推荐）
pkg install zsh
chsh -s zsh
```

### 2. 备份现有配置
```bash
# 备份现有 Neovim 配置
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null || true
mv ~/.local/share/nvim ~/.local/share/nvim.backup 2>/dev/null || true
mv ~/.cache/nvim ~/.cache/nvim.backup 2>/dev/null || true
```

### 3. 克隆配置
```bash
# 进入配置目录
cd ~

# 使用 GitHub 原始地址
git clone https://github.com/liuurey/nvim.git ~/.config/nvim
```

### 4. 首次启动
```bash
# 启动 Neovim（首次启动会自动安装插件）
nvim

# 等待插件安装完成（可能需要几分钟）
# 安装完成后重启 Neovim
```

### 5. 安装 LSP 服务器
在 Neovim 中运行：
```vim
:Mason
```
选择需要的语言服务器进行安装。

### 6. 安装 Treesitter 解析器
```vim
:TSInstallInfo
```
选择需要的语法解析器进行安装。

## ⌨️ 核心键位映射

### 基础导航（移动优化）
| 键位 | 功能 | 描述 |
|------|------|------|
| `<C-h/j/k/l>` | 窗口导航 | 快速切换窗口 |
| `<A-h/l>` | 缓冲区切换 | 切换文件缓冲区 |
| `<leader>h` | 取消高亮 | 清除搜索结果 |
| `<leader>Q` | 智能退出 | 检查未保存文件 |

### LSP 功能组 (`<leader>p`)
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>pr` | 重命名符号 | LSP 重命名 |
| `<leader>pa` | 代码操作 | 显示可用操作 |
| `<leader>pd` | 跳转定义 | 跳转到定义 |
| `<leader>pR` | 查找引用 | 查找所有引用 |
| `<leader>ph` | 悬停信息 | 显示文档 |
| `<leader>pf` | 格式化 | 格式化代码 |

### 搜索功能 (`<leader>f`)
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>ff` | 文件搜索 | 查找文件 |
| `<leader>fg` | 内容搜索 | 全局搜索 |
| `<leader>fb` | 缓冲区列表 | 打开的文件 |
| `<leader>fh` | 帮助搜索 | 搜索帮助文档 |

### Termux 终端 (`<leader>t`)
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>t` | 横向终端 | 打开 bash 终端 |
| `<leader>tt` | Termux 终端 | 专用 Termux 集成 |
| `<C-\>` | 切换终端 | ToggleTerm 浮动终端 |

### 配置管理 (`<leader>C`)
| 键位 | 功能 | 描述 |
|------|------|------|
| `<leader>Cc` | 编辑配置 | 编辑 init.lua |
| `<leader>Cv` | 编辑键位 | 编辑键位配置 |
| `<leader>Cp` | 编辑插件 | 编辑插件配置 |
| `<leader>Cr` | 重载配置 | 重新加载配置 |
| `<leader>Cm` | Mason 管理器 | 管理 LSP 服务器 |

## 📁 配置结构

```
~/.config/nvim/
├── init.lua                    # 主入口文件
├── lua/
│   ├── config/
│   │   ├── autocmds.lua        # 自动命令（Termux 优化）
│   │   ├── keybindings.lua     # 核心键位映射
│   │   ├── keymaps.lua         # 额外键位配置
│   │   ├── lazy.lua            # 插件管理器配置
│   │   └── options.lua         # Neovim 选项（Termux 优化）
│   └── plugins/
│       ├── blink-cmp.lua       # 补全系统（Termux 优化）
│       ├── bufferline.lua      # 标签栏（Termux 优化）
│       ├── community.lua       # 社区推荐插件
│       ├── debugger.lua        # 调试器（Termux 适配）
│       ├── dev-tools.lua       # 开发工具
│       ├── editor-core.lua     # 编辑器核心功能
│       ├── editor-design.lua   # 编辑器界面设计
│       ├── lsp-config.lua      # LSP 配置（Termux 优化）
│       ├── lsp-ui.lua          # LSP UI 增强
│       ├── mason.lua           # LSP 管理器
│       ├── snack.lua           # UI 增强
│       ├── theme.lua           # 主题配置（Termux 优化）
│       ├── treesitter.lua      # 语法高亮（Termux 优化）
│       └── which-key.lua       # 键位提示
├── snippets/                   # 代码片段
│   ├── lua.lua
│   ├── python.lua
│   └── ...
└── LSP/                        # 语言特定配置
    ├── python.lua
    ├── lua.lua
    └── ...
```

## 🔧 Termux 特定优化

### 性能优化
- **减少内存占用** - 优化插件加载策略
- **降低 CPU 使用** - 智能的语法解析和补全策略
- **快速响应** - 优化的更新时间和超时设置
- **大文件处理** - 智能的大文件检测和优化

### 界面优化
- **触摸友好** - 更大的点击区域和触摸手势
- **屏幕适配** - 适配各种屏幕尺寸
- **色彩优化** - Termux 终端色彩优化
- **字体支持** - 等宽字体和 Nerd Font 支持

### 功能优化
- **终端集成** - 深度集成 Termux 终端
- **Shell 支持** - 支持 bash 和 zsh
- **路径处理** - 优化的路径解析和处理
- **工具检测** - 智能的工具路径检测

## 🛠️ 开发语言支持

### 🐍 Python 开发
- **LSP 支持** - pyright/ruff 语言服务器
- **调试支持** - debugpy 调试器
- **格式化** - ruff/black 代码格式化
- **代码片段** - 丰富的 Python 代码片段

### 🔧 C/C++ 开发
- **LSP 支持** - clangd 语言服务器
- **调试支持** - gdb/lldb 调试器
- **格式化** - clang-format 代码格式化
- **编译集成** - Makefile/CMake 支持

### 🌐 Web 开发
- **JavaScript/TypeScript** - tsserver 支持
- **HTML/CSS** - 完整的 Web 开发支持
- **格式化** - prettier 代码格式化
- **调试支持** - Chrome/Firefox 调试器

### 📝 文档编写
- **Markdown** - 完整的 Markdown 支持
- **LaTeX** - LaTeX 文档编写支持
- **实时预览** - 文档实时预览功能
- **导出支持** - PDF/HTML 导出支持

## 🎨 主题和外观

配置支持多种主题，针对 Termux 环境优化：
- **TokyoNight** - 深色主题，护眼模式
- **Catppuccin** - 温暖色彩主题
- **OneDark** - 经典 OneDark 主题
- ** Gruvbox** - 复古风格主题

### Neovide GUI 支持（可选）
如果使用 Neovide GUI，包含专门的优化设置：
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

3. **性能问题**
   ```vim
   :checkhealth
   ```

4. **Termux 特定问题**
   ```bash
   # 检查 Termux 版本
   termux-info
   # 或者安装 fastfetvh
   fastfetch
   
   # 更新 Termux
   pkg update && pkg upgrade
   ```

### Termux 性能调优

```bash
# 优化 Termux 性能
termux-wake-lock  # 防止休眠

# 设置合适的内存限制
export MALLOC_ARENA_MAX=2

# 优化 Git 性能
git config --global core.preloadindex true
git config --global core.fscache true
git config --global gc.auto 256
```

## 📊 性能监控

配置包含多项性能监控和优化：
- 启动时间监控
- 内存使用监控
- 插件性能分析
- 大文件优化

## 🤝 贡献

欢迎提交 Issues 和 Pull Requests 来改进这个配置！特别欢迎：
- Termux 环境优化建议
- 移动设备使用体验改进
- 性能优化方案
- 新的语言支持

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

感谢以下项目和社区：
- [LazyVim](https://github.com/LazyVim/LazyVim) - 现代 Neovim 配置框架
- [Termux](https://termux.dev/) - Android 终端模拟器
- [folke/lazy.nvim](https://github.com/folke/lazy.nvim) - 插件管理器
- [Saghen/blink.cmp](https://github.com/Saghen/blink.cmp) - 高性能补全
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - 语法解析
- 以及所有为移动开发环境贡献的开发者们

---

⭐ 如果这个配置对您有帮助，请给个星星支持！分享您在 Termux 上的开发体验！
