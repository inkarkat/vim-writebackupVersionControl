function! MakeReadonly( filespec )
    if ingo#os#IsWinOrDos()
	call vimtest#System('attrib +R ' . ingo#compat#shellescape(a:filespec))
    else
	call vimtest#System('chmod -w ' . ingo#compat#shellescape(a:filespec))
    endif
endfunction
