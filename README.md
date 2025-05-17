# timelapse.nvim
Timelapse-like effect in neovim  
if you ever watch [one](https://www.youtube.com/watch?v=vkUwT9U1GzA) of bisqwit's videos you know what i mean  

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
  cmd = { "Timelapse" }
},

```
## Usage
```lua
:Timelapse -- will use default delay (30ms)

:Timelapse <delay_ms>
e.g :Timelapse 10 -- 10ms delay for each char
```
Press ```q``` or ```<ESC>``` to exit  
To exit while animation still running, ```Ctrl + C``` then press any key above

> shoutout to ChatGPT yo, couldn't made it without you cuz i was too lazy to read the docs
