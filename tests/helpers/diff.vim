function! EchoDiff()
    let l:winNr = winnr()
    windo setlocal diff?
    execute l:winNr . 'wincmd w' 
endfunction
