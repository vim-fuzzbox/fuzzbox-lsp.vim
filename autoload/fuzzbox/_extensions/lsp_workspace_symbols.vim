vim9script

import autoload 'fuzzbox/popup.vim'
import autoload 'fuzzbox/selector.vim'

import autoload 'lsp/lsp.vim'
import autoload 'lsp/buffer.vim' as buf
import autoload 'lsp/util.vim'
import autoload 'lsp/symbol.vim'

var symtable: list<dict<any>>
var lspserver: dict<any>
var cur_pattern: string

var async_limit = g:fuzzbox_async_limit

def ReplyCb(_: dict<any>, reply: list<dict<any>>)
    if empty(cur_pattern)
        popup.UpdateMenu([], [])
        popup.SetCounter(null)
        return
    elseif reply->empty()
        popup.UpdateMenu([], [])
        popup.SetCounter(0)
        return
    endif

    popup.SetCounter(len(reply))

    var hl_list = []
    var sep_pattern = '\:\d\+:\d\+'
    var str_list = reply[: async_limit]->map((i, v) => {
        var path = util.LspUriToFile(v.location.uri)
        var fname = fnamemodify(path, ':p:~:.')
        var lnum = v.location.range.start.line + 1
        var col = v.location.range.start.character + 1
        var kind = symbol.SymbolKindToName(v.kind)->tolower()
        var str = printf('%s:%d:%d %s <%s>', fname, lnum, col, v.name, kind)

        var offset = matchstrpos(str, sep_pattern)[2]
        var positions = matchfuzzypos([str[offset : -1]], cur_pattern)[1]
        if !empty(positions)
            for n in positions[0]
                add(hl_list, [i + 1] + [n + offset + 1])
            endfor
        endif

        return str
    })

    popup.UpdateMenu(str_list, hl_list)
enddef

def Input(wid: number, pattern: string)
    cur_pattern = pattern
    if empty(pattern)
        popup.UpdateMenu([], [])
        return
    endif
    popup.SetLoading()
    lspserver.rpc_a('workspace/symbol', {query: pattern}, ReplyCb)
enddef

def Close(wid: number)
    # release memory
    symtable = [{}]
    lspserver = {}
enddef

export def Start(opts: dict<any> = {})
    opts.title = has_key(opts, 'title') ? opts.title : 'LSP Workspace Symbols'

    lspserver = buf.BufLspServerGet(bufnr(), 'workspaceSymbol')
    if lspserver->empty()
        echo 'LSP server not found'
        return
    elseif !lspserver.running || !lspserver.ready
        echo 'LSP server not ready'
        return
    endif

    var wids = selector.Start([], extend(opts, {
        input_cb: function('Input'),
        close_cb: function('Close'),
        counter: false
     }))

    win_execute(wids.menu, $'syn match NonText "<\w\+>"')
enddef
