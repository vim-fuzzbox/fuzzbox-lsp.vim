# fuzzbox-lsp.vim

An extension for [fuzzbox.vim](https://github.com/vim-fuzzbox/fuzzbox.vim) that
integrates with [yegappan/lsp](https://github.com/yegappan/lsp) (aka vim9lsp)

## Installation

Any plugin manager will work, or you can use Vim's built-in package support:

For vim-plug
```vim
Plug 'vim-fuzzbox/fuzzbox-lsp.vim'
```

As Vim package
```
git clone https://github.com/vim-fuzzbox/fuzzbox-lsp.vim ~/.vim/pack/plugins/start/fuzzbox-lsp
```

## Usage

| Command                  | Description
| ---                      | ---
| FuzzyLspDocumentSymbols  | search LSP symbols in the current buffer
| FuzzyLspWorkspaceSymbols | search LSP symbols in the current workspace
