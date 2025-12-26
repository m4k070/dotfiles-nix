return {
  -- 繰り返し
  "tpope/vim-repeat",
  -- ライブラリ
  "nvim-lua/popup.nvim",
  -- ライブラリ
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",

  --------
  -- UI
  --------

  -- カラースキーム
  "EdenEast/nightfox.nvim",
  {
    "rebelot/kanagawa.nvim",
    config = function()
      vim.cmd("colorscheme kanagawa")
    end,
  },

  {
    -- シンタックスハイライト
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "clojure",
          "css",
          "fsharp",
          "go",
          "html",
          "javascript",
          "json",
          "lua",
          "svelte",
          "tsx",
          "typescript",
        },
        highlight = {
          enable = true,
        },
      })
    end,
  },

  -- カッコに対応する文を仮想テキストに表示
  --"haringsrob/nvim_context_vt",

  -- 通知
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    -- dependencies = { "rcarriga/nvim-notify" },
    config = function()
      require("noice").setup({
        lsp = {
          -- 既存の出力先をNoiceに上書き
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          preset = {
            bottom_search = false,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = false,
          },
        },
      })
      -- vim.notify = require("notify")
    end,
  },

  {
    -- ステータスバー
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup{}
    end
  },

  {
    -- インデントガイド
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          chars = {
            horizontal_line = "-",
            vertical_line = "|",
            left_top = "┌",
            left_bottom = "└",
            right_arrow = ">",
          },
          style = "#806d9c",
        },
      })
    end,
  },

  -- バッファタブ
  -- "romgrk/barbar.nvim",

  -- {
  --   "b0o/incline.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("incline").setup()
  --   end,
  -- },

  {
    -- キーバインドナビ
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)"
      },
    },
  },

  {
    -- 右下通知
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup{}
    end,
  },
  --------

  --------
  -- 編集
  --------

  -- 補完
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      'liquidz/elin-cmp-source',
    },
    config = function()
      require("cmp").setup({
        mapping = {
          ["<C-Space>"] = require("cmp").mapping.complete(),
          ['<CR>'] = require("cmp").mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "elin" },
        },
      })
    end,
  },

  {
    "machakann/vim-sandwich",
  },

  {
    -- LSP
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true,
      })
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("gopls")
      vim.lsp.enable("clojure")

      vim.keymap.set("n", "<F2>", "<cmd>:lua vim.lsp.buf.rename()<CR>")
      vim.keymap.set("n", "<F12>", "<cmd>:lua vim.lsp.buf.definition()<CR>")
      vim.keymap.set("n", "<leader>e", "<cmd>:lua vim.diagnostic.open_float()<CR>",
        { noremap = true, silent = true })
    end,
  },
  "ionide/ionide-vim",
  {
    "nvimdev/lspsaga.nvim",
    config = function()
      require("lspsaga").setup({})
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    }
  },

  {
    -- フォーマッタ
    "mhartington/formatter.nvim",
    config = function()
      local util = require("formatter.util")
      require("formatter").setup({
        filetype = {
          go = {
            function()
              return {
                exe = "gofmt",
                args = {
                  "-w",
                  util.escape_path(util.get_current_buffer_file_path()),
                },
                stdin = false,
              }
            end
          },
          javascript = { require("formatter.filetypes.javascript").biome },
          javascriptreact = { require("formatter.filetypes.javascriptreact").biome },
          typescript = { require("formatter.filetypes.typescript").biome },
          typescriptreact = { require("formatter.filetypes.typescriptreact").biome },
        },
      })
      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd
      augroup("__formatter__", { clear = true })
      autocmd("BufWritePost", {
        group = "__formatter__",
        command = "FormatWrite",
      })
    end,
  },

  -- 括弧
  {
    "andymass/vim-matchup",
    config = function()
      require("nvim-treesitter").setup{
        matchup = {
          enable = true,
        },
      }
    end,
  },

  -- ツリーファイラ
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    config = function()
      require("neo-tree").setup{
        enable_git_status = true,
        window = {
          width = "20%",
          maxWidth = 25,
          mappings = {
          },
        },
      }
      vim.keymap.set("n", "<C-n>", "<cmd>:Neotree<CR>")
    end,
  },

  {
    -- コメント
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup{
        toggler = {
          line = "<leader>c",
          block = "<leader>b",
        },
      }
    end,
  },

  {
    -- open other file
    "rgroli/other.nvim",
    config = function()
      require("other-nvim").setup({
        mappings = {
          -- builtin mappings
          "livewire",
          "rails",
          "golang",
          "react",
        },
        transformers = {
          -- defining a custom transformer
          lowercase = function (inputString)
            return inputString:lower()
          end
        },
        style = {
          -- How the plugin paints its window borders
          -- Allowed values are none, single, double, rounded, solid and shadow
          border = "solid",

          -- Column seperator for the window
          seperator = "|",

          -- width of the window in percent. e.g. 0.5 is 50%, 1.0 is 100%
          width = 0.7,

          -- min height in rows.
          -- when more columns are needed this value is extended automatically
          minHeight = 2
        },
      })
    end,
  },

  -- git
  {
    "NeogitOrg/neogit",
    dependencies =  {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
    },
    config = function()
      require("neogit").setup{}
    end,
  },

  -- svelte
  {
    "evanleck/vim-svelte",
    dependencies = {
      "pangloss/vim-javascript",
      "othree/html5.vim"
    },
  },

  -- AI
  "github/copilot.vim",

  -- go
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup{}
    end,
    ft = { "go", "gomod" },
  },
  {
    "leoluz/nvim-dap-go",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      require("dap-go").setup {
        dap_configurations = {
          {
            type = "go",
            name = "Debug the golang",
            request = "attach",
            mode = "remote",
            port = 2345,
            host = "127.0.0.1",
          }
        }
      }
    end,
  },

  -- clojure
  {
    "liquidz/elin",
  },

  -- Better Quickfix
  "kevinhwang91/nvim-bqf",
}
