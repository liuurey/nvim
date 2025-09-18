return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = function(ctx)
      return ctx.plugin and 0 or 400
    end,
    filter = function(mapping)
      -- 过滤掉可能导致冲突的映射
      local key = mapping.lhs
      
      -- 不为单个字母创建 which-key 组（除了 leader 键）
      if #key == 1 and key ~= " " then
        return false
      end
      
      -- 过滤冲突的组定义
      local conflicting_patterns = {
        "^g$",      -- vim 原生 g 命令
        "^s$",      -- substitute 命令
        "^gr$",     -- references
        "^gc$",     -- comment
      }
      
      for _, pattern in ipairs(conflicting_patterns) do
        if key:match(pattern) then
          return false
        end
      end
      
      return true
    end,
    -- 不在这里定义 spec，由 keybindings.lua 统一管理，避免重复
    spec = {},
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
    layout = {
      spacing = 3,
    },
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}