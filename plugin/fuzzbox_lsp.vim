vim9script

import autoload 'fuzzbox/launcher.vim'

command! -nargs=0 FuzzyLspDocumentSymbols fuzzbox#Launch('lsp_document_symbols')
