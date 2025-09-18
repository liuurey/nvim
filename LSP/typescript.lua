-- TypeScript 文件类型特定配置

-- 继承 JavaScript 配置
-- 加载 JavaScript 配置
local js_config_path = vim.fn.stdpath('config') .. '/LSP/javascript.lua'
if vim.fn.filereadable(js_config_path) == 1 then
  dofile(js_config_path)
end

-- TypeScript 特有设置可以在这里添加
-- 例如：特定的键位映射或者编译选项