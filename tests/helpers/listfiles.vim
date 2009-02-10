function! ListFiles( testFilespec )
    new
    execute 'cd ' . fnamemodify(a:testFilespec, ':p:h')
    0r !listfiles
    call vimtest#SaveOut()
endfunction

