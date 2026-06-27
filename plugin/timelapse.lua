if vim.fn.has("nvim-0.7.0") == 0 then
	vim.api.nvim_err_writeln("timelapse.nvim requires at least nvim-0.7.0")
	return
end

local function get_current_buffer()
	local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	return table.concat(content, "\n")
end

local active_session = nil

local function stop_active_session()
	if active_session then
		active_session.is_running = false
		active_session = nil
	end
end

local function play_next()
	if not active_session or not active_session.is_running then
		return
	end

	if active_session.paused then
		return
	end

	if not vim.api.nvim_buf_is_valid(active_session.buf) then
		stop_active_session()
		return
	end

	if active_session.idx > #active_session.chars then
		vim.api.nvim_buf_set_option(active_session.buf, "modifiable", false)
		stop_active_session()
		return
	end

	local char = active_session.chars[active_session.idx]
	active_session.idx = active_session.idx + 1

	if char == "\n" then
		active_session.current_line = ""
		active_session.cursor_row = active_session.cursor_row + 1
		active_session.cursor_col = 0
		vim.api.nvim_buf_set_lines(active_session.buf, -1, -1, false, { active_session.current_line })
	else
		active_session.current_line = active_session.current_line .. char
		active_session.cursor_col = #active_session.current_line
		vim.api.nvim_buf_set_lines(active_session.buf, -2, -1, false, { active_session.current_line })
	end

	local win = vim.fn.bufwinid(active_session.buf)
	if win ~= -1 then
		local col = math.max(0, active_session.cursor_col - 1)
		pcall(vim.api.nvim_win_set_cursor, win, { active_session.cursor_row, col })
	end

	vim.api.nvim_command("redraw")

	vim.defer_fn(play_next, active_session.delay)
end

local function toggle_pause()
	if not active_session then
		return
	end
	active_session.paused = not active_session.paused
	if active_session.paused then
		print("Timelapse Paused. Press Space/p to resume. Press q/<Esc> to quit.")
	else
		print("Timelapse Resumed.")
		play_next()
	end
end

local function write_animation(text, buf, filetype, delay)
	stop_active_session()

	vim.api.nvim_command("buffer " .. buf)
	vim.api.nvim_buf_set_option(buf, "filetype", filetype)
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "swapfile", false)

	local opts = { buffer = buf, silent = true }
	vim.keymap.set("n", "q", function()
		stop_active_session()
		vim.api.nvim_command("bdelete!")
	end, opts)

	vim.keymap.set("n", "<Esc>", function()
		stop_active_session()
		vim.api.nvim_command("bdelete!")
	end, opts)

	vim.keymap.set("n", "<Space>", toggle_pause, opts)
	vim.keymap.set("n", "p", toggle_pause, opts)

	delay = delay or 30

	local chars = {}
	for char in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
		table.insert(chars, char)
	end

	active_session = {
		chars = chars,
		idx = 1,
		buf = buf,
		delay = delay,
		paused = false,
		is_running = true,
		cursor_row = 1,
		cursor_col = 0,
		current_line = "",
	}

	play_next()
end

local function timelapse(opts)
	local delay = nil
	if opts.args ~= "" then
		delay = tonumber(opts.args)
	end
	local buf = vim.api.nvim_create_buf(false, true)
	local filetype = vim.bo.filetype
	local text = get_current_buffer()
	write_animation(text, buf, filetype, delay)
end

vim.api.nvim_create_user_command("Timelapse", timelapse, { nargs = "?", desc = "Make a timelapse-like effects" })
