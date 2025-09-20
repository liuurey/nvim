# GLM-4 AI 配置指南

## 概述

GLM-4 是智谱AI开发的大语言模型，本配置将其集成到 Neovim 的 AI 辅助开发工作流中，提供智能代码补全、解释、优化等功能。

## 配置组件

### 1. 核心补全集成 (`blink-cmp.lua`)
- **文件**: `lua/plugins/blink-cmp.lua`
- **功能**: 将 GLM-4 作为补全源集成到 blink-cmp
- **优先级**: score_offset = 1 (中等优先级)
- **触发**: 输入时自动触发，最小长度 2 字符

### 2. AI 工具集成 (`essential.lua`)
- **文件**: `lua/plugins/essential.lua`
- **集成插件**:
  - `grug-far.nvim`: 文件搜索替换 AI 助手
  - `diffview.nvim`: 冲突解决 AI 助手  
  - `neogit`: Git 提交信息 AI 生成

### 3. 专用配置模块 (`zhipu-ai.lua`)
- **文件**: `lua/plugins/zhipu-ai.lua`
- **功能**: 专用 GLM-4 配置和命令

## API 配置参数

```lua
{
  provider = "glm4",
  api_key = "033e984ae7294bac8a9cd62f93c3830d.GAXKvN5oWflJ5GR6",
  api_url = "https://open.bigmodel.cn/api/paas/v4",
  model = "glm-4-flash",
  temperature = 0.3,           -- 控制随机性 (0.0-1.0)
  max_tokens = 2048,           -- 最大响应长度
  timeout = 10000,             -- 请求超时 (毫秒)
  retry_count = 3,              -- 重试次数
  
  -- GLM-4 特定参数
  glm4_params = {
    top_p = 0.7,                -- 核心采样参数
    frequency_penalty = 0.1,     -- 频率惩罚
    presence_penalty = 0.1,      -- 存在惩罚
    safe_mode = true,            -- 安全模式
  }
}
```

## 使用命令

### 基础命令
- `:GLM4Chat [消息]`: AI 对话
- `:GLM4Explain`: 解释选中代码
- `:GLM4Complete`: 代码补全
- `:GLM4Optimize`: 代码优化
- `:GLM4Translate [文本]`: 智能翻译

### 快捷键映射
- `<leader>g4`: 打开 GLM-4 对话
- `<leader>g4e` (可视模式): 解释选中代码
- `<leader>g4o` (可视模式): 优化选中代码
- `<leader>g4t`: 翻译功能
- `<C-g>` (插入模式): 触发智能补全

## 高级功能

### 1. 上下文感知
```lua
context = {
  max_lines = 50,              -- 最大上下文行数
  include_comments = true,     -- 包含注释
  include_imports = true,      -- 包含导入语句
  include_function_signature = true,  -- 包含函数签名
}
```

### 2. 性能优化
```lua
performance = {
  debounce_delay = 300,        -- 防抖延迟
  min_trigger_length = 2,      -- 最小触发长度
  trigger_on_comment = false,  -- 注释中不触发
}
```

### 3. 缓存策略
```lua
cache = {
  enabled = true,               -- 启用缓存
  ttl = 300,                   -- 缓存时间 (秒)
  max_size = 100,              -- 最大缓存条目
}
```

### 4. 安全与隐私
```lua
security = {
  strip_sensitive_data = true, -- 移除敏感数据
  allowed_file_types = {       -- 允许的文件类型
    "cpp", "c", "h", "hpp", "python", "lua", 
    "javascript", "typescript", "json", "markdown", "tex"
  },
  blocked_patterns = {         -- 阻止的模式
    "password", "secret", "key", "token", "api_key"
  }
}
```

## 模块函数

### 配置管理
```lua
-- 获取当前配置
:lua print(vim.inspect(glm4.get_config()))

-- 更新配置
:lua glm4.update_config({ temperature = 0.5 })

-- 启用/禁用
:lua glm4.enable()
:lua glm4.disable()
```

## 环境变量

建议将 API 密钥存储为环境变量以提高安全性：

```bash
# Windows PowerShell
$env:GLM4_API_KEY="your-api-key-here"

# Linux/Mac
export GLM4_API_KEY="your-api-key-here"
```

然后在配置中引用：
```lua
api_key = os.getenv("GLM4_API_KEY")
```

## 故障排除

### 常见问题

1. **API 密钥无效**
   - 检查密钥格式：`xxx.xxx` 格式
   - 验证密钥是否激活
   - 检查网络连接

2. **请求超时**
   - 增加 `timeout` 值
   - 检查网络代理设置
   - 确认 API 地址正确

3. **补全不触发**
   - 检查 `min_trigger_length`
   - 确认文件类型在允许列表中
   - 查看 `:messages` 错误信息

4. **响应质量低**
   - 调整 `temperature` (0.1-0.3 更确定，0.7-1.0 更创意)
   - 增加 `max_tokens`
   - 优化上下文设置

### 调试模式

启用详细日志：
```lua
vim.g.glm4_debug = true
```

查看日志：
```
:messages
```

## 性能优化建议

### 1. 开发环境
- 启用缓存减少重复请求
- 合理设置防抖延迟
- 使用适当的温度参数

### 2. 大型项目
- 限制上下文大小
- 启用文件类型过滤
- 配置合理的超时时间

### 3. 网络优化
- 使用本地缓存
- 配置重试机制
- 考虑代理设置

## 与其他 AI 服务对比

| 特性 | GLM-4 | DeepSeek | Claude | OpenAI |
|------|--------|----------|---------|---------|
| 中文理解 | 优秀 | 良好 | 一般 | 一般 |
| 代码生成 | 良好 | 优秀 | 优秀 | 良好 |
| 响应速度 | 快速 | 中等 | 较慢 | 中等 |
| API 成本 | 较低 | 中等 | 较高 | 较高 |
| 安全过滤 | 严格 | 中等 | 宽松 | 中等 |

## 更新日志

### 2024-01-XX
- 初始 GLM-4 集成
- 基础补全功能
- 多插件支持

### 即将推出
- GLM-4-Pro 模型支持
- 流式响应
- 自定义提示模板
- 批量处理优化