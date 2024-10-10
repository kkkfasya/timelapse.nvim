-- TODO: add pause feature
if vim.fn.has("nvim-0.7.0") == 0 then
	vim.api.nvim_err_writeln("timelapse.nvim requires at least nvim-0.7.0.1")
	return
end

local function get_current_buffer()
	local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	return table.concat(content, "\n")
end

local function write_animation(text, buf, filetype, delay)
	-- Make new scratch buffer to scratch them texts
	vim.api.nvim_command("buffer " .. buf)
	vim.api.nvim_buf_set_option(buf, "filetype", filetype)
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "swapfile", false)

	vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q!<CR>", { noremap = true, silent = true })
	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":q!<CR>", { noremap = true, silent = true })

	delay = delay or 30

	local cursor_row = 1
	local cursor_col = 1
	local current_line = ""

	for i = 1, #text do
		local char = text:sub(i, i)
		if char == "\n" then
			current_line = ""
			cursor_row = cursor_row + 1
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, { current_line })
		else
			current_line = current_line .. char
			cursor_col = cursor_col + 1
			vim.api.nvim_buf_set_lines(buf, -2, -1, false, { current_line })
		end
		vim.api.nvim_win_set_cursor(0, { cursor_row, cursor_col - 1 }) -- Yeah fuck lua 1-based index
		vim.api.nvim_command("redraw")
		vim.api.nvim_command("sleep " .. delay .. "m")
	end
	vim.api.nvim_buf_set_option(buf, "modifiable", false) -- modifiable enable sufferable
end

local function timelapse(opts)
	local delay = nil
	local buf = vim.api.nvim_create_buf(false, true)
	local filetype = vim.bo.filetype
	local text = get_current_buffer()
	if opts.args ~= "" then
		delay = tonumber(opts.args)
		if delay == nil then
			write_animation(text, buf, filetype, nil)
		end
	end
	write_animation(text, buf, filetype, delay)
end

vim.api.nvim_create_user_command("Timelapse", timelapse, { nargs = "?", desc = "Make a timelapse-like effects" })
