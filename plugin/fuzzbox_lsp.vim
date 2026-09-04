vim9script

import autoload 'fuzzbox/launcher.vim'

command! FuzzyLspDocumentSymbols launcher.Start('lsp_document_symbols')
command! FuzzyLspWorkspaceSymbols launcher.Start('lsp_workspace_symbols')
