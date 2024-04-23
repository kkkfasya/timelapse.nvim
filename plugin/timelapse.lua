if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("timelapse.nvim requires at least nvim-0.7.0.1")
  return
end

local animation_paused = false

local function toggle_animation_pause()
  animation_paused = not animation_paused
end

local function buf0_str()
  local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  return table.concat(content, "\n")
end

local function write_to_buf_line(text, buf, filetype, delay, keypress)
  vim.api.nvim_command("tabnew")
  vim.api.nvim_command("buffer " .. buf)
  vim.api.nvim_buf_set_option(buf, "filetype", filetype)

  delay = delay or 100
  delay = delay or false
  local lines = vim.split(text, "\n")

  for _, line in ipairs(lines) do
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, { line })
    vim.api.nvim_command("redraw")
    vim.api.nvim_command("sleep " .. delay .. "m")
    vim.cmd("norm! j")

    if keypress then
    vim.cmd("norm! jjjj")
      while animation_paused do
        vim.wait(50)
      end
       local c = vim.fn.getchar()
       if c == 0 then
           toggle_animation_pause()
       end
    end

  end
end


local function timelapse(opts)
  local delay = nil
  local buf = vim.api.nvim_create_buf(false, true)
  local filetype = vim.bo.filetype
  local text = buf0_str()
  if opts.args ~= "" then
    delay = tonumber(opts.args)
    if delay == nil then
      write_to_buf_line(text, buf, filetype, nil, true)
    end
  end
  write_to_buf_line(text, buf, filetype, delay, nil)
end

vim.api.nvim_create_user_command(
  "Timelapse",
  timelapse,
  { nargs = "?", desc = "Make a timelapse-like effects" }
)

