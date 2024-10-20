-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.cmd("colorscheme onedark")

vim.cmd("filetype plugin on")

-- vim.api.nvim_set_option("clipboard", "unnamedplus")

-- python lsp configuration
require("lspconfig").pylsp.setup({
  settings = {
    pylsp = {
      configurationSources = { "flake8" },
      plugins = {
        pylint = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = {
          enabled = true,
          ignore = {
            "E402",
            "E501",
            "E226",
            "E231",
            "E124",
            "E261",
            "E225",
            "E265",
            "E266",
            "E731",
            "E251",
            "E128",
            "E302",
          },
        },
        flake8 = { enabled = false },
        mypy = { enabled = false },
        -- Disable auto formatting
        yapf = { enabled = false },
        autopep8 = { enabled = false },
        black = { enabled = false },
      },
    },
  },
  -- Optional: Add this to ensure formatting is only done manually
  -- on_attach = function(client, bufnr)
  --   client.resolved_capabilities.document_formatting = false
  --   client.resolved_capabilities.document_range_formatting = false
  -- end,
})

-- vimtex configuration
vim.g.vimtex_syntax_conceal_disable = 1 -- disable conceals
