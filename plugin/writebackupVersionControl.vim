" Version control functions (diff, restore) for backups with date file extension
" (format '.YYYYMMDD[a-z]' in the same directory as the original file itself. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
" REVISION	DATE		REMARKS 
"	0.02	31-Oct-2006	Added WriteBackupListVersions. 
"				Added EchoElapsedTimeSinceVersion as an add-on
"				to WriteBackupListVersions. 
"				Added WriteBackupIsBackedUp. 
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

let s:versionRegexp = '\.[12]\d\d\d\d\d\d\d[a-z]$'
let s:versionFileGlob = '.[12][0-9][0-9][0-9][0-9][0-9][0-9][0-9][a-z]'
let s:versionLength = 10 " 1 dot + 4 year + 2 month + 2 day + 1 letter

function! s:GetFilename( filespec )
    if a:filespec =~ s:versionRegexp
	return strpart( a:filespec, 0, len( a:filespec ) - s:versionLength )
    else
	return a:filespec
    endif
endfunction

function! s:GetVersion( filespec )
    if a:filespec =~ s:versionRegexp
	return strpart( a:filespec, len( a:filespec ) - s:versionLength + 1 )
    else
	return ''
    endif
endfunction

function! s:GetAllVersionsForFile( filespec )
    let l:backupfiles = split( glob( a:filespec . s:versionFileGlob ), "\n" )
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

function! s:DiffWithPred( filespec )
    let l:predecessor = s:GetPredecessorForFile( a:filespec )
    if empty( l:predecessor )
	echohl Error
	echomsg "No predecessor found for file '" . expand('%') . "'."
	echohl None
    else
"****D echo '**** predecessor is ' . l:predecessor
	if g:writebackup_DiffVertSplit == 1
	    let l:splittype=':vert diffsplit '
	else
	    let l:splittype=':diffsplit '
	endif
	execute l:splittype . l:predecessor

    endif
endfunction

function! s:DualDigit( number )
    let l:digits = a:number + ''
    while len( l:digits ) < 2
	let l:digits = '0' . l:digits
    endwhile
    return strpart( l:digits, 0, 2 )
endfunction

function! s:EchoElapsedTimeSinceVersion( backupFile )
    let l:timeElapsed = localtime() - getftime( a:backupFile )
    let l:secondsElapsed = l:timeElapsed % 60
    let l:minutesElapsed = (l:timeElapsed / 60) % 60
    let l:hoursElapsed = (l:timeElapsed / 3600) % 24
    let l:daysElapsed = (l:timeElapsed / (3600 * 24))
    let l:message = 'The last backup was done '
    if l:daysElapsed > 0
	let l:message .= l:daysElapsed . ' days, '
    endif
    let l:message .= s:DualDigit(l:hoursElapsed) . ':' . s:DualDigit(l:minutesElapsed) . ':' . s:DualDigit(l:secondsElapsed) . ' ago.'

    echomsg l:message
endfunction

function! s:ListVersions( filespec )
    let l:currentFilename = s:GetFilename( a:filespec )
    let l:currentVersion = s:GetVersion( a:filespec )
    let l:backupfiles = s:GetAllVersionsForFile( l:currentFilename )
    if empty( l:backupfiles )
	echomsg "No backups exist for file '" . s:GetFilename( l:currentFilename ) . "'. "
	return
    endif

    let l:versionMessageHeader = "These backups exist for file '" . s:GetFilename( l:currentFilename ) . "'"
    let l:versionMessageHeader .= ( empty(l:currentVersion) ? ': ' : ' (current version is marked >x<): ')
    echomsg l:versionMessageHeader
    let l:versionMessage = ''
    let l:version = ''
    for l:backupfile in l:backupfiles
	let l:previousVersion = l:version
	let l:version = s:GetVersion( l:backupfile )
	if strpart( l:version, 0, len(l:version) - 1 ) == strpart( l:previousVersion, 0, len(l:previousVersion) - 1 )
	    let l:versionMessageAddition = strpart( l:version, len(l:version) - 1 )
	    if l:version == l:currentVersion
		let l:versionMessageAddition = '>' . l:versionMessageAddition . '<'
	    endif
	    let l:versionMessage .= l:versionMessageAddition
	else
	    echomsg l:versionMessage 
	    let l:versionMessage = l:version
	    if l:version == l:currentVersion
		let l:versionMessage= strpart( l:versionMessage, 0, len(l:versionMessage) - 1 ). '>' . strpart( l:versionMessage, len(l:versionMessage) - 1 ) . '<'
	    endif
	endif
    endfor
    echomsg l:versionMessage

    if empty( l:currentVersion )
	let l:lastBackupFile = l:backupfiles[ len( l:backupfiles ) - 1 ]
	call s:EchoElapsedTimeSinceVersion( l:lastBackupFile )
    endif
endfunction

function! s:IsBackedUp( filespec )
    if ! empty( s:GetVersion( a:filespec ) )
	echohl Error
	echomsg 'You can only check the backup status of the original file, not of backups!'
	echohl None
	return
    endif

    let l:predecessor = s:GetPredecessorForFile( a:filespec )
    if empty( l:predecessor )
	echohl Error
	echomsg "No predecessor found for file '" . expand('%') . "'."
	echohl None
	return
    endif

    let l:diffCmd = 'silent !diff "' . l:predecessor . '" "' . a:filespec . '"'
    execute l:diffCmd
"****D echo '**** diff return code=' . v:shell_error

    if v:shell_error == 0
	echomsg "The current version of '" . a:filespec . "' is identical with the latest backup version '" . s:GetVersion( l:predecessor ) . "'. "
    elseif v:shell_error == 1
	echohl WarningMsg
	echomsg "The current version of '" . a:filespec . "' is different from the latest backup version '" . s:GetVersion( l:predecessor ) . "'. "
	echohl None
    elseif v:shell_error >= 2
	echohl Error
	echomsg "Encountered problems with the 'diff' tool. Unable to compare with latest backup. "
	echohl None
    endif
endfunction

command! WriteBackupDiffWithPred :call <SID>DiffWithPred(expand('%'))
command! WriteBackupListVersions :call <SID>ListVersions(expand('%'))
command! WriteBackupIsBackedUp :call <SID>IsBackedUp(expand('%'))
"command! WriteBackupRestoreFromPred
"command! WriteBackupRestoreThisBackup

