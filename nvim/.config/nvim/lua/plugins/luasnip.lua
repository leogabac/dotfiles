-- adds LuaSnip as snippet engine, and configures it with nvim-cmp
-- this is basically a modified version from
-- lua/lazyvim/plugins/extras/coding/luasnip.lua
return {
  -- disable builtin snippet support
  { "garymjr/nvim-snippets", enabled = false },

  -- add luasnip
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    config = function()
      -- load path for custom snippets
      require("luasnip.loaders.from_lua").load({ paths = "./luasnippets" })
      require("luasnip").config.setup {
      update_events = 'TextChanged,TextChangedI',
      enable_autosnippets = true,
    }
    end,
    -- dependencies = {
    --   {
    --     "rafamadriz/friendly-snippets",
    --     config = function()
    --       require("luasnip.loaders.from_vscode").lazy_load()
    --       require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
    --     end,
    --   },
    -- },
    -- opts = {
    --   history = true,
    --   delete_check_events = "TextChanged",
    -- },
  },

 -- -- add snippet_forward action
  -- {
  --   "L3MON4D3/LuaSnip",
  --   opts = function()
  --     LazyVim.cmp.actions.snippet_forward = function()
  --       if require("luasnip").jumpable(1) then
  --         require("luasnip").jump(1)
  --         return true
  --       end
  --     end
  --     LazyVim.cmp.actions.snippet_stop = function()
  --       if require("luasnip").expand_or_jumpable() then -- or just jumpable(1) is fine?
  --         require("luasnip").unlink_current()
  --         return true
  --       end
  --     end
  --   end,
  -- },
  --


  {
    "hrsh7th/nvim-cmp",
    dependencies = { "micangl/cmp-vimtex"},
    enabled=true,
    opts = function()
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local auto_select = true
      return {
        preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert({
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
          ["<tab>"] = function(fallback)
            return LazyVim.cmp.map({ "snippet_forward", "ai_accept" }, fallback)()
          end,
        }),
        sources = cmp.config.sources({
          { name = "vimtex" },
          -- { name = "lazydev" },
          -- { name = "nvim_lsp" },
          -- { name = "path" },
        }, {
          -- { name = "buffer" },
        }),
        formatting = {
          format = function(entry, item)
            local icons = LazyVim.config.icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end

            local widths = {
              abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
              menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
            }

            for key, width in pairs(widths) do
              if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
              end
            end

            return item
          end,
        },
      }
    end,  },

 
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
      table.insert(opts.sources,1, { name = "luasnip" })
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
