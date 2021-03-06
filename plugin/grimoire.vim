let g:grimoire#base_url = "http://conj.io"
let g:grimoire#api_base_url = g:grimoire#base_url . "/api/v0"
let g:grimoire#doc_base_url = g:grimoire#base_url . "/store/"
let g:grimoire#version = "1.7.0"

function! grimoire#get_maven_info(symbol_info)
    let name = get(a:symbol_info, 'ns')
    call fireplace#eval("(require 'grimvim.core)")
    return fireplace#evalparse('(grimvim.core/get-maven-info "' . name . '")')
endfunction

function! grimoire#munge_name(name)
    return fireplace#evalparse('(grimoire.util/munge "' . a:name . '")')
endfunction

function! grimoire#make_api_url(query)
    return g:grimoire#api_base_url . "?" . a:query . "&type=edn"
endfunction

function! grimoire#make_doc_url(groupid, artifactid, version, namespace, symbol)
    let url =
        \ g:grimoire#doc_base_url .
        \ a:groupid . "/" .
        \ a:artifactid . "/" .
        \ a:version . "/" .
        \ a:namespace . "/" .
        \ a:symbol . "/?type=text/plain"
    return url
endfunction

function! grimoire#get_groups()
    let url = grimoire#make_api_url("op=groups")
    let code = "(map :name (:body (read-string (slurp \"" . url . "\"))))"
    return fireplace#evalparse(code)
endfunction

function! grimoire#check_group_supported(group)
    let groups = grimoire#get_groups()
    if index(groups, a:group) >= 0
        return 1
    else
        throw "grimoire.vim: group " . a:group . " not supported"
endfunction

function! grimoire#get_doc_url_of_current_word()
    let word = expand("<cword>")
    let symbol_info = fireplace#info(word)
    let maven_info = grimoire#get_maven_info(symbol_info)
    let namespace = get(symbol_info, 'ns')
    let name = get(symbol_info, 'name')
    "let ver = get(maven_info, 'version')
    let ver = g:grimoire#version
    let group_id = get(maven_info, 'groupId')
    let artifact_id = get(maven_info, 'artifactId')
    call grimoire#check_group_supported(group_id)
    return grimoire#make_doc_url(group_id, artifact_id, ver, namespace, name)
endfunction

function! grimoire#browse_doc()
    let url = grimoire#get_doc_url_of_current_word()
    :new
    execute ":norm i" . url
    :norm 0gx
    :bd!
endfunction

function! grimoire#buffer_doc()
    let @a = grimoire#get_doc()
    :new
    :nnoremap <buffer> q :bd!<cr>
    execute "put a"
endfunction

function! grimoire#get_doc()
    let url = grimoire#get_doc_url_of_current_word()
    return fireplace#evalparse('(slurp "' . url . '")')
endfunction

command! Grim echo grimoire#get_doc()
command! GrimBuffer call grimoire#buffer_doc()
command! GrimBrowse call grimoire#browse_doc()
