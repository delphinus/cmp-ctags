# cmp-ctags

[Universal Ctags][] source for [nvim-cmp][].

[Universal Ctags]: https://github.com/universal-ctags/ctags
[nvim-cmp]: https://github.com/hrsh7th/nvim-cmp

## What's this? (or what is NOT this?)

This is a source for nvim-cmp using Universal Ctags.

* This is not for [Exuberant Ctags][].
* This is not for [tags][]. You can use [cmp-nvim-tags][].

[Exuberant Ctags]: http://ctags.sourceforge.net
[tags]: https://neovim.io/doc/user/tagsrch.html
[cmp-nvim-tags]: https://github.com/quangnguyen30192/cmp-nvim-tags

## Requirements

* [nvim-cmp][]
* [Universal Ctags][]

## Installation

With [packer.nvim][], you can use this with below.

[packer.nvim]: https://github.com/wbthomason/packer.nvim

```lua
use {
  'delphinus/cmp-ctags'
}
```

Or you can use any plugin manager.

## Configuration

You can set options for this source in calling `cmp.setup`.

```lua
require("cmp").setup {
  sources = {
    {
      name = "ctags",
      -- default values
      option = {
        executable = "ctags",
        trigger_characters = { "." },
        trigger_characters_ft = {},
      },
    },
  },
}
```

### `executable`

* Type: `string`
* Default: `"ctags"`

A custom path for Universal Ctags' executable.

### `trigger_characters`

* Type: `string[]`
* Default: `{ "." }`

Characters to start completions.

### `trigger_characters_ft`

* Type: `Table<string, string[]>`
* Default: `{}`

`trigger_characters` for each filetypes.

```lua
{
  c = { ".", "->" },
  perl = { "->", "::" },
}
```

It fallbacks to `trigger_characters` if the filetype of the current buffer is not defined.
