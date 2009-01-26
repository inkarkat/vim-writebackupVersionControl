function! CanonicalizeFilespec( filespec, replacement )
    execute '%s/\V' . substitute(a:filespec, '[/\\]', '\\[/\\\\]', 'g') . '\[/\\]\?/' . escape(a:replacement, '/\') . '/ge'
endfunction

function! CanonicalizeFilespecVariable( filespecVariableName )
    execute 'let l:filespec = ' . a:filespecVariableName
    return CanonicalizeFilespec(l:filespec, a:filespecVariableName)
endfunction

