function! Setup( testFilespec )
    let l:pathSeparator = (has('win32') || has('win64') ? ';' : ':')
    let $PATH .= l:pathSeparator .  fnamemodify(a:testFilespec, ':p:h')
    silent ! setup
endfunction
function! ListFiles()
    new
    0r !listfiles
    call vimtest#SaveOut()
endfunction

