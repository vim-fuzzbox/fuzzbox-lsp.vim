vim9script

import autoload 'fuzzbox/launcher.vim'

command! FuzzyLspDocumentSymbols launcher.Start('lsp_document_symbols')
command! FuzzyLspWorksspaceSymbols launcher.Start('lsp_workspace_symbols')
