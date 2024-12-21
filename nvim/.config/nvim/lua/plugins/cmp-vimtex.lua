return {
  -- add cmp-vimtex as a additional dependency
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "micangl/cmp-vimtex" },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "vimtex" })
    end,
  },
}
