vim9script

import autoload 'fuzzbox/internal/selector.vim'
import autoload 'fuzzbox/popup.vim'

import autoload 'lsp/lsp.vim'
import autoload 'lsp/buffer.vim' as buf
import autoload 'lsp/util.vim'
import autoload 'lsp/symbol.vim'

var symtable: list<dict<any>>
var lspserver: dict<any>
var cur_pattern: string

var async_limit = 200

def ReplyCb(_: dict<any>, reply: list<dict<any>>)
    if empty(cur_pattern) || reply->empty()
        selector.UpdateMenu([], [])
        popup.SetCounter(null)
        return
    endif

    popup.SetCounter(len(reply))

    var hl_list = []
    var hl_len = len(cur_pattern)
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

    selector.UpdateMenu(str_list, hl_list)
enddef

def Input(wid: number, result: string)
    cur_pattern = result
    if empty(result)
        return
    endif
    lspserver.rpc_a('workspace/symbol', {query: result}, ReplyCb)
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
        counter: false
     }))

    win_execute(wids.menu, $'syn match NonText "<\w\+>"')
enddef
