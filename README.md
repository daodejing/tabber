# Good News!
In the current (2025/2/9) nightly (`NVIM v0.11.0-dev-1709+ga9cdf76e3a`), there is an option:
```
set tabclose=uselast
```
That provides the functionality of this plugin.

# tabber
*tabber* is a neovim plugin for nicer tab closing

In neovim, when closing a tab, you are taken to the most recently created tab.

With this plugin, when you close a tab, you are taken back to your most recently viewed tab.


## Installation
### Lazy
```lua
{
    "daodejing/tabber.nvim",
    config = true,
}
```

## Usage
Just close a tab and you will be taken to the last tab you were on.

