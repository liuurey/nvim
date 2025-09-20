-- 雪律：安全 require 模块，防止模块加载失败导致整个配置崩溃
-- 使用方式：require('lib.safe_require').safe_require('module_name')

local M = {}

---@param module_name string 模块名称
---@return any|nil 模块对象或 nil（如果加载失败）
function M.safe_require(module_name)
	local ok, module = pcall(require, module_name)
	if not ok then
		vim.notify("Failed to load module: " .. module_name .. " - " .. tostring(module), vim.log.levels.WARN)
		return nil
	end
	return module
end

return M