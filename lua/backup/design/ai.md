# blink.ai
```lua
avante = {
					module = "blink-cmp-avante",
					name = "Avante",
					score_offset = 1, -- AI补全优先级适中
					opts = {
						-- GLM-4 配置支持
						glm4 = {
							enabled = true,
							provider = "glm4",
							api_key = os.getenv("GLM4_API_KEY") or "",
							api_url = "https://open.bigmodel.cn/api/paas/v4",
							model = "glm-4-flash",
							temperature = 0.3,
							max_tokens = 2048,
							timeout = 10000,
							retry_count = 3,
						},
					},
				},
				glm4 = {
					module = "blink-cmp-avante",
					name = "GLM-4",
					score_offset = 1, -- AI补全优先级适中
					opts = {
						enabled = true,
						provider = "glm4",
						api_key = os.getenv("ZHIPUAI_API_KEY") or "",
						api_url = "https://open.bigmodel.cn/api/paas/v4", 
						model = "glm-4-flash",
						temperature = 0.3,
						max_tokens = 2048,
						timeout = 10000,
						retry_count = 3,
						-- GLM-4 特定参数
						glm4_params = {
							top_p = 0.7,
							frequency_penalty = 0.1,
							presence_penalty = 0.1,
							safe_mode = true,
						},
					},
				},
			},
            ```
# blink.ai 配置
```
dependencies = {
		"xzbdmw/colorful-menu.nvim",
		"rafamadriz/friendly-snippets",
		"Kaiser-Yang/blink-cmp-avante",
	},
    event = "BufReadPost,BufNewFile",
```
