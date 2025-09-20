-- 编辑器设计和展示插件
-- 提供 Markdown 渲染、Git 可视化、协作工具等

return {
  -- Markdown 富文本渲染
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'md', 'markdown.mdx' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons', -- 可选，提供图标支持
    },
    opts = {
      preset = 'lazy',
      enabled = true,
      
      -- 标题配置
      heading = {
        enabled = true,
        sign = true,
        position = 'overlay',
        icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
        signs = { '󰫎 ', '󰫎 ', '󰫎 ', '󰫎 ', '󰫎 ', '󰫎 ' },
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = false,
        above = ' ',
        below = ' ',
        backgrounds = {
          'RenderMarkdownH1Bg',
          'RenderMarkdownH2Bg',
          'RenderMarkdownH3Bg',
          'RenderMarkdownH4Bg',
          'RenderMarkdownH5Bg',
          'RenderMarkdownH6Bg',
        },
        foregrounds = {
          'RenderMarkdownH1Fg',
          'RenderMarkdownH2Fg',
          'RenderMarkdownH3Fg',
          'RenderMarkdownH4Fg',
          'RenderMarkdownH5Fg',
          'RenderMarkdownH6Fg',
        },
      },
      
      -- 代码块配置
      code = {
        enabled = true,
        sign = false,
        style = 'full',
        position = 'left',
        language_pad = 0,
        left_pad = 2,
        right_pad = 2,
        width = 'full',
        above = ' ',
        below = ' ',
        highlight = 'RenderMarkdownCode',
        highlight_inline = 'RenderMarkdownCodeInline',
      },
      
      -- 分隔线配置
      dash = {
        enabled = true,
        icon = '─',
        width = 80,
        highlight = 'RenderMarkdownDash',
      },
      
      -- 列表配置
      bullet = {
        enabled = true,
        icons = { '●', '○', '◆', '◇', '►', '◄' },
        left_pad = 0,
        right_pad = 0,
        highlight = 'RenderMarkdownBullet',
      },
      
      -- 复选框配置
      checkbox = {
        enabled = true,
        position = 'inline',
        unchecked = {
          icon = '󰄱 ',
          highlight = 'RenderMarkdownUnchecked',
        },
        checked = {
          icon = '󰱒 ',
          highlight = 'RenderMarkdownChecked',
        },
      },
      
      -- 引用配置
      quote = {
        enabled = true,
        icon = '▋',
        repeat_linebreak = false,
        highlight = 'RenderMarkdownQuote',
      },
      
      -- 表格配置
      pipe_table = {
        enabled = true,
        preset = 'round',
        style = 'full',
        cell = 'padding',
        alignment = 'full',
        padding = 1,
        min_width = 0,
        border = {
          '┌', '┬', '┐',
          '├', '┼', '┤',
          '└', '┴', '┘',
          '│', '─',
        },
        highlight = 'RenderMarkdownTable',
      },
      
      -- 标注配置
      callout = {
        enabled = true,
        note = '󰋽 ',
        tip = '󰌶 ',
        important = '󰅾 ',
        warning = '󰀪 ',
        caution = '󰳦 ',
        abstract = '󰨸 ',
        info = '󰋽 ',
        todo = '󰗡 ',
        success = '󰄬 ',
        question = '󰘥 ',
        failure = '󰅖 ',
        danger = '󱐌 ',
        bug = '󰨰 ',
        example = '󰉹 ',
        quote = '󱉫 ',
      },
      
      -- 链接配置
      link = {
        enabled = true,
        image = '󰥶 ',
        email = '󰀃 ',
        hyperlink = '󰌹 ',
        highlight = 'RenderMarkdownLink',
      },
      
      -- 数学公式配置
      latex = {
        enabled = true,
        converter = 'latex2text',
        highlight = 'RenderMarkdownMath',
      },
      
      -- 窗口选项
      win_options = {
        conceallevel = {
          default = 2,
          rendered = 3,
        },
        concealcursor = {
          default = '',
          rendered = 'nc',
        },
      },
      
      -- 文件类型
      file_types = { 'markdown', 'markdown.mdx' },
      render_modes = { 'n', 'c', 't' },
      anti_conceal = {
        ignore = { 'html', 'html_inline', 'latex', 'latex_inline', 'code_inline' },
      },
    },
  },
}