" Version control functions (diff, restore) for backups with date file extension
" (format '.YYYYMMDD[a-z]' in the same directory as the original file itself. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" REVISION	DATE		REMARKS 
"	0.01	30-Oct-2006	file creation

" Avoid installing twice or when in compatible mode
if exists("loaded_writebackupVersionControl")
    finish
endif
let loaded_writebackupVersionControl = 1

" Allow user to specify diffsplit of horiz. or vert.
if !exists('g:writebackup_DiffVertSplit')
  let g:writebackup_DiffVertSplit = 1  " Default to split for diff vertically. 
endif

function! s:GetFilename( filespec )
    if a:filespec =~ '\.[12]\d\d\d\d\d\d\d[a-z]$'
	return strpart( a:filespec, 0, len( a:filespec ) - 10 )
    else
	return a:filespec
    endif
endfunction

function! s:GetVersion( filespec )
    if a:filespec =~ '\.[12]\d\d\d\d\d\d\d[a-z]$'
	return strpart( a:filespec, len( a:filespec ) - 10 + 1 )
    else
	return ''
    endif
endfunction

function! s:GetAllVersionsForFile( filespec )
    let l:backupfiles = split( glob( a:filespec . '.[12][0-9][0-9][0-9][0-9][0-9][0-9][0-9][a-z]' ), "\n" )
    " Although the glob should already be sorted alphabetically in ascending
    " order, we'd better be sure and sort the list on our own, too. 
    let l:backupfiles = sort( l:backupfiles )
"****D echo '**** backupfiles: ' . l:backupfiles
    return l:backupfiles
endfunction

function! s:RemoveNewerBackupsFrom( backupfiles, currentVersion )
"*******************************************************************************
"* PURPOSE:
"   Removes files that are newer or equal to a:currentVersion. 
"* ASSUMPTIONS / PRECONDITIONS:
"   none
"* EFFECTS / POSTCONDITIONS:
"   Truncates a:backupfiles so that any file version contained is older than a:currentVersion. 
"* INPUTS:
"   a:backupfiles: sorted list of filespecs. 
"   a:currentVersion: version number used as the exclusion criterium. 
"* RETURN VALUES: 
"   none
"*******************************************************************************
    let l:fileCnt = 0
    while l:fileCnt < len( a:backupfiles )
	if s:GetVersion( a:backupfiles[ l:fileCnt ] ) >= a:currentVersion 
"****D echo '**** removing indexes ' . l:fileCnt . ' to ' . (len( a:backupfiles ) - 1)
	    call remove( a:backupfiles, l:fileCnt, len( a:backupfiles ) - 1 )
"****D call confirm('debug')
	    break
	endif
	let l:fileCnt += 1
    endwhile
endfunction

function! s:GetPredecessorForFile( filespec )
"*******************************************************************************
"* PURPOSE:
"   Gets the filespec of the predecessor of the passed filespec, regardless of
"   whether the passed filespec is the current file (without a version
"   extension), or a versioned backup. 
"* ASSUMPTIONS / PRECONDITIONS:
"   a:filespec is a valid file. 
"* EFFECTS / POSTCONDITIONS:
"   none
"* INPUTS:
"   a:filespec
"* RETURN VALUES: 
"   filespec to the predecessor version. 
"*******************************************************************************
    let l:currentFilename = s:GetFilename( a:filespec )
    let l:currentVersion = s:GetVersion( a:filespec )

    let l:backupfiles = s:GetAllVersionsForFile( l:currentFilename )
    if ! empty( l:currentVersion )
	call s:RemoveNewerBackupsFrom( l:backupfiles, l:currentVersion )
    endif

    if empty( l:backupfiles )
	return ''
    else
	let l:predecessor = l:backupfiles[ len( l:backupfiles ) - 1 ]
	return l:predecessor
    endif
endfunction

function! s:DiffWithPred()
    let l:predecessor = s:GetPredecessorForFile( expand("%") )
    if empty( l:predecessor )
	echohl Error
	echomsg "No predecessor found for file '" . expand("%") . "'."
	echohl None
    else
"****D echo '**** predecessor is ' . l:predecessor
	if g:writebackup_DiffVertSplit == 1
	    let l:splittype=":vert diffsplit "
	else
	    let l:splittype=":diffsplit "
	endif
	execute l:splittype . l:predecessor

    endif
endfunction

command! WriteBackupDiffWithPred :call <SID>DiffWithPred()

"command! WriteBackupRestoreFromPred
"command! WriteBackupRestoreThisBackup

