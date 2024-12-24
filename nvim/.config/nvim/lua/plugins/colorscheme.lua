return {
	"olimorris/onedarkpro.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local onedark = require("onedarkpro")
		-- local bg_transparent = true
		onedark.setup({
			options = {
				transparency = true, -- Enable transparency
			},
		})
		-- load the colorscheme
		vim.cmd.colorscheme("onedark")

		-- -- toggle background transparency
		local bg_transparent = true
		--
		local toggle_transparency = function()
			bg_transparent = not bg_transparent
			onedark.setup({
				options = {
					transparency = bg_transparent, -- Enable transparency
				},
			})
			vim.cmd.colorscheme("onedark")
		end

		vim.keymap.set("n", "<leader>bg", toggle_transparency, { noremap = true, silent = true })
	end,
}
