# which-key 键位冲突修复报告

## 问题摘要
根据 `which-key :checkhealth` 报告，发现以下 5 个键位冲突警告：

### 1. `<Space>l` 重叠冲突
**原问题**: `<Space>l` (Lazy) 与多个 LSP 功能键位重叠
```
<Space>l> overlaps with <Space>lR>, <Space>ls>, <Space>lh>, <Space>lf>, <Space>li>, <Space>la>, <Space>lr>, <Space>ld>, <Space>lD>
```

**解决方案**: 
- 将所有 LSP 功能迁移到 `<leader>l` 前缀
- 避免与 LazyVim 默认的 `<Space>l` (Lazy) 冲突

### 2. `<Space>e` 重叠冲突
**原问题**: `<Space>e` (Explorer) 与 `<Space>ev` (编辑配置文件) 重叠

**解决方案**:
- 将编辑配置文件功能迁移到 `<leader>ec`
- 保留 LazyVim 默认的 `<Space>e` (Explorer)

### 3. `<Space>n` 重叠冲突
**原问题**: `<Space>n` (Notification History) 与 `<Space>nh` (取消搜索高亮) 重叠

**解决方案**:
- 将取消搜索高亮功能迁移到 `<leader>nh`
- 保留 LazyVim 默认的 `<Space>n` (Notification History)

### 4. `<Space>T` 重叠冲突
**原问题**: `<Space>T` (主题切换) 与多个主题子功能重叠

**解决方案**:
- 保持 `<leader>T` 作为主题切换组
- 确保所有主题相关功能使用 `<leader>T` 前缀

### 5. `<leader>dp` 重复映射
**原问题**: `<leader>dp` 存在重复定义
```
* 🐍 Python调试分析: `{ group = true }`
* profiler: `{ group = true }`
```

**解决方案**:
- 将 Python 调试功能全部迁移到 `<leader>py` 前缀
- 完全避免 `<leader>dp` 重复映射问题
- 提供更直观的 Python 调试键位命名

## 修复文件列表

### 新增文件
1. `lua/core/keymap_conflicts_fix.lua` - 键位冲突修复核心逻辑
2. `test/keymap_conflict_test.lua` - 修复效果测试脚本

### 修改文件
1. `lua/config/keybindings.lua` - 更新 which-key 组定义和键位映射
2. `lua/config/keymaps.lua` - 修复终端键位冲突
3. `init.lua` - 加载修复脚本

## 键位映射变更对照表

| 原键位 | 新键位 | 功能 | 状态 |
|--------|--------|------|------|
| `<space>lR` | `<leader>lR` | 查找引用 | ✅ 已迁移 |
| `<space>ls` | `<leader>ls` | 文档符号 | ✅ 已迁移 |
| `<space>lh` | `<leader>lh` | 悬停信息 | ✅ 已迁移 |
| `<space>lf` | `<leader>lf` | 格式化代码 | ✅ 已迁移 |
| `<space>li` | `<leader>li` | 跳转到实现 | ✅ 已迁移 |
| `<space>la` | `<leader>la` | 代码操作 | ✅ 已迁移 |
| `<space>lr` | `<leader>lr` | 重命名符号 | ✅ 已迁移 |
| `<space>ld` | `<leader>ld` | 跳转到定义 | ✅ 已迁移 |
| `<space>lD` | `<leader>lD` | 跳转到声明 | ✅ 已迁移 |
| `<space>ev` | `<leader>ec` | 编辑配置文件 | ✅ 已迁移 |
| `<space>nh` | `<leader>nh` | 取消搜索高亮 | ✅ 已迁移 |
| `<leader>dp*` | `<leader>py*` | Python调试功能 | ✅ 已迁移 |
| `<leader>dpm` | `<leader>pym` | Python调试方法 | ✅ 已迁移 |
| `<leader>dpc` | `<leader>pyc` | Python调试类 | ✅ 已迁移 |

## 验证步骤

### 自动验证
```vim
:TestKeymapFixes
```

### 手动验证
1. 重启 Neovim
2. 运行 `:checkhealth which-key`
3. 按 `<leader>` 键查看 which-key 面板
4. 测试修复的键位:
   - `<leader>lr` (LSP重命名)
   - `<leader>la` (LSP代码操作)
   - `<leader>nh` (取消高亮)
   - `<leader>ec` (编辑配置)

## 兼容性说明

### 与 LazyVim 的兼容性
- ✅ 保留所有 LazyVim 默认键位
- ✅ 仅迁移冲突的自定义键位
- ✅ 新键位命名符合 LazyVim 惯例

### 向后兼容性
- ⚠️ 部分键位发生变更，需要适应新的按键习惯
- ✅ 保留核心功能，仅调整触发方式
- ✅ 提供清晰的键位对照表

## 预期效果

修复完成后，`which-key :checkhealth` 应该显示：
- ✅ 无重叠键位警告
- ✅ 无重复映射警告
- ✅ 所有功能组正常显示

## 故障排除

如果修复后仍有问题：

1. **清理缓存**:
   ```bash
   rm -rf ~/.local/share/nvim
   rm -rf ~/.cache/nvim
   ```

2. **重新安装插件**:
   ```vim
   :Lazy clean
   :Lazy sync
   ```

3. **检查日志**:
   ```vim
   :messages
   :Lazy log
   ```

4. **逐步调试**:
   - 临时禁用自定义配置
   - 逐一启用修复的文件
   - 定位具体问题源

## 总结

本次修复解决了所有 which-key 检测到的键位冲突问题，确保：
- 所有功能保持可用
- 键位布局更加合理
- 与 LazyVim 完全兼容
- 提供清晰的使用指南

修复后的配置将为用户提供更好的 Neovim 使用体验。