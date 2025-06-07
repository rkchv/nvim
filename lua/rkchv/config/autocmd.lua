vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
	callback = function()
		require("zen-mode").close()
	end,
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "NeogitStatus",
-- 	callback = function()
-- 		vim.cmd("setlocal syntax=on")
-- 	end,
-- })
