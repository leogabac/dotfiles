-- adds LuaSnip as snippet engine, and configures it with nvim-cmp
return {
  { "L3MON4D3/LuaSnip" },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "saadparwaiz1/cmp_luasnip" },
    opts = function(_, opts)
      -- overwrite the snippet expansion from lazyvim
      opts.snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      }
      -- append the source of luasnip
      table.insert(opts.sources, { name = "luasnip" })
    end,
  },
}
