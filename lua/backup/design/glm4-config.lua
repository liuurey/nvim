-- GLM-4 配置文件
-- 基于 avante.nvim 官方规范
-- API地址: https://open.bigmodel.cn/api/paas/v4
-- 模型: glm-4-flash
-- API密钥: 033e984ae7294bac8a9cd62f93c3830d.GAXKvN5oWflJ5GR6

local M = {}

-- GLM-4 API 配置
M.api_config = {
  endpoint = "https://open.bigmodel.cn/api/paas/v4",
  model = "glm-4-flash",
  api_key = "033e984ae7294bac8a9cd62f93c3830d.GAXKvN5oWflJ5GR6",
  timeout = 30000, -- 30秒超时
  max_tokens = 4096,
  temperature = 0.3,
  top_p = 0.7,
}

-- 可用模型列表
M.available_models = {
  "glm-4-flash",
  "glm-4",
  "glm-4-air",
  "glm-4-airx",
  "glm-4v",
  "glm-3-turbo",
}

-- 模型信息
M.model_info = {
  ["glm-4-flash"] = {
    description = "GLM-4 快速版，适合日常编程任务",
    max_tokens = 8192,
    context_length = 128000,
  },
  ["glm-4"] = {
    description = "GLM-4 标准版，综合能力最强",
    max_tokens = 8192,
    context_length = 128000,
  },
  ["glm-4-air"] = {
    description = "GLM-4 轻量版，平衡性能和成本",
    max_tokens = 8192,
    context_length = 128000,
  },
  ["glm-4-airx"] = {
    description = "GLM-4 轻量增强版",
    max_tokens = 8192,
    context_length = 128000,
  },
  ["glm-4v"] = {
    description = "GLM-4 视觉版，支持图像理解",
    max_tokens = 8192,
    context_length = 128000,
  },
  ["glm-3-turbo"] = {
    description = "GLM-3 涡轮增压版",
    max_tokens = 4096,
    context_length = 32000,
  },
}

-- GLM-4 提供商模板
M.provider_template = {
  endpoint = M.api_config.endpoint,
  model = M.api_config.model,
  api_key_name = "GLM4_API_KEY",
  timeout = M.api_config.timeout,
  max_tokens = M.api_config.max_tokens,
  temperature = M.api_config.temperature,
  top_p = M.api_config.top_p,
  
  -- 请求参数解析函数
  parse_curl_args = function(opts, code_opts)
    local api_key = os.getenv(opts.api_key_name) or M.api_config.api_key
    
    return {
      url = opts.endpoint .. "/chat/completions",
      headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bearer " .. api_key,
        ["Accept"] = "application/json",
      },
      body = {
        model = opts.model,
        messages = {
          {
            role = "system",
            content = "你是一个专业的编程助手，擅长代码分析、优化和解释。"
          },
          {
            role = "user",
            content = code_opts.question or "请分析这段代码"
          }
        },
        temperature = opts.temperature,
        top_p = opts.top_p,
        max_tokens = opts.max_tokens,
        stream = false,
      },
      timeout = opts.timeout,
    }
  end,
  
  -- 响应解析函数
  parse_response = function(data_stream, event_state, opts)
    if event_state == "done" then
      opts.on_complete()
      return
    end
    
    if data_stream == nil or data_stream == "" then
      return
    end
    
    local ok, json = pcall(vim.json.decode, data_stream)
    if not ok then
      opts.on_complete("JSON解析错误: " .. tostring(json))
      return
    end
    
    -- 处理 GLM-4 响应格式
    if json.choices and json.choices[1] and json.choices[1].message then
      local content = json.choices[1].message.content
      if content then
        opts.on_chunk(content)
      end
    elseif json.error then
      opts.on_complete("API错误: " .. tostring(json.error.message))
    end
  end,
}

-- 设置环境变量
function M.setup_environment()
  vim.env.GLM4_API_KEY = M.api_config.api_key
end

-- 获取 avante 配置
function M.get_avante_config()
  return {
    -- 提供商配置
    provider = "glm4",
    
    -- 自定义 GLM-4 提供商
    providers = {
      glm4 = M.provider_template,
    },
    
    -- 行为配置
    behaviour = {
      auto_suggestions = false, -- 关闭自动建议
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
    },
    
    -- 键位映射
    mappings = {
      ask = "<leader>ga",
      edit = "<leader>ge",
      refresh = "<leader>gr",
      diff = {
        ours = "co",
        theirs = "ct",
        both = "cb",
        cursor = "cc",
        next = "]x",
        prev = "[x",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
      submit = {
        normal = "<CR>",
        insert = "<C-s>",
      },
      toggle = {
        debug = "<leader>gd",
        hint = "<leader>gh",
      },
    },
    
    -- 提示配置
    prompts = {
      system = {
        role = "system",
        content = "你是一个专业的编程助手，擅长代码分析、优化和解释。",
      },
    },
    
    -- 窗口配置
    windows = {
      position = "right",
      wrap = true,
      width = 50,
      sidebar_header = {
        enabled = true,
        align = "center",
        rounded = true,
      },
      input = {
        prefix = "> ",
        height = 8,
      },
      edit = {
        border = "rounded",
      },
      ask = {
        floating = false,
        border = "rounded",
      },
    },
    
    -- 高亮配置
    highlights = {
      diff = {
        current = "DiffText",
        incoming = "DiffAdd",
      },
    },
    
    -- 调试配置
    debug = false,
    
    -- 缓存配置
    cache = {
      enabled = true,
      max_size = 100,
      ttl = 3600, -- 1小时
    },
  }
end

-- 验证 API 密钥
function M.validate_api_key()
  local key = M.api_config.api_key
  if not key or key == "" then
    return false, "API 密钥未设置"
  end
  
  -- 简单的格式验证
  if not key:match("^%w+%.%w+") or #key < 30 then
    return false, "API 密钥格式不正确"
  end
  
  return true, "API 密钥有效"
end

-- 获取模型信息
function M.get_model_info(model)
  return M.model_info[model] or {
    description = "未知模型",
    max_tokens = 4096,
    context_length = 32000,
  }
end

-- 更新 API 配置
function M.update_config(new_config)
  for k, v in pairs(new_config) do
    if M.api_config[k] ~= nil then
      M.api_config[k] = v
    end
  end
  
  -- 更新提供商模板
  M.provider_template.endpoint = M.api_config.endpoint
  M.provider_template.model = M.api_config.model
  M.provider_template.timeout = M.api_config.timeout
  M.provider_template.max_tokens = M.api_config.max_tokens
  M.provider_template.temperature = M.api_config.temperature
  M.provider_template.top_p = M.api_config.top_p
  
  -- 更新环境变量
  M.setup_environment()
end

-- 获取当前配置
function M.get_config()
  return vim.deepcopy(M.api_config)
end

return M