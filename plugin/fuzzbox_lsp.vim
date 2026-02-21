vim9script

import autoload 'fuzzbox/launcher.vim'

command! -nargs=0 FuzzyLspDocumentSymbols fuzzbox#Launch('lsp_document_symbols')
command! -nargs=0 FuzzyLspWorksspaceSymbols fuzzbox#Launch('lsp_workspace_symbols')
