vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
	callback = function()
		require("zen-mode").close()
	end,
})