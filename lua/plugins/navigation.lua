-- 导航和移动插件集合
-- 包含：tmux导航、区域选择、Doxygen文档生成等
-- 从 extra.lua 重命名而来
return {
  -- tmux导航集成
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate Left" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate Down" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate Up" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate Right" },
    },
  },
  
  -- 代码统计工具
  -- {
  --   "wakatime/vim-wakatime",
  --   event = { "BufReadPost", "BufNewFile" },
  -- },

  -- {
  --   "kylechui/nvim-surround",
  --   version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
  --   event = { "BufReadPost", "BufNewFile" },
  --   config = function()
  --       require("nvim-surround").setup({
  --           -- Configuration here, or leave empty to use defaults
  --       })
  --   end
  -- },
  
  -- 区域选择扩展
  {
    "terryma/vim-expand-region",
    keys = {
      { "+", desc = "Expand region" },
      { "_", desc = "Shrink region" },
    },
  },
  
  -- Doxygen文档生成
  {
    "vim-scripts/DoxygenToolkit.vim",
    ft = { "c", "cpp", "h", "hpp" },
    keys = {
      {
        "<leader>cD",
        "<cmd>Dox<CR>",
        mode = "n",
        desc = "Generate Doxygen documentation"
      }
    }
  }
}
