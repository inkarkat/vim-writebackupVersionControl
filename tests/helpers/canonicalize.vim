function! CanonicalizeFilespec( expr, filespec, replacement )
    return substitute(substitute(a:expr, '\\', '/', 'g'), '\V' . substitute(a:filespec, '\\', '/', 'g') . '/\?', a:replacement, 'g')
endfunction

function! CanonicalizeFilespecVariable( expr, filespecVariableName )
    execute 'let l:filespec = ' . a:filespecVariableName
    return CanonicalizeFilespec(a:expr, l:filespec, a:filespecVariableName)
endfunction

