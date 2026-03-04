vim9script

import autoload 'lsp/buffer.vim' as buf
import autoload 'lsp/util.vim'
import autoload 'lsp/symbol.vim'
import autoload 'lsp/offset.vim'

export def BufLspServerGet(bnr: number, feature: string): dict<any>
  return buf.BufLspServerGet(bnr, feature)
enddef

export def LspUriToFile(uri: string): string
  return util.LspUriToFile(uri)
enddef

export def LspFileToUri(fname: string): string
  return util.LspFileToUri(fname)
enddef

export def SymbolKindToName(symkind: number): string
  return symbol.SymbolKindToName(symkind)
enddef

export def DecodePosition(lspserver: dict<any>, bnr: number, pos: dict<number>)
  offset.DecodePosition(lspserver, bnr, pos)
enddef
