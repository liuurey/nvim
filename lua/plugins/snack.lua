return{
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = {
        enabled = true,
        preset = {
        header = [[
    ╔═══════════════════════════════════════════════════════════╗
    ║  ▓██████▓ ▓█████▄ ██▓███▓ ▓█████▄██   ██▓██████▓█████▄    ║
    ║  ██▓       ██▓ ▓██▓██▓███▓   ▓ ██▓ ▓██▓▓██ ██▓▓   ██▓ ▓██▓║
    ║  ▓█████▓ ▓█████▓▓██▓ ▓██▓ ▓██▓▓█████▓█████▓█████▓▓        ║
    ║       ▓██▓██▓ ▓██▓██▓   ▓▓██▓ ▓██▓▓██▓██▓     ▓██▓██▓ ▓██▓║
    ║  ▓██████▓▓██▓ ▓██▓██▓███▓▓██▓ ▓██▓▓██▓ ██▓██████▓▓██▓ ▓██▓║
    ║                   ⟨⟨⟨ SANINS NEOVIM ⟩⟩⟩                   ║
    ╚═══════════════════════════════════════════════════════════╝
        ]],
        keys = {
          -- 紧凑布局：图标 + 快捷键 + 描述
          { icon = "󰈞 ", key = "f", desc = "Find File", action = ":Telescope find_files" },
          { icon = "󰈔 ", key = "n", desc = "Neon File", action = ":ene | startinsert" },
          { icon = "󰊄 ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = "󰑓 ", key = "o", desc = "Restore Session", section = "session" },
          { icon = "󰏖 ", key = "s", desc = "Sanins Manager", action = ":Lazy" },
          { icon = "󰒕 ", key = "h", desc = "Health Check", action = ":checkhealth" },
          { icon = "󰔧 ", key = "t", desc = "TreeSitter Info", action = ":TSInstallInfo" },
          { icon = "󱌢 ", key = "m", desc = "Mason", action = ":Mason" },
          { icon = "󰒓 ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰃃 ", key = "x", desc = "Extras", action = ":LazyExtras" },
          { icon = "󰈆 ", key = "q", desc = "Quit", action = ":qa" },
        }
      },

        sections = {
    { section = "header",gap =0},
    { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
    { section = "startup" },
    --      {
    --       pane = 2,
    --       icon = "󰢵 ",                  
    --       title = "Pokemon",           
    --       section = "terminal",
    --       cmd = "krabby random  --no-title",  --sleep 100ms
    --       height = 10,        
    --       padding = 1,                    
    --     },
      
    { pane =2,icon = " ", key = "r",title = "Recent Files", section = "recent_files", indent = 2, padding = 1,action = function() Snacks.picker.recent() end},
    --  { pane =2,icon = " ", key = "r",title = "Recent Files", section = "recent_files", indent = 2, padding = 1,action = function()
    -- Snacks.picker.recent()
    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', false) end},
    { pane =2,icon = " ",key = "p", title = "Projects", section = "projects", indent = 2, padding = 1 ,action="vim.fn.chdir(project.path)"},
    
    {
      pane = 2,
      icon = " ",
      desc = "Browse Repo",
      padding = 1,
      key = "b",
      action = function()
        Snacks.gitbrowse()
      end,
    },
  },

},

    bigfile = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true,timeout = 3000,},
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    image = { enabled = true },
    terminal = {
      enabled = true,
      shell = "pwsh.exe",  -- 使用PowerShell Core替代cmd.exe
      winopts = {
        -- Windows特定配置
      },
    }, 
  },
}