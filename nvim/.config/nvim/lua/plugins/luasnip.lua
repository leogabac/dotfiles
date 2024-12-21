-- adds LuaSnip as snippet engine, and configures it with nvim-cmp
-- this is basically a modified version from
-- lua/lazyvim/plugins/extras/coding/luasnip.lua
return {
  -- disable builtin snippet support
  { "garymjr/nvim-snippets", enabled = false },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "micangl/cmp-vimtex" },
    enabled=true,
    opts = function(_, opts)
      local cmp = require("cmp") -- manually added
      local luasnip = require("luasnip")
      local auto_select = true

        opts.preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None
      -- key mapping
        opts.mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
          ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
          ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-CR>"] = function(fallback)
            cmp.abort()
            fallback()
          end,
          ["<Tab>"] = cmp.mapping(function(fallback)
            -- Prefer jumping if both jumping and expanding are available
            -- Otherwise, you may recursively expand a snippet without ever jumping
            -- (which is annoying)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.jumpable(1) then
                luasnip.jump(1)
            elseif luasnip.expandable() then
                luasnip.expand()
            else
                fallback()
            end
          end, { "i", "s" }),
        })
      -- manually add sources
      opts.sources = cmp.config.sources({
          { name = "lazydev" },
          { name = "nvim_lsp" },
          -- { name = "vimtex" },
          { name = "path" },
        },
        {
          { name = "buffer" },
        })
    end,
  },

  -- add luasnip
  {
    "L3MON4D3/LuaSnip",
    config = function()
      -- load path for custom snippets
      require("luasnip.loaders.from_lua").load({ paths = "./luasnippets" })
      require("luasnip").config.setup {
      update_events = 'TextChanged,TextChangedI',
      enable_autosnippets = true,
    }
    end,
    lazy = true,
    build = (not LazyVim.is_win())
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
        end,
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },

  -- add snippet_forward action
  {
    "L3MON4D3/LuaSnip",
    opts = function()
      LazyVim.cmp.actions.snippet_forward = function()
        if require("luasnip").jumpable(1) then
          require("luasnip").jump(1)
          return true
        end
      end
      LazyVim.cmp.actions.snippet_stop = function()
        if require("luasnip").expand_or_jumpable() then -- or just jumpable(1) is fine?
          require("luasnip").unlink_current()
          return true
        end
      end
    end,
  },

  -- nvim-cmp integration
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "saadparwaiz1/cmp_luasnip" },
    opts = function(_, opts)
      opts.snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      }
      table.insert(opts.sources, { name = "luasnip" })
    end,
    -- -- stylua: ignore
    -- keys = {
    --   { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
    --   { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    -- },
  },

  -- blink.cmp integration
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = { default = { "luasnip" } },
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
    },
  },
}
