-- blink.cmp configuration optimized for Termux/Android
-- Based on https://github.com/Saghen/blink.cmp

return {
  "saghen/blink.cmp",
  enabled = not vim.g.vscode, -- disable in vscode-neovim
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  event = { "InsertEnter", "CmdlineEnter" },
  version = "*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- cmdline completion
    cmdline = {
      keymap = {
        -- select and accept the first pre-selected item
        ["<CR>"] = { "select_and_accept", "fallback" },
      },
      completion = {
        -- don't preselect the first item, auto-insert the text of the selected item
        list = { selection = { preselect = false, auto_insert = true } },
        -- auto show completion menu only when typing commands
        menu = {
          auto_show = function(ctx)
            return vim.fn.getcmdtype() == ":"
          end,
        },
        -- don't show ghost text preview on current line
        ghost_text = { enabled = false },
        -- cmdline min keyword length configuration
        min_keyword_length = function(ctx)
          -- when typing a command, only show when the keyword is 3 characters or longer
          if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
            return 3
          end
          return 0
        end,
      },
    },

    -- keymaps
    keymap = {
      preset = "none",
      ["<S-space>"] = { "show", "show_documentation", "hide_documentation" },
      -- fallback will run the next non-blink keymap (default newline on Enter needed)
      ["<CR>"] = { "accept", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },

      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },

      ["<C-e>"] = { "snippet_forward", "select_next", "fallback" },
      ["<C-u>"] = { "snippet_backward", "select_prev", "fallback" },
    },

    signature = {
      enabled = true,
      -- Termux optimization: Reduce signature window for better performance
      window = {
        max_height = 5,
        border = "none",
      }
    },

    completion = {
      -- example: using 'prefix' for 'foo_|_bar' word will match 'foo_' (part before cursor)
      -- using 'full' will match 'foo__bar' (entire word)
      keyword = { range = "full" },
      -- show documentation when selecting completion items (0ms delay)
      documentation = { 
        auto_show = true, 
        auto_show_delay_ms = 0,
        -- Termux optimization: Reduce documentation window for better performance
        window = {
          max_height = 8,
          max_width = 60,
          border = "none",
        }
      },
      -- force: LSP docs priority, snippets don't auto-insert
      list = { selection = { preselect = false, auto_insert = false } },
      -- menu appearance configuration
      menu = {
        draw = {
          -- Termux optimization: Simplified menu for better performance
          columns = { { "kind_icon" }, { "label", gap = 1 } },
        },
        -- Termux optimization: Reduced max height for better performance
        max_height = 8,
        -- Termux optimization: No border for better performance
        border = "none",
      },
    },

    -- enable/disable for specific filetypes
    enabled = function()
      return not vim.tbl_contains({
        -- "lua",
        -- "markdown"
      }, vim.bo.filetype) and vim.bo.buftype ~= "prompt" and vim.b.completion ~= false
    end,

    appearance = {
      -- set fallback highlight groups to nvim-cmp's highlight groups
      -- useful when your theme doesn't support blink.cmp
      use_nvim_cmp_as_default = true,
      -- set "Nerd Font Mono" to "mono", "Nerd Font" to "normal"
      -- adjust spacing to ensure icons align
      nerd_font_variant = "mono",
      -- Termux optimization: Disable icons for better performance
      icons = false,
    },

    -- default list of enabled providers
    sources = {
      default = {
        "lsp",
        "path",
        "buffer",
      },
      providers = {
        -- score_offset sets priority (higher number = higher priority)
        buffer = { 
          score_offset = 4,
          -- Termux optimization: Limit buffer completions for better performance
          max_items = 20,
          -- Termux optimization: Increase min_keyword_length to reduce noise
          min_keyword_length = 3,
        },
        path = { 
          score_offset = 3,
          -- Termux optimization: Limit path completions for better performance
          max_items = 15,
          -- Termux optimization: Increase min_keyword_length to reduce noise
          min_keyword_length = 3,
        },
        snippets = {
          score_offset = 1, -- lowest priority, doesn't interfere with LSP
          -- Termux optimization: Limit snippet completions for better performance
          max_items = 10,
          -- Termux optimization: Increase min_keyword_length to reduce noise
          min_keyword_length = 2,
        },
        lsp = { 
          score_offset = 10, -- highest priority
          -- Termux optimization: Limit LSP completions for better performance
          max_items = 30,
          -- Termux optimization: Increase min_keyword_length to reduce noise
          min_keyword_length = 2,
        },
      },
    },
    
    -- Termux-specific optimizations
    performance = {
      -- Reduce debounce time for better responsiveness on mobile devices
      debounce_time = 50,
      -- Throttle frequent updates to improve performance
      throttle_time = 30,
      -- Max items to show in completion menu (reduced for Termux)
      max_items = 50,
      -- Termux optimization: Reduce memory usage
      max_cached_completion_items = 100,
      -- Termux optimization: Disable fuzzy matching for better performance
      fuzzy = {
        enable = false,
      },
      -- Termux optimization: Reduce update frequency
      update_cooldown = 100,
    }
  },
  opts_extend = { "sources.default" },
}