function! MakeReadonly( filespec )
    if has('win32') || has('win64')
	call vimtest#System('attrib +R ' . a:filespec)
    else
	call vimtest#System('chmod -w ' . a:filespec)
    endif
endfunction

