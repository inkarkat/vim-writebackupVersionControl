function! ListFiles( testFilespec )
    new
    execute 'cd ' . fnamemodify(a:testFilespec, ':p:h')
    0r !listfiles
    execute 'saveas! ' . fnamemodify(a:testFilespec, ':p:r') . '.out'
endfunction

