-- =========================
-- Remember folds
-- =========================
local fold_group = vim.api.nvim_create_augroup("remember_folds", { clear = true })

vim.api.nvim_create_autocmd("BufWinLeave", {
	group = fold_group,
	callback = function()
		vim.cmd("silent! mkview")
	end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = fold_group,
	callback = function()
		vim.cmd("silent! loadview")
	end,
})

-- =========================
-- tmux status toggle
-- =========================
if vim.env.TMUX then
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			vim.fn.system({ "tmux", "set", "status", "off" })
		end,
	})

	vim.api.nvim_create_autocmd("VimLeave", {
		callback = function()
			vim.fn.system({ "tmux", "set", "status", "on" })
		end,
	})
end

-- =========================
-- FZF paste fix
-- =========================
vim.api.nvim_create_autocmd("FileType", {
	pattern = "fzf",
	group = vim.api.nvim_create_augroup("fzf_paste_fix", { clear = true }),
	callback = function()
		vim.keymap.set("t", "<C-v>", function()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(vim.fn.getreg("+"), true, true, true), "n", false)
		end, { buffer = true, silent = true, desc = "Paste into FZF" })
	end,
})

-- =========================
-- Auto-reload files safely
-- =========================
vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	callback = function()
		if not vim.bo.modified then
			vim.cmd("checktime")
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
	end,
})

-- =========================
-- Auto-stop ollama model
-- =========================
--
vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		-- Replace 'codellama:7b-python' with your actual model name
		local model = "qwen2.5-coder:latest"
		local cmd = string.format(
			'curl -s -X POST http://localhost:11434/api/generate -d \'{"model": "%s", "keep_alive": 0}\'',
			model
		)
		os.execute(cmd)
	end,
})
