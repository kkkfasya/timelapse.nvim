# timelapse.nvim
Timelapse-like effect in neovim  
if you ever watch [one](https://www.youtube.com/watch?v=vkUwT9U1GzA) of bisqwit's videos you know what i mean  
Didn't get it? So basically it will write char by char to a buffer with miliseconds delay, creating a timelapse effect

## Installation
Use your favorite plugin manager, for example:
### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
call plug#begin()

Plug 'kkkfasya/timelapse.nvim'

call plug#end()
```

### [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  "kkkfasya/timelapse.nvim",
  lazy = true,
  cmd = { "Timelapse", "FTimelapse" }
},

```
## Usage
```vim
:Timelapse [delay_ms] " default delay (30ms)
e.g :Timelapse 10

:FTimelapse <file> [delay_ms] " file required
e.g :Timelapse plugin/timelapse.lua
```

### Controls (Normal Mode)
- `q` or `<ESC>`: Close the timelapse buffer and exit (can be pressed at any time).
- `<Space>` or `p`: Toggle pause / resume.

> shoutout to ChatGPT yo, couldn't made it without you cuz i was too lazy to read the docs
