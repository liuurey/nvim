-- 雪律：安全 augroup 删除拦截器，专治 E367
-- 使用方式：在加载 snacks.nvim 之前 require('lib.safe_augroup').protect()

local M = {}

---@param bufnr? number 仅对指定 buffer 生效，nil 则全局
function M.protect(bufnr)
  -- 保存原函数
  local orig = vim.api.nvim_del_augroup_by_id

  -- 重写 API
  vim.api.nvim_del_augroup_by_id = function(id)
    -- 若传入的是数字且对应 group 已被标记为 "--Deleted--"，则跳过
    local ok, name = pcall(vim.api.nvim_get_autocmds, { group = id })
    if not ok or (name and name[1] and name[1].group_name == '--Deleted--') then
      return -- 静默忽略
    end
    -- 否则正常调用
    return orig(id)
  end
end

return M