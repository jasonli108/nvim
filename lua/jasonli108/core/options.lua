local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = false -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.softtabstop = 2
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
-- opt.wrap = false -- disable line wrapping
opt.wrap = true -- disable line wrapping

-- undo persistent
opt.undofile = true
local undodir = vim.fn.stdpath("state") .. "/undo"

-- Function to delete undo files older than 30 days
local function cleanup_undo_files()
	local day_limit = 30
	local seconds_limit = day_limit * 24 * 60 * 60
	local current_time = os.time()

	-- Get list of all files in the undo directory
	local files = vim.fn.glob(undodir .. "/*", false, true)

	for _, file in ipairs(files) do
		local stats = vim.loop.fs_stat(file)
		if stats and stats.type == "file" then
			local mtime = stats.mtime.sec
			if (current_time - mtime) > seconds_limit then
				os.remove(file)
			end
		end
	end
end

-- Run cleanup on startup
vim.api.nvim_create_autocmd("VimEnter", {
	callback = cleanup_undo_files,
})

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
-- opt.clipboard:append("unnamedplus") -- use system clipboard as default register
opt.clipboard = "unnamedplus" -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

vim.g.python_indent = {
	disable_parentheses_indent = false,
	closed_paren_align_last_line = false,
}

-- spell
opt.spell = true
opt.spelllang = "en"
opt.spellfile = vim.fn.expand("~/.config/nvim/spell/en.utf-8.add")

vim.opt.list = true
vim.opt.listchars = {
	-- space = "·",
	tab = "▸ ",
	trail = "▫",
}

opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
-- foldering stuff
-- Enable Treesitter-based folding
opt.foldmethod = "expr"
-- opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- vim.opt.foldmethod = 'manual'
-- opt.foldmethod = 'indent'
-- Optional: Start with all folds open
-- opt.foldenable = true
opt.foldlevel = 0
-- opt.foldlevelstart = 0
--
--
vim.diagnostic.config({
	update_in_insert = false,
})

opt.hidden = true -- Allow switching buffers without saving
opt.autowrite = true -- Automatically save before commands like :next and :make

opt.diffopt = "vertical,filler,closeoff,linematch:60,internal"

-- quit or switch without saving buffer
opt.hidden = true

-- vim.env.GEMINI_API_KEY = "AIzaSyArXu16N__yOD_1o7cnUkK6nyprJJBWve8"
-- vim.env.DEEPSEEK_API_KEY = "sk-39fc4655022346d387460145977af8e7" -- Set this env var in your shell
--
-- opt.statusline = "%f %h%m%r%=%l,%c %P"
