function! MakeReadonly( filespec )
    if has('win32') || has('win64')
	call vimtest#System('attrib +R ' . escapings#shellescape(a:filespec))
    else
	call vimtest#System('chmod -w ' . escapings#shellescape(a:filespec))
    endif
endfunction

