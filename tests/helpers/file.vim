function! MakeReadonly( filespec )
    if has('win32') || has('win64')
	call vimtest#System('attrib +R ' . ingo#compat#shellescape(a:filespec))
    else
	call vimtest#System('chmod -w ' . ingo#compat#shellescape(a:filespec))
    endif
endfunction

