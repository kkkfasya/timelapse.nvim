if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("timelapse.nvim requires at least nvim-0.7.0.1")
  return
end


local function current_row()
  local window = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(window)
  return cursor[1]
end


local function buf0_str()
  local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  return table.concat(content, "\n")
end


local function write_to_buf_line(text, buf, filetype, delay)
    vim.api.nvim_command("tabnew")
    vim.api.nvim_command("buffer " .. buf)
    vim.api.nvim_buf_set_option(buf, 'filetype', filetype)

    delay = delay or 100
    local lines = vim.split(text, "\n")
    for _, line in ipairs(lines) do
        vim.api.nvim_buf_set_lines(buf, -1, -1, false, {line})
        vim.api.nvim_command("redraw")
        vim.api.nvim_command("sleep " .. delay .. "m")
        vim.cmd('norm! j')
    end
end


local function timelapse(opts)
  local delay = nil
  if (opts.args ~= "") then delay = tonumber(opts.args) end
  local buf = vim.api.nvim_create_buf(false, true)
  local filetype = vim.bo.filetype
  local text = buf0_str()
  write_to_buf_line(text, buf, filetype, delay)
end


vim.api.nvim_create_user_command(
   'Timelapse',
   timelapse,
   {nargs = '?', desc = 'Make a timelapse-like effects'}
)
