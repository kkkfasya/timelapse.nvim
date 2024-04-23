# timelapse.nvim
Timelapse-like effect in neovim
if you ever watch [one](https://www.youtube.com/watch?v=vkUwT9U1GzA) of bisqwit's videos you know what i mean  
The effect that i want is not quite achieved yet

## Instalation
Use your favorite plugin manager, for example:
### [vim-plug](https://github.com/junegunn/vim-plug)
```vim
call plug#begin()

Plug 'fkys/timelapse.nvim'

call plug#end()
```
## Usage
```Haskell
:Timelapse <delay_ms || boolean>
e.g :Timelapse 300 -- will print automatically with 300ms delay
e.g :Timelapse true -- will print each time any key is pressed
```

> shoutout to ChatGPT yo, couldn't made it without you cuz i was too lazy to read the docs
