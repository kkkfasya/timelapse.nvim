if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("timelapse.nvim requires at least nvim-0.7.0.1")
  return
end


local function buf0_to_str()
  local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  return table.concat(content, "\n")
end


local function timelapse()
  local current_buf = buf0_to_str()
  print(current_buf)
end




vim.api.nvim_create_user_command(
    'Timelapse',
    timelapse,
    {bang = true, desc = 'Make a timelapse-like effects'}
)
