return {
  -- 标签栏增强
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
      }
    },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Delete other buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete buffers to the left" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = {
      options = {
        mode = "buffers",
        always_show_bufferline = false,
        offsets = {
          { filetype = "NvimTree", text = "文件浏览器", highlight = "Directory", text_align = "left" },
        },
      },
    },
  },
  
  -- Git 状态显示
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" }, change = { text = "│" },
        delete = { text = "_" }, topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  
  -- 智能文本移动增强
  {
    'chrisgrieser/nvim-spider',
    keys = {
      -- 直接替换原生移动键，提高效率
      -- 'w': 向前移动到单词开头，智能识别代码结构和标识符
      { 'w', '<cmd>lua require("spider").motion("w")<CR>', mode = { 'n', 'o', 'x' }, desc = '智能向前移动(单词开头)' },
      
      -- 'e': 向前移动到单词结尾，处理驼峰、下划线等复合词
      { 'e', '<cmd>lua require("spider").motion("e")<CR>', mode = { 'n', 'o', 'x' }, desc = '智能向前移动(单词结尾)' },
      
      -- 'b': 向后移动到单词开头，适应各种编程语言的标识符规则
      { 'b', '<cmd>lua require("spider").motion("b")<CR>', mode = { 'n', 'o', 'x' }, desc = '智能向后移动(单词开头)' },
      
      -- 'ge': 向后移动到单词结尾，提供完整的移动体验
      { 'ge', '<cmd>lua require("spider").motion("ge")<CR>', mode = { 'n', 'o', 'x' }, desc = '智能向后移动(单词结尾)' },
    },
    opts = {
      -- 跳过不重要的标点符号，更符合编程习惯
      skipInsignificantPunctuation = true,
      
      -- 为特定文件类型定制移动模式
      customPatterns = {
        markdown = {
          -- Markdown文档中的句子移动模式，便于文档编辑
          sentence = [[([.!?]|\n\n)+\s*]],
        },
        -- 可以在此添加其他文件类型的自定义模式
      },
    },
  }
}
