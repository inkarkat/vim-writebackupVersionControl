function! ListFiles()
    new
    0r !listfiles
    call vimtest#SaveOut()
endfunction

