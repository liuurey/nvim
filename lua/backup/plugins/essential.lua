-- 编辑增强插件集合
-- 包含：文本环绕、Markdown渲染、沉浸式写作、智能分割、语法树操作等
return {{
    "kylechui/nvim-surround",
    version = "^3.0.0", -- 使用稳定版本
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("nvim-surround").setup({
            -- 保持默认配置，如需自定义可在此添加
            surrounds = {
                -- 示例：添加自定义环绕（可选）
                ["y"] = {
                    add = function()
                        local ok, input = pcall(vim.fn.input, "Enter a URL: ")
                        if not ok or input == "" then
                          return {{"[", "]()"}} -- 降级：空链接
                        end
                        return {{"[", "](" .. input .. ")"}}
                    end
                }
            }
        })
    end
}, -- Markdown富文本渲染
{
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'md' },
    event = "BufReadPost *.md",
    dependencies = {'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' -- 可选，提供图标支持
    },
    opts = {
        enabled = true,
        latex = {
            enabled = true,
            renderer = 'mathjax' -- 可选 'katex'
        },
        images = {
            enabled = true,
            default_scale = 0.8,
            max_width = 80,
            filetypes = {'png', 'jpg', 'jpeg', 'gif', 'svg'}
        },
        code_blocks = {
            highlight = true,
            border = 'single',
            padding = 1
        },
        headings = {
            font_size = {
                h1 = 1.4,
                h2 = 1.3,
                h3 = 1.2,
                h4 = 1.1,
                h5 = 1.0,
                h6 = 0.9
            },
            bold = true,
            margin = {
                top = 2,
                bottom = 1
            }
        },
        lists = {
            bullet_symbols = {'•', '◦', '▪'},
            indent = 2
        }
    }
}, -- 沉浸写作模式
{
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    dependencies = 'folke/twilight.nvim',
    opts = {
        window = {
            backdrop = 0.95, -- 背景透明度
            width = 120, -- 宽度
            height = 1, -- 高度 (0.9 表示90%屏幕高度)
            options = {
                signcolumn = 'no',
                number = false,
                relativenumber = false,
                cursorline = false,
                cursorcolumn = false,
                foldcolumn = '0',
                list = false
            }
        },
        plugins = {
            options = {
                enabled = true,
                ruler = false,
                showcmd = false
            },
            twilight = {
                enabled = true
            }, -- 自动启用twilight
            gitsigns = {
                enabled = false
            },
            tmux = {
                enabled = true
            }, -- 禁用tmux状态栏
            kitty = {
                enabled = true,
                font = '+4' -- 增大kitty字体
            }
        },
        on_open = function(win)
            -- 打开时的回调
        end,
        on_close = function()
            -- 关闭时的回调
        end}
    }
}, 
{
    'folke/twilight.nvim',
    opts = {
        dimming = {
            alpha = 0.25, -- 非当前段落透明度
            color = {'Normal', '#ffffff'},
            term_bg = '#000000',
            inactive = false
        },
        context = 10, -- 上下文行数
        treesitter = true,
        expand = { -- 扩展高亮的节点
            'function', 'method', 'table', 'if_statement'
        },
        exclude = {} -- 排除的文件类型
    }
},
-- 编辑效率类插件
{
    'mrjones2014/smart-splits.nvim',
    event = { "VeryLazy" },
    keys = {
        { '<C-h>', desc = 'Move cursor left' },
        { '<C-j>', desc = 'Move cursor down' },
        { '<C-k>', desc = 'Move cursor up' },
        { '<C-l>', desc = 'Move cursor right' },
        { '<A-h>', desc = 'Resize left' },
        { '<A-j>', desc = 'Resize down' },
        { '<A-k>', desc = 'Resize up' },
        { '<A-l>', desc = 'Resize right' },
    },
    config = function()
        require('smart-splits').setup({
            ignored_filetypes = {'nofile', 'quickfix', 'prompt'},
            ignored_buftypes = {'NvimTree'},
            default_amount = 3, -- 默认移动像素
            at_edge = 'wrap', -- 边缘行为: wrap, stop, cursor
            cursor_follows_swaps = true,
            resize_mode = {
                quit_key = '<ESC>',
                resize_keys = {'h', 'j', 'k', 'l'},
                silent = false,
                hooks = {
                    on_enter = nil,
                    on_leave = nil
                }
            },
            -- 快捷键配置
            mappings = {
                -- 移动焦点
                move_cursor_left = '<C-h>',
                move_cursor_down = '<C-j>',
                move_cursor_up = '<C-k>',
                move_cursor_right = '<C-l>',
                -- 调整大小
                resize_left = '<A-h>',
                resize_down = '<A-j>',
                resize_up = '<A-k>',
                resize_right = '<A-l>',
                -- 交换窗口
                swap_left = '<leader><C-h>',
                swap_down = '<leader><C-j>',
                swap_up = '<leader><C-k>',
                swap_right = '<leader><C-l>'
            }
        })
    end
}, {
    'Wansmer/treesj',
    keys = {{
        '<leader>j',
        '<CMD>TSJToggle<CR>',
        desc = 'Toggle Treesitter Join'
    }},
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
        use_default_keymaps = false,
        max_join_length = 120,
        cursor_behavior = 'hold', -- hold, start, end
        notify = true,
        langs = {
            lua = {
                table = {
                    both = true,
                    split = {
                        recursive = true
                    }
                },
                array = {
                    both = true,
                    split = {
                        recursive = true
                    }
                }
            },
            javascript = {
                object = {
                    both = true
                },
                array = {
                    both = true
                },
                argument_list = {
                    both = true
                },
                statement_block = {
                    both = true
                }
            },
            typescript = {
                object = {
                    both = true
                },
                array = {
                    both = true
                },
                argument_list = {
                    both = true
                },
                statement_block = {
                    both = true
                }
            },
            json = {
                object = {
                    both = true
                },
                array = {
                    both = true
                }
            }
        }
    }
}, {
    'gbprod/substitute.nvim',
    keys = {{
        's',
        mode = {'n', 'x'},
        desc = 'Substitute'
    }, {
        'ss',
        mode = 'n',
        desc = 'Substitute line'
    }, {
        'S',
        mode = 'n',
        desc = 'Substitute until end of line'
    }, {
        '<leader>sr',
        '<CMD>SubRegex<CR>',
        desc = 'Substitute with regex'
    }},
    opts = {
        on_substitute = nil,
        yank_substituted_text = false,
        highlight_substituted_text = {
            enabled = true,
            timer = 500
        },
        range = {
            prefix = 's',
            prompt_current_text = false,
            confirm = false,
            complete_word = false,
            motion1 = 'iw',
            motion2 = 'iw'
        },
        exchange = {
            motion = false,
            use_esc_to_cancel = true
        },
        ai = {
            enabled = true,
            provider = 'deepseek',
            api_key = os.getenv('DEEPSEEK_API_KEY'),
            temperature = 0.5,
            -- GLM-4 支持
            glm4 = {
                    enabled = true,
                    provider = 'glm4',
                    api_key = os.getenv('GLM4_API_KEY') or '',
                    api_url = 'https://open.bigmodel.cn/api/paas/v4',
                    model = 'glm-4-flash',
                    temperature = 0.3,
                    max_tokens = 2048,
                }
        }
    }
},  {
        'nvim-neotest/neotest',
        dependencies = {
            'nvim-lua/plenary.nvim', 
            'nvim-treesitter/nvim-treesitter', 
            'antoinemadec/FixCursorHold.nvim',
            'nvim-neotest/nvim-nio',  -- 官方推荐的异步IO库
            -- 多语言测试适配器
            'olimorris/neotest-rspec',           -- Ruby RSpec
            'nvim-neotest/neotest-go',            -- Go
            'nvim-neotest/neotest-python',        -- Python (pytest/unittest)
            'nvim-neotest/neotest-jest',          -- JavaScript/TypeScript Jest
            'nvim-neotest/neotest-vitest',        -- Vite测试
            'nvim-neotest/neotest-plenary',       -- Neovim Lua测试
        },
        keys = {
            -- 基础测试运行
            {
                '<leader>tn',
                function() require('neotest').run.run() end,
                desc = '运行最近的测试'
            },
            {
                '<leader>tf',
                function() require('neotest').run.run(vim.fn.expand('%')) end,
                desc = '运行当前文件的所有测试'
            },
            {
                '<leader>td',
                function() require('neotest').run.run({strategy = 'dap'}) end,
                desc = '调试最近的测试 (需要nvim-dap)'
            },
            -- 测试管理
            {
                '<leader>ts',
                function() require('neotest').run.stop() end,
                desc = '停止测试运行'
            },
            {
                '<leader>ta',
                function() require('neotest').run.attach() end,
                desc = '附加到测试进程'
            },
            -- 输出和摘要
            {
                '<leader>to',
                function() require('neotest').output.open({enter = true, auto_close = true}) end,
                desc = '打开测试输出'
            },
            {
                '<leader>tp',
                function() require('neotest').summary.toggle() end,
                desc = '切换测试摘要面板'
            },
            {
                '<leader>tO',
                function() require('neotest').output_panel.toggle() end,
                desc = '切换测试输出面板'
            },
            -- 高级功能
            {
                '<leader>tw',
                function() require('neotest').watch.toggle(vim.fn.expand('%')) end,
                desc = '切换测试监视模式'
            },
            {
                '<leader>tR',
                function() require('neotest').run.run_last() end,
                desc = '重新运行最后的测试'
            }
        },
        opts = {
            -- 适配器配置 - 按官方最佳实践设置
            adapters = {
                -- Python配置 (pytest/unittest)
                require('neotest-python')({
                    -- DAP调试配置
                    dap = { 
                        justMyCode = false,  -- 允许调试第三方库
                        console = 'integratedTerminal',
                    },
                    -- 命令行参数
                    args = {'--verbose', '--tb=short'},
                    -- 测试运行器
                    runner = 'pytest',
                    -- 自动发现参数化测试实例
                    pytest_discover_instances = true,
                    -- Python路径 (自动检测虚拟环境)
                    python = function()
                        local venv_paths = {
                            '.venv/bin/python',
                            'venv/bin/python', 
                            'env/bin/python',
                            '.env/bin/python'
                        }
                        for _, path in ipairs(venv_paths) do
                            if vim.fn.filereadable(path) == 1 then
                                return path
                            end
                        end
                        return 'python'
                    end,
                }),
                
                -- Jest配置 (JavaScript/TypeScript)
                require('neotest-jest')({
                    -- Jest命令
                    jestCommand = 'npm test --',
                    -- 配置文件路径
                    jestConfigFile = function(file)
                        -- 支持monorepo结构
                        if file:match('packages/') then
                            return string.match(file, '(.-/)src') .. 'jest.config.js'
                        end
                        return vim.fn.getcwd() .. '/jest.config.js'
                    end,
                    -- 环境变量
                    env = { CI = true, NODE_ENV = 'test' },
                    -- 工作目录
                    cwd = function(file)
                        -- monorepo支持
                        if file:match('packages/') then
                            return string.match(file, '(.-/)src')
                        end
                        return vim.fn.getcwd()
                    end,
                    -- 参数化测试发现
                    jest_test_discovery = true,
                }),
                
                -- Vitest配置
                require('neotest-vitest')({
                    -- Vitest命令
                    vitestCommand = 'npm run test:vitest --',
                }),
                
                -- Go配置
                require('neotest-go')({
                    experimental = {
                        test_table = true,  -- 启用表格驱动测试支持
                    },
                    -- Go test参数
                    args = { 
                        '-count=1',      -- 禁用测试缓存
                        '-timeout=60s',  -- 超时时间
                        '-v',            -- 详细输出
                    },
                }),
                
                -- RSpec配置 (Ruby)
                require('neotest-rspec')({
                    rspec_cmd = function()
                        return vim.tbl_flatten({
                            'bundle',
                            'exec', 
                            'rspec',
                            '--format', 'json',
                            '--format', 'documentation',
                        })
                    end,
                }),
                
                -- Plenary配置 (Neovim Lua测试)
                require('neotest-plenary'),
            },
            
            -- 测试发现配置
            discovery = {
                enabled = true,
                concurrent = 0,  -- 0表示自动检测CPU核心数
            },
            
            -- 测试运行配置
            running = {
                concurrent = true,
            },
            
            -- 状态显示配置
            status = {
                enabled = true,
                signs = true,
                virtual_text = {
                    enabled = true,
                    -- 自定义虚拟文本格式
                    format = function(test_status)
                        local status_map = {
                            passed = '✓',
                            failed = '✗', 
                            skipped = '⊘',
                            running = '⟳',
                        }
                        return status_map[test_status] or '?'
                    end,
                }
            },
            
            -- 输出配置
            output = {
                enabled = true,
                open_on_run = true,
                -- 输出窗口配置
                float = {
                    border = 'rounded',
                    max_width = 120,
                    max_height = 30,
                }
            },
            
            -- 输出面板配置
            output_panel = {
                enabled = true,
                open = 'botright vsplit | vertical resize 60',
            },
            
            -- 摘要窗口配置
            summary = {
                enabled = true,
                expand_errors = true,
                follow = true,
                -- 自定义映射
                mappings = {
                    attach = 'a',
                    expand = 'e',
                    expand_all = 'E',
                    jumpto = 'i',
                    output = 'o',
                    run = 'r',
                    short = 's',
                    stop = 'x',
                    -- 额外映射
                    clear_marked = 'M',
                    clear_selected = 'C',
                    debug = 'd',
                    debug_marked = 'D',
                    mark = 'm',
                    next_failed = 'J',
                    prev_failed = 'K',
                    watch = 'w',
                }
            },
            
            -- 诊断消息配置
            diagnostic = {
                enabled = true,
                severity = vim.diagnostic.severity.ERROR,
            },
            
            -- 通知配置
            notify = {
                enabled = true,
                -- 使用Neovim内置通知系统
                timeout = 3000,  -- 3秒超时
            }
        },
        config = function(_, opts)
            -- 获取neotest命名空间
            local neotest_ns = vim.api.nvim_create_namespace('neotest')
            
            -- 配置诊断设置
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
                        return message
                    end,
                }
            }, neotest_ns)
            
            -- 应用配置
            require('neotest').setup(opts)
            
            -- 确保treesitter解析器已安装
            local test_langs = { 'python', 'javascript', 'typescript', 'go', 'rust', 'java', 'ruby', 'lua' }
            for _, lang in ipairs(test_langs) do
                local ok, _ = pcall(vim.treesitter.language.add, lang)
                if not ok then
                    vim.notify('建议安装 ' .. lang .. ' treesitter解析器以获得最佳测试体验', vim.log.levels.INFO)
                end
            end
        end,
    {
        'MagicDuck/grug-far.nvim',
        cmd = 'GrugFar',
        keys = {{
            '<leader>gr',
            '<CMD>GrugFar<CR>',
            desc = 'Grug Far (Global Replace)'
        }},
        opts = {
            ai = {
                enabled = true,
                provider = 'deepseek',
                api_key = os.getenv('DEEPSEEK_API_KEY'),
                temperature = 0.3,
                -- GLM-4 支持
                glm4 = {
                    enabled = true,
                    provider = 'glm4',
                    api_key = os.getenv('ZHIPUAI_API_KEY') or '',
                    api_url = 'https://open.bigmodel.cn/api/paas/v4',
                    model = 'glm-4-flash',
                    temperature = 0.3,
                    max_tokens = 2048,
                }
            },
            ui = {
                border = 'rounded',
                preview = {
                    width = 0.6,
                    height = 0.6
                }
            },
            git = {
                enabled = true,
                files = {
                    include = {},
                    exclude = {'node_modules', '.git', 'target', 'build'}
                }
            },
            mappings = {
                close = 'q',
                accept = '<CR>',
                replace_one = 'r',
                replace_all = 'R',
                preview = 'p',
                toggle_ai = 'a'
            }
        }
    },
    -- Git/协作类插件
    {
        'sindrets/diffview.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        cmd = {'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles'},
        keys = {{
            '<leader>gd',
            '<CMD>DiffviewOpen<CR>',
            desc = 'Git diff view'
        }, {
            '<leader>gD',
            '<CMD>DiffviewOpen HEAD~1<CR>',
            desc = 'Git diff last commit'
        }, {
            '<leader>gc',
            '<CMD>DiffviewClose<CR>',
            desc = 'Close diff view'
        }, {
            '<leader>gf',
            '<CMD>DiffviewToggleFiles<CR>',
            desc = 'Toggle diff files'
        }},
        opts = {
            diff_binaries = false,
            enhanced_diff_hl = true,
            git_cmd = {'git'},
            use_icons = true,
            watch_index = true,
            icons = {
                folder_closed = '',
                folder_open = ''
            },
            signs = {
                fold_closed = '',
                fold_open = '',
                done = '✓'
            },
            view = {
                default = {
                    layout = 'diff2_horizontal',
                    winbar_info = true
                },
                merge_tool = {
                    layout = 'diff3_horizontal', -- 三栏diff布局
                    disable_diagnostics = true,
                    winbar_info = true
                },
                file_history = {
                    layout = 'diff2_horizontal',
                    winbar_info = true
                }
            },
            file_panel = {
                listing_style = 'tree',
                tree_options = {
                    flatten_dirs = true,
                    folder_statuses = 'only_folded'
                },
                win_config = {
                    position = 'left',
                    width = 35
                }
            },
            file_history_panel = {
                log_options = {
                    git = {
                        single_file = {
                            diff_merges = 'combined'
                        },
                        multi_file = {
                            diff_merges = 'first-parent'
                        }
                    }
                },
                win_config = {
                    position = 'bottom',
                    height = 16
                }
            },
            commit_log_panel = {
                win_config = {
                    height = 16
                }
            },
            merge_tool = {
                -- 冲突解决AI建议
                ai_assistant = {
                    enabled = true,
                    provider = 'claude',
                    api_key = os.getenv('ANTHROPIC_API_KEY'),
                    temperature = 0.3,
                    -- GLM-4 支持
                    glm4 = {
                    enabled = true,
                    provider = 'glm4',
                    api_key = os.getenv('GLM4_API_KEY') or '',
                    api_url = 'https://open.bigmodel.cn/api/paas/v4',
                    model = 'glm-4-flash',
                    temperature = 0.3,
                    max_tokens = 2048,
                }
                }
            }
        }
    },
    {
        'NeogitOrg/neogit',
        dependencies = {'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim', 'sindrets/diffview.nvim'},
        cmd = 'Neogit',
        keys = {{
            '<leader>gg',
            '<CMD>Neogit<CR>',
            desc = 'Open Neogit'
        }, {
            '<leader>gc',
            '<CMD>Neogit commit<CR>',
            desc = 'Git commit'
        }},
        opts = {
            integrations = {
                telescope = true,
                diffview = true
            },
            AI = {
                enabled = true,
                provider = 'openai',
                api_key = os.getenv('OPENAI_API_KEY'),
                commit_message = {
                    enabled = true,
                    language = 'zh-CN', -- 支持 'en-US', 'zh-CN'
                    style = 'conventional' -- conventional, descriptive
                },
                -- GLM-4 支持
                glm4 = {
                    enabled = true,
                    provider = 'glm4',
                    api_key = os.getenv('GLM4_API_KEY') or '',
                    api_url = 'https://open.bigmodel.cn/api/paas/v4',
                    model = 'glm-4-flash',
                    temperature = 0.3,
                    max_tokens = 2048,
                    language = 'zh-CN',
                    style = 'conventional'
                }
            },
            signs = {
                section = {'>', 'v'},
                item = {'>', 'v'},
                hunk = {' ', ' '}
            },
            kind = 'tab', -- tab, split, vsplit
            graph_style = 'unicode',
            disable_builtin_notifications = false,
            status = {
                recent_commit_count = 10
            },
            commit_editor = {
                kind = 'split'
            },
            mappings = {
                status = {
                    ['q'] = 'Close',
                    ['I'] = 'InitRepo',
                    ['1'] = 'Depth1',
                    ['2'] = 'Depth2',
                    ['3'] = 'Depth3',
                    ['4'] = 'Depth4',
                    ['<tab>'] = 'Toggle',
                    ['x'] = 'Discard',
                    ['s'] = 'Stage',
                    ['S'] = 'StageUnstaged',
                    ['<c-s>'] = 'StageAll',
                    ['u'] = 'Unstage',
                    ['U'] = 'UnstageStaged',
                    ['c'] = 'Commit',
                    ['v'] = 'VSplitOpen',
                    ['o'] = 'SplitOpen',
                    ['<enter>'] = 'GoToFile',
                    ['<c-r>'] = 'RefreshBuffer',
                    ['?'] = 'HelpPopup',
                    ['D'] = 'DiffAtFile',
                    ['$'] = 'CommandHistory',
                    ['#'] = 'Console',
                    ['<c-y>'] = 'YankSelected',
                    ['p'] = 'CherryPick',
                    ['r'] = 'Rebase',
                    ['m'] = 'Merge',
                    ['P'] = 'Pull',
                    ['pu'] = 'Push',
                    ['a'] = 'AICommitMessage' -- 生成AI提交信息
                }
            }
        }
    },
    {
        'eandrju/cellular-automaton.nvim',
        cmd = 'CellularAutomaton',
        keys = {{
            '<leader>gol',
            '<CMD>CellularAutomaton game_of_life<CR>',
            desc = 'Game of Life'
        }, {
            '<leader>golr',
            '<CMD>CellularAutomaton make_it_rain<CR>',
            desc = 'Make it Rain'
        }},
        config = function()
            -- 新版 cellular-automaton 已移除 register_automaton，仅保留按键映射
            -- 若未来插件恢复 API，可在此扩展
        end
    }
}
