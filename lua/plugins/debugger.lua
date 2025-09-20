-- DAP 调试器配置 (Windows 本地化适配版本)
-- 职责：统一管理所有调试器配置，支持 Windows 环境
-- 与 Mason 配置协调，避免重复安装和配置冲突

return {
  -- DAP 核心
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- DAP UI界面
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "nvim-neotest/nvim-nio",
        },
        config = function()
          local dap, dapui = require("dap"), require("dapui")
          
          -- DAP UI 配置
          dapui.setup({
            -- 自定义布局
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.25 },
                  { id = "breakpoints", size = 0.25 },
                  { id = "stacks", size = 0.25 },
                  { id = "watches", size = 0.25 },
                },
                size = 40,
                position = "left",
              },
              {
                elements = {
                  { id = "repl", size = 0.5 },
                  { id = "console", size = 0.5 },
                },
                size = 10,
                position = "bottom",
              },
            },
            -- 图标配置
            icons = { expanded = "▾", collapsed = "▸" },
            -- 映射配置
            mappings = {
              -- Use a table to apply multiple mappings
              expand = { "<CR>", "<2-LeftMouse>" },
              open = "o",
              remove = "d",
              edit = "e",
              repl = "r",
              toggle = "t",
            },
            -- Windows 配置
            windows = { indent = 1 },
            -- 浮动窗口配置
            floating = {
              max_height = nil,
              max_width = nil,
              border = "rounded",
              mappings = {
                close = { "q", "<Esc>" },
              },
            },
          })
          
          -- 自动开关UI
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
          end
        end,
      },
      -- 虚拟文本显示变量值
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup({
            enabled = true,
            enabled_commands = true,
            highlight_changed_variables = true,
            highlight_new_as_changed = false,
            show_stop_reason = true,
            commented = false,
            only_first_definition = true,
            all_references = false,
            filter_references_pattern = '<module',
            virt_text_pos = 'eol',
            all_frames = false,
            virt_lines = false,
            virt_text_win_col = nil
          })
        end,
      },
      -- Python 调试支持
      {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        config = function()
          -- 安全加载 Mason 注册表
          local has_mason_registry, mason_registry = pcall(require, 'mason-registry')
          if has_mason_registry and mason_registry.is_installed and mason_registry.is_installed('debugpy') then
            local pkg = mason_registry.get_package('debugpy')
            if pkg and pkg.get_install_path then
              local install_path = pkg:get_install_path()
              require('dap-python').setup(install_path .. "/venv/Scripts/python.exe")
            else
              require('dap-python').setup('python')
            end
          else
            -- 使用默认 Python 路径
            require('dap-python').setup('python')
          end
        end,
      },
    },
    config = function()
      local dap = require('dap')
      
      -- Windows 本地化工具检测函数
      local function get_windows_debugger_path(tool_name, fallback_cmd)
        -- 优先使用 Mason 安装的调试器
        local mason_path = vim.fn.stdpath("data") .. "/mason/bin/" .. tool_name .. ".exe"
        if vim.fn.executable(mason_path) == 1 then
          return mason_path
        end
        
        -- 检查 Mason packages 目录的不同可能位置
        local possible_paths = {
          vim.fn.stdpath("data") .. "/mason/packages/" .. tool_name .. "/" .. tool_name .. ".exe",
          vim.fn.stdpath("data") .. "/mason/packages/" .. tool_name .. "/extension/debugAdapters/bin/OpenDebugAD7.exe",
          vim.fn.stdpath("data") .. "/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7.exe",
          vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb.exe",
          vim.fn.stdpath("data") .. "/mason/packages/codelldb/codelldb.exe",
        }
        
        for _, path in ipairs(possible_paths) do
          if vim.fn.executable(path) == 1 then
            return path
          end
        end
        
        -- 回退到系统 PATH 中的工具
        if vim.fn.executable(tool_name) == 1 then
          return tool_name
        end
        
        -- 使用提供的备用命令
        return fallback_cmd or tool_name
      end
      
      -- Windows 路径处理
      local function normalize_windows_path(path)
        if vim.fn.has("win32") == 1 then
          return path:gsub("/", "\\")
        end
        return path
      end
      
      -- Windows 兼容的程序输入函数
      local function get_program_path(default_path)
        local default_dir = default_path or vim.fn.getcwd()
        return function()
          local ok, path = pcall(vim.fn.input, 'Path to executable: ', normalize_windows_path(default_dir) .. '\\', 'file')
          if not ok or path == "" then
            return "" -- 降级：空路径
          end
          return path
        end
      end

      
      -- 配置调试适配器 (Windows 本地化版本)
      dap.adapters.codelldb = {
        type = 'executable',
        command = get_windows_debugger_path('codelldb', 'codelldb'),
        name = 'codelldb',
      }
      
      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = get_windows_debugger_path('OpenDebugAD7', get_windows_debugger_path('codelldb', 'codelldb')),
        options = { detached = false },
      }
      
      -- GDB 配置 (如果在 Windows 上使用 MinGW 或 WSL)
      dap.adapters.gdb = {
        type = 'executable',
        command = get_windows_debugger_path('gdb', 'gdb'),
        args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
      }
      
      -- Python 调试器 (debugpy)
      dap.adapters.python = {
        type = 'executable',
        command = get_windows_debugger_path('debugpy-adapter', 'python'),
        args = { '-m', 'debugpy.adapter' },
      }
      
      -- Node.js 调试器
      dap.adapters.node2 = {
        type = 'executable',
        command = get_windows_debugger_path('node', 'node'),
        args = { vim.fn.stdpath('data') .. '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js' },
      }
      
      -- PowerShell 调试器 (Windows 特有)
      dap.adapters.powershell = {
        type = 'executable',
        command = 'pwsh',
        args = { '-NoLogo', '-NoProfile', '-Command', 'Import-Module PowerShellEditorServices.VSCode; Start-EditorServices' },
      }

      
      -- C/C++ 调试配置 (Windows 适配)
      dap.configurations.cpp = {
        {
          name = 'Launch (codelldb)',
          type = 'codelldb',
          request = 'launch',
          program = get_program_path(),
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
        {
          name = 'Launch (cppdbg/MSVC)',
          type = 'cppdbg',
          request = 'launch',
          program = get_program_path(),
          args = {},
          stopAtEntry = false,
          cwd = '${workspaceFolder}',
          environment = {},
          externalConsole = false,
          MIMode = vim.fn.has('win32') == 1 and 'lldb' or 'gdb',
          miDebuggerPath = get_windows_debugger_path('gdb', 'gdb'),
          setupCommands = {
            {
              description = 'Enable pretty-printing for gdb',
              ignoreFailures = true,
              text = '-enable-pretty-printing',
            },
          },
        },
        {
          name = 'Attach to process',
          type = 'cppdbg',
          request = 'attach',
          program = get_program_path(),
          processId = function()
            return require('dap.utils').pick_process()
          end,
          cwd = '${workspaceFolder}',
          MIMode = vim.fn.has('win32') == 1 and 'lldb' or 'gdb',
        },
      }
      
      -- C 调试配置
      dap.configurations.c = dap.configurations.cpp
      
      -- CUDA 调试配置 (如果需要)
      dap.configurations.cuda = {
        {
          name = 'Launch CUDA Program',
          type = 'cppdbg',
          request = 'launch',
          program = get_program_path(),
          args = {},
          stopAtEntry = false,
          cwd = '${workspaceFolder}',
          environment = {},
          externalConsole = false,
        },
      }

-- Python 调试配置 (Windows 适配)
dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Launch current file',
    program = '${file}',
    console = 'integratedTerminal',
    cwd = '${workspaceFolder}',
    pythonPath = function()
      -- 优先使用虚拟环境中的 Python
      local venv_python = vim.fn.getcwd() .. '\\venv\\Scripts\\python.exe'
      if vim.fn.executable(venv_python) == 1 then
        return venv_python
      end
      
      -- 回退到系统 Python
      return get_windows_debugger_path('python', 'python')
    end,
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Launch with arguments',
    program = '${file}',
    args = function()
      local ok, args_string = pcall(vim.fn.input, 'Arguments: ')
      if not ok or args_string == "" then
        return {} -- 降级：空参数
      end
      if vim.fn.has('nvim-0.10') == 1 then
        local utils = require('dap.utils')
        if utils.splitstr then
          return utils.splitstr(args_string)
        end
      end
      return vim.split(args_string, ' +')
    end,
    console = 'integratedTerminal',
    cwd = '${workspaceFolder}',
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Launch module',
    module = function()
      local ok, name = pcall(vim.fn.input, 'Module name: ')
      if not ok or name == "" then
        return "__empty__" -- 降级：非法模块名，调试器会报错但不再崩溃
      end
      return name
    end,
    console = 'integratedTerminal',
    cwd = '${workspaceFolder}',
  },
  {
    type = 'python',
    request = 'attach',
    name = 'Attach to running process',
    connect = {
      port = 5678,
      host = '127.0.0.1',
    },
    pathMappings = {
      {
        localRoot = '${workspaceFolder}',
        remoteRoot = '.',
      },
    },
  },
}

-- JavaScript/TypeScript 调试配置
dap.configurations.javascript = {
  {
    type = 'node2',
    request = 'launch',
    name = 'Launch Node.js Program',
    program = '${file}',
    cwd = '${workspaceFolder}',
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
}
dap.configurations.typescript = dap.configurations.javascript

-- PowerShell 调试配置 (Windows 特有)
dap.configurations.ps1 = {
  {
    type = 'powershell',
    request = 'launch',
    name = 'PowerShell Launch Current File',
    script = '${file}',
    cwd = '${workspaceFolder}',
  },
}

-- Windows Batch 调试配置
dap.configurations.dosbatch = {
  {
    type = 'cppdbg',
    request = 'launch',
    name = 'Launch Batch File',
    program = 'cmd.exe',
    args = { '/c', '${file}' },
    cwd = '${workspaceFolder}',
    console = 'externalTerminal',
  },
}

      
      -- 调试快捷键配置
      local keymap = vim.keymap.set
      
      -- 主要调试操作
      keymap('n', '<F5>', function() dap.continue() end, { desc = '开始/继续调试' })
      keymap('n', '<F10>', function() dap.step_over() end, { desc = '单步跾过' })
      keymap('n', '<F11>', function() dap.step_into() end, { desc = '单步进入' })
      keymap('n', '<F12>', function() dap.step_out() end, { desc = '单步跳出' })
      
      -- 断点管理
      keymap('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = '切换断点' })
      keymap('n', '<leader>dB', function() 
        local ok, cond = pcall(vim.fn.input, 'Breakpoint condition: ')
        if ok and cond ~= "" then
          dap.set_breakpoint(cond)
        else
          vim.notify("条件断点取消", vim.log.levels.WARN)
        end
      end, { desc = '条件断点' })
      keymap('n', '<leader>dr', function() dap.repl.open() end, { desc = '打开REPL' })
      keymap('n', '<leader>dl', function() dap.run_last() end, { desc = '重新运行' })
      
      -- DAP UI 控制
      keymap('n', '<leader>du', function() 
        require('dapui').toggle() 
      end, { desc = '切换调试UI' })
      
      keymap('n', '<leader>dv', function() 
        require('dapui').eval() 
      end, { desc = '计算表达式' })
      
      -- 中止调试
      keymap('n', '<leader>dt', function() dap.terminate() end, { desc = '中止调试' })
      keymap('n', '<leader>dq', function() dap.close() end, { desc = '关闭调试' })
      
      -- Python 特定调试（重新定义到 <leader>py 前缀避免冲突）
      keymap('n', '<leader>pys', function() 
        require('dap-python').test_method() 
      end, { desc = 'Python测试方法' })
      
      keymap('n', '<leader>pyh', function() 
        require('dap-python').debug_selection() 
      end, { desc = 'Python调试选择' })
      
      keymap('n', '<leader>pyp', function() 
        require('dap-python').test_class() 
      end, { desc = 'Python测试类' })
      
      -- 设置断点样式
      vim.fn.sign_define('DapBreakpoint', {text='ὓ4', texthl='DapBreakpoint', linehl='', numhl=''})
      vim.fn.sign_define('DapBreakpointCondition', {text='὾1', texthl='DapBreakpointCondition', linehl='', numhl=''})
      vim.fn.sign_define('DapLogPoint', {text='὾2', texthl='DapLogPoint', linehl='', numhl=''})
      vim.fn.sign_define('DapStopped', {text='➤️', texthl='DapStopped', linehl='debugPC', numhl=''})
      vim.fn.sign_define('DapBreakpointRejected', {text='⛔', texthl='DapBreakpointRejected', linehl='', numhl=''})
    end,
  },
}
