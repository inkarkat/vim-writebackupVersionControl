" writebackupVersionControl.vim: Version control functions (diff, restore,
" history navigation) for writebackup.vim backups with date file extension
" (format '.YYYYMMDD[a-z]'). 
"
" DEPENDENCIES:
"   - External commands 'diff', 'cp' (Unix), 'copy' (Windows). 
"
" Copyright: (C) 2007-2009 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"   2.00.002	18-Feb-2009	BF: :WriteBackupListVersions now handles (and
"				reports) backup files with a future date. (This
"				can happen when writing on a Samba share that
"				has a different clock setting.)
"				Exposed
"				writebackupVersionControl#IsOriginalFile()
"				function for writebackup.vim so that it can
"				disallow backup of backup file. 
"				BF: Didn't correctly catch writebackup.vim
"				exceptions. This could happen when running out
"				of backup names in :WriteBackupOfSavedOriginal. 
"				Added '--' argument to Unix 'cp' command so that
"				files starting with '-' are copied correctly. 
"   2.00.001	17-Feb-2009	Moved functions from plugin to separate autoload
"				script. 
"				writebackup.vim has replaced its global
"				WriteBackup_...() functions with autoload
"				functions writebackup#...(). This is an
"				incompatible change that also requires the
"				corresponding changes in here. 
"				file creation

let s:save_cpo = &cpo
set cpo&vim

let s:versionRegexp = '\.[12]\d\d\d\d\d\d\d[a-z]$'
let s:versionFileGlob = '.[12][0-9][0-9][0-9][0-9][0-9][0-9][0-9][a-z]'
let s:versionLength = 10 " 1 dot + 4 year + 2 month + 2 day + 1 letter

"- utility functions ----------------------------------------------------------
function! s:ErrorMsg( text )
    echohl ErrorMsg
    let v:errmsg = a:text
    echomsg v:errmsg
    echohl None
endfunction
function! s:WarningMsg( text )
    echohl WarningMsg
    let v:warningmsg = a:text
    echomsg v:warningmsg
    echohl None
endfunction
function! s:ExceptionMsg( exception )
    call s:ErrorMsg(substitute(v:exception, '^WriteBackup\%(VersionControl\)\?:\s*', '', ''))
endfunction

"- conversion functions -------------------------------------------------------
function! writebackupVersionControl#IsOriginalFile( filespec )
    return a:filespec !~? s:versionRegexp
endfunction

function! s:GetOriginalFilespec( filespec, isForDisplayingOnly )
"*******************************************************************************
"* PURPOSE:
"   The passed a:filespec may be any ordinary file, an original file that has
"   backups, or a backup file. In the last case, it is tried to determine the
"   original filespec. This is only guaranteed to work when backups are
"   created in the same directory as the original file. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:filespec	backup or original file
"   a:isForDisplayingOnly   If true, returns an approximation of the original
"	file for use in a user message in case it cannot be resolved. If false,
"	return an empty string in that case. 
"* RETURN VALUES: 
"	original filespec, or empty string, or approximation
"*******************************************************************************
    if writebackupVersionControl#IsOriginalFile( a:filespec )
	return a:filespec
    else
	" Since a:filespec is no original file, it thusly ends with the backup
	" date file extension, and we can simply cut it off. 
	let l:adjustedBackupFilespec = strpart( a:filespec, 0, len( a:filespec ) - s:versionLength )

	let l:backupDirspec = ''
	try
	    let l:backupDirspec = writebackup#GetBackupDir(l:adjustedBackupFilespec, 1)
	catch
	    " Ignore exceptions, they just signal that the backup dir could not
	    " be determined or that a backup should not be written. We're just
	    " interested in the backup dir here, but we can live with the fact
	    " that the backup dir is unknown. 
	endtry
	if  l:backupDirspec == '.' && filereadable(l:adjustedBackupFilespec)
	    " If backups are created in the same directory, we can get the original
	    " file by stripping off the date file extension. 
	    " A buffer-local backup directory configuration which only exists for
	    " the original file buffer, but not the backup file buffer may fool us
	    " here into believing that backups are created in the same directory, so
	    " we explicitly check that the original file exists there as well. 
	    return l:adjustedBackupFilespec
	else
	    " If backups are created in a different directory, the complete filespec
	    " of the original file can not be derived from the adjusted backup
	    " filespec, as writebackup#AdjustFilespecForBackupDir() (potentially) is
	    " a one-way transformation from multiple directories to one backup
	    " directory. 
	    "
	    " TODO: Look for original file candidates in all VIM buffers via bufname(). 
	    "
	    " When we fail, return an empty string to indicate that the original
	    " filespec could not be resolved. However, if the filespec is only
	    " needed for a user message, we can generate an approximation, which is
	    " better than nothing. 
	    if a:isForDisplayingOnly
		return '???/' . fnamemodify( l:adjustedBackupFilespec, ':t' )
	    else
		return ''
	    endif
	endif
    endif
endfunction

function! s:GetVersion( filespec )
    if ! writebackupVersionControl#IsOriginalFile( a:filespec )
	return strpart( a:filespec, len( a:filespec ) - s:versionLength + 1 )
    else
	return ''
    endif
endfunction

function! s:GetAdjustedBackupFilespec( filespec )
"*******************************************************************************
"* PURPOSE:
"   The adjustedBackupFilespec is an imaginary file in the backup directory. By
"   appending a backup version, a valid backup filespec is created. 
"   In case the backup is done in the same directory as the original file, the
"   adjustedBackupFilespec is equal to the original file. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:filespec	backup or original file
"* RETURN VALUES: 
"   adjustedBackupFilespec; the backup directory may not yet exist when no
"   backups have yet been made. 
"   Throws 'WriteBackup:' or any exception resulting from query for backup dir. 
"*******************************************************************************
    if writebackupVersionControl#IsOriginalFile( a:filespec )
	return writebackup#AdjustFilespecForBackupDir( a:filespec, 1 )
    else
	return strpart( a:filespec, 0, len( a:filespec ) - s:versionLength )
    endif
endfunction

"------------------------------------------------------------------------------
function! s:VerifyIsOriginalFileAndHasPredecessor( filespec, notOriginalMessage )
"*******************************************************************************
"* PURPOSE:
"   Checks that a:filespec is not a backup file and that at least one backup for
"   this file exists. If not, an error message is echoed; in the first case,
"   the passed a:notOriginalMessage is used. 
"* ASSUMPTIONS / PRECONDITIONS:
"   none
"* EFFECTS / POSTCONDITIONS:
"   none
"* INPUTS:
"   a:filespec	backup or original file
"   a:notOriginalMessage
"* RETURN VALUES: 
"   empty string if verification failed; filespec of predecessor otherwise. 
"*******************************************************************************
    if ! writebackupVersionControl#IsOriginalFile( a:filespec )
	call s:ErrorMsg(a:notOriginalMessage)
	return ''
    endif

    let l:predecessor = s:GetRelativeBackup( a:filespec, -1 )
    return l:predecessor
endfunction

"------------------------------------------------------------------------------
function! s:GetAllBackupsForFile( filespec )
"*******************************************************************************
"* PURPOSE:
"   Retrieves a list of all filespecs of backup files for a:filespec. 
"   The list is sorted from oldest to newest backup. The original filespec is
"   not part of the list. 
"* ASSUMPTIONS / PRECONDITIONS:
"   none
"* EFFECTS / POSTCONDITIONS:
"   none
"* INPUTS:
"   a:filespec	backup or original file
"* RETURN VALUES: 
"   sorted list of backup filespecs
"*******************************************************************************
    " glob() filters out file patterns defined in 'wildignore'. If someone wants
    " to ignore backup files for command-mode file name completion and puts the
    " backup file pattern into 'wildignore', this function will break. 
    " Thus, the 'wildignore' option is temporarily reset here. 
    if has('wildignore')
	let l:save_wildignore = &wildignore
	set wildignore=
    endif
    try
	" For globbing, we need the filespec of an imaginary file in the backup
	" directory, to which we can append our file version glob. (The backup
	" files may reside in a directory different from the original file;
	" that's why we cannot simply use the original filespec for globbing.)  
	let l:adjustedBackupFilespec = s:GetAdjustedBackupFilespec(a:filespec)

	" glob() will do the right thing and return an empty list if
	" l:adjustedBackupFilespec doesn't yet exist, because no backup has yet been
	" made. 
	let l:backupfiles = split( glob( l:adjustedBackupFilespec . s:versionFileGlob ), "\n" )

	" Although the glob should already be sorted alphabetically in ascending
	" order, we'd better be sure and sort the list on our own, too. 
	let l:backupfiles = sort( l:backupfiles )
"****D echo '**** backupfiles: ' . l:backupfiles
	return l:backupfiles
    finally
	if has('wildignore')
	    let &wildignore = l:save_wildignore
	endif
    endtry

endfunction

function! s:GetIndexOfVersion( backupfiles, currentVersion )
"*******************************************************************************
"* PURPOSE:
"   Determine the index of the backup version a:currentVersion in the passed
"   list of backup files. 
"* ASSUMPTIONS / PRECONDITIONS:
"   none
"* EFFECTS / POSTCONDITIONS:
"   none
"* INPUTS:
"   a:backupfiles: list of backup filespecs. 
"   a:currentVersion: version number of the backup filespec to be found. 
"* RETURN VALUES: 
"   Index into a:backupfiles or -1 if a:currentVersion isn't contained in
"   a:backupfiles. 
"*******************************************************************************
    let l:fileCnt = 0
    while l:fileCnt < len( a:backupfiles )
	if s:GetVersion( a:backupfiles[ l:fileCnt ] ) == a:currentVersion 
	    return l:fileCnt
	endif
	let l:fileCnt += 1
    endwhile
    return -1
endfunction
function! s:GetRelativeBackup( filespec, relativeIndex )
"*******************************************************************************
"* PURPOSE:
"   Gets the filespec of a predecessor or later version of the passed
"   filespec, regardless of whether the passed filespec is the current file
"   (without a version extension), or a versioned backup. 
"   If the index is out of bounds, the first / last available backup version
"   is returned. If a:filespec is the first / last backup version / original
"   file, an error is printed and an empty string is returned. 
"* ASSUMPTIONS / PRECONDITIONS:
"   none
"* EFFECTS / POSTCONDITIONS:
"   none
"* INPUTS:
"   a:filespec	backup or original file
"   a:relativeIndex Negative numbers select predecessors, positive numbers
"	later versions. 
"* RETURN VALUES: 
"   Filespec of the backup version, or empty string if no such version
"   exists.  
"*******************************************************************************
    let l:backupfiles = s:GetAllBackupsForFile(a:filespec)
    let l:lastBackupIndex = len(l:backupfiles) - 1
    let l:currentIndex = (writebackupVersionControl#IsOriginalFile(a:filespec) ? l:lastBackupIndex + 1 : s:GetIndexOfVersion( l:backupfiles, s:GetVersion(a:filespec) ))

    if l:currentIndex < 0
	call s:ErrorMsg("Couldn't locate this backup: " . a:filespec)
	return ''
    elseif l:lastBackupIndex < 0
	call s:ErrorMsg('No backups exist for this file.')
	return ''
    elseif a:relativeIndex > 0 && l:currentIndex == l:lastBackupIndex
	call s:ErrorMsg("This is the latest backup: " . a:filespec)
	return ''
    elseif a:relativeIndex > 0 && l:currentIndex > l:lastBackupIndex
	call s:ErrorMsg('Cannot go beyond original file.')
	return ''
    elseif a:relativeIndex < 0 && l:currentIndex == 0
	call s:ErrorMsg('This is the earliest backup: ' . a:filespec)
	return ''
    endif

    let l:newIndex = min([max([l:currentIndex + a:relativeIndex, 0]), l:lastBackupIndex])
    return get( l:backupfiles, l:newIndex, '' )
endfunction

function! s:EditFile( filespec, isBang )
"*******************************************************************************
"* PURPOSE:
"   Edit a:filespec in the current window (via :edit). 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:filespec	backup or original file
"   a:isBang	Flag whether any changes to the current buffer should be
"	discarded. 
"* RETURN VALUES: 
"   None. 
"*******************************************************************************
    if ! empty(a:filespec)
	try
	    execute 'edit' . (a:isBang ? '!' : '') escape( tr( a:filespec, '\', '/'), ' \%#' )
	catch /^Vim\%((\a\+)\)\=:E/
	    " v:exception contains what is normally in v:errmsg, but with extra
	    " exception source info prepended, which we cut away. 
	    call s:ErrorMsg(substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', ''))
	endtry
    endif
endfunction
function! writebackupVersionControl#WriteBackupGoOriginal( filespec, isBang )
"*******************************************************************************
"* PURPOSE:
"   Edit the original file of the passed backup file a:filespec. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:filespec	backup or original file
"   a:isBang	Flag whether any changes to the current buffer should be
"	discarded. 
"* RETURN VALUES: 
"   None. 
"*******************************************************************************
    try
	if writebackupVersionControl#IsOriginalFile( a:filespec )
	    echomsg "This is the original file."
	    return
	endif

	let l:originalFilespec = s:GetOriginalFilespec( a:filespec, 0 )
	if empty( l:originalFilespec )
	    call s:ErrorMsg('Unable to determine the location of the original file.')
	else
	    call s:EditFile(l:originalFilespec, a:isBang)
	endif
    catch /^WriteBackup\%(VersionControl\)\?:/
	call s:ExceptionMsg(v:exception)
    endtry
endfunction
function! writebackupVersionControl#WriteBackupGoBackup( filespec, isBang, relativeIndex )
"*******************************************************************************
"* PURPOSE:
"   Edit a backup file version relative to the current file. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:filespec	backup or original file
"   a:isBang	Flag whether any changes to the current buffer should be
"	discarded. 
"   a:relativeIndex 
"* RETURN VALUES: 
"   None. 
"*******************************************************************************
    try
	call s:EditFile( s:GetRelativeBackup( a:filespec, a:relativeIndex ), a:isBang )
    catch /^WriteBackup\%(VersionControl\)\?:/
	call s:ExceptionMsg(v:exception)
    endtry
endfunction

function! writebackupVersionControl#DiffWithPred( filespec )
"*******************************************************************************
"* PURPOSE:
"   Creates a diff with the predecessor of the passed a:filespec. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:filespec	backup or original file
"* RETURN VALUES: 
"   none
"*******************************************************************************
    try
	let l:predecessor = s:GetRelativeBackup( a:filespec, -1 )
	if ! empty( l:predecessor )
"****D echo '**** predecessor is ' . l:predecessor
	    " Close all folds before :diffsplit; this avoids that a previous (open)
	    " fold status at the cursor position is remembered and obscures the
	    " actual differences. 
	    if has('folding') | setlocal foldlevel=0 | endif

	    let l:splittype = (g:WriteBackup_DiffVertSplit ? 'vert ' : '') . 'diffsplit'

	    " Expand the predecessor's filespec to an absolute path, because the CWD
	    " may change when a file is opened (e.g. due to autocmds or :set
	    " autochdir). 
	    execute l:splittype . ' ' . escape( tr( fnamemodify(l:predecessor, ':p'), '\', '/'), ' \%#' )

	    " Return to original window. 
	    wincmd p
	endif
    catch /^WriteBackup\%(VersionControl\)\?:/
	call s:ExceptionMsg(v:exception)
    endtry
endfunction

function! s:DualDigit( number )
"*******************************************************************************
"* PURPOSE:
"   Formats the passed number as a dual-digit string. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"	? Explanation of each argument that isn't obvious.
"* RETURN VALUES: 
"	? Explanation of the value returned.
"*******************************************************************************
    let l:digits = a:number + ''
    while len( l:digits ) < 2
	let l:digits = '0' . l:digits
    endwhile
    return strpart( l:digits, 0, 2 )
endfunction
function! s:EchoElapsedTimeSinceVersion( backupFile )
"*******************************************************************************
"* PURPOSE:
"   Informs the user about the elapsed time since the passed a:backupFile has
"   been modified. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"	? Explanation of each argument that isn't obvious.
"* RETURN VALUES: 
"   none
"*******************************************************************************
    let l:timeElapsed = localtime() - getftime( a:backupFile )
    let l:isBackupInFuture = 0
    if l:timeElapsed < 0
	let l:timeElapsed = -1 * l:timeElapsed
	let l:isBackupInFuture = 1
    endif

    let l:secondsElapsed = l:timeElapsed % 60
    let l:minutesElapsed = (l:timeElapsed / 60) % 60
    let l:hoursElapsed = (l:timeElapsed / 3600) % 24
    let l:daysElapsed = (l:timeElapsed / (3600 * 24))

    let l:message = printf(
    \	(l:isBackupInFuture ?
    \	    'The last backup has a modification date %s%s:%s:%s in the future?!' :
    \	    'The last backup was done %s%s:%s:%s ago.'
    \	),
    \	(l:daysElapsed > 0 ? l:daysElapsed . ' days, ' : ''),
    \	s:DualDigit(l:hoursElapsed),
    \	s:DualDigit(l:minutesElapsed),
    \	s:DualDigit(l:secondsElapsed)
    \)

    echomsg l:message
endfunction
function! s:GetBackupDir( originalFilespec )
"*******************************************************************************
"* PURPOSE:
"   Resolves the directory that contains the backup files. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"   a:originalFilespec
"* RETURN VALUES: 
"   dirspec representing the backup directory, '.' if equal to the original
"   file's directory. 
"   Throws 'WriteBackup:' or any exception resulting from query for backup dir. 
"*******************************************************************************
    let l:backupDirspec = writebackup#GetBackupDir(a:originalFilespec, 1)
    if l:backupDirspec ==# '.'
	return l:backupDirspec
    endif

    " Convert both original file's directory and backup directory to absolute
    " paths in order to compare for equality. 
    let l:originalDirspec = fnamemodify(a:originalFilespec, ':p:h')
    " Note: Must use :p:h modifier on dirspec to remove trailing path separator
    " left by :p. 
    let l:absoluteBackupDirspec = fnamemodify(l:backupDirspec, ':p:h')
    if l:absoluteBackupDirspec ==# l:originalDirspec
	return '.'
    endif

    " The backup dir is (or at least, looks) different from the original file's. 
    " Return either full absolute path or relative to home directory, if
    " possible. 
    return fnamemodify(l:absoluteBackupDirspec, ':~')
endfunction
function! writebackupVersionControl#ListVersions( filespec )
"*******************************************************************************
"* PURPOSE:
"   Shows the user a list of all available versions for a:filespec. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"	? Explanation of each argument that isn't obvious.
"* RETURN VALUES: 
"   none
"*******************************************************************************
    try
	let l:originalFilespec = s:GetOriginalFilespec( a:filespec, 1 )
	let l:currentVersion = s:GetVersion( a:filespec )
	let l:backupDirspec = s:GetBackupDir(l:originalFilespec)
	let l:backupfiles = s:GetAllBackupsForFile(a:filespec)
	if empty( l:backupfiles )
	    echomsg "No backups exist for this file."
	    return
	endif

	let l:versionMessageHeader = "These backups exist for file '" . l:originalFilespec . "'" . (l:backupDirspec =~# '^\.\?$' ? '' : ' in ' . l:backupDirspec)
	let l:versionMessageHeader .= ( empty(l:currentVersion) ? ': ' : ' (current version is marked >x<): ')
	echomsg l:versionMessageHeader

	let l:versionMessage = ''
	let l:backupVersion = ''
	for l:backupfile in l:backupfiles
	    let l:previousVersion = l:backupVersion
	    let l:backupVersion = s:GetVersion( l:backupfile )
	    if strpart( l:backupVersion, 0, len(l:backupVersion) - 1 ) == strpart( l:previousVersion, 0, len(l:previousVersion) - 1 )
		let l:versionMessageAddition = strpart( l:backupVersion, len(l:backupVersion) - 1 )
		if l:backupVersion == l:currentVersion
		    let l:versionMessageAddition = '>' . l:versionMessageAddition . '<'
		endif
		let l:versionMessage .= l:versionMessageAddition
	    else
		echomsg l:versionMessage 
		let l:versionMessage = l:backupVersion
		if l:backupVersion == l:currentVersion
		    let l:versionMessage= strpart( l:versionMessage, 0, len(l:versionMessage) - 1 ). '>' . strpart( l:versionMessage, len(l:versionMessage) - 1 ) . '<'
		endif
	    endif
	endfor
	echomsg l:versionMessage

	if empty( l:currentVersion )
	    let l:lastBackupFile = l:backupfiles[-1]
	    call s:EchoElapsedTimeSinceVersion( l:lastBackupFile )
	endif
    catch /^WriteBackup\%(VersionControl\)\?:/
	call s:ExceptionMsg(v:exception)
    endtry
endfunction

function! writebackupVersionControl#IsBackedUp( filespec )
"*******************************************************************************
"* PURPOSE:
"   Informs the user whether there exists a backup for the passed a:filespec file. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"	? Explanation of each argument that isn't obvious.
"* RETURN VALUES: 
"   none
"   Throws 'WriteBackupVersionControl: Encountered problems...' 
"*******************************************************************************
    try
	let l:predecessor = s:VerifyIsOriginalFileAndHasPredecessor( a:filespec, 'You can only check the backup status of the original file, not of backups!' )
	if empty( l:predecessor )
	    return
	endif

	" As we compare the predecessor with the saved original file, not the actual
	" buffer contents (and this is what the user typically wants; checking
	" whether it is safe to write this buffer because an update exists), we add
	" a hint to the user message if the buffer is indeed modified. 
	let l:savedMsg = (&l:modified ? 'saved ' : '') 

	" Optimization: First compare the file sizes, as this is much faster than
	" performing an actual diff; we're not interested in the differences,
	" anyway, only if there *are* any!
	if getfsize( l:predecessor ) != getfsize( a:filespec )
	    call s:WarningMsg(printf("The current %sversion of '%s' is different from the latest backup version '%s'.", l:savedMsg, a:filespec, s:GetVersion(l:predecessor)))
	    return
	endif

	" Expand filespecs to absolute paths to avoid problems with CWD, especially
	" on Windows systems with UNC paths. 
	let l:predecessorFilespec = fnamemodify( l:predecessor, ':p' )
	let l:originalFilespec = fnamemodify( a:filespec, ':p' )

	" Note: We could save the effort of outputting the diff output to the
	" console if that didn't introduce platform-dependent code (NUL vs.
	" /dev/null) and meddling with the 'shellredir' setting. 
	let l:diffCmd = 'diff "' . l:predecessorFilespec . '" "' . l:originalFilespec . '"'
	call system( l:diffCmd )
"****D echo '**** diff return code=' . v:shell_error

	if v:shell_error == 0
	    echomsg printf("The current %sversion of '%s' is identical with the latest backup version '%s'.", l:savedMsg, a:filespec, s:GetVersion(l:predecessor))
	elseif v:shell_error == 1
	    call s:WarningMsg(printf("The current %sversion of '%s' is different from the latest backup version '%s'.", l:savedMsg, a:filespec, s:GetVersion(l:predecessor)))
	elseif v:shell_error >= 2
	    throw "WriteBackupVersionControl: Encountered problems with the 'diff' tool. Unable to compare with latest backup."
	endif
    catch /^WriteBackup\%(VersionControl\)\?:/
	call s:ExceptionMsg(v:exception)
    endtry
endfunction

function! s:Copy( source, target )
"*******************************************************************************
"* PURPOSE:
"   Copies a:source to a:target. If a:target exists, it is overwritten. 
"* ASSUMPTIONS / PRECONDITIONS:
"   none
"* EFFECTS / POSTCONDITIONS:
"   Creates / modifies a:target on the file system. 
"* INPUTS:
"   a:source filespec
"   a:target filespec
"* RETURN VALUES: 
"   none
"   Throws 'WriteBackupVersionControl: Unsupported operating system type.'
"   Throws copy command output if shell copy command failed. 
"*******************************************************************************
    " Expand filespecs to absolute paths to avoid problems with CWD, especially
    " on Windows systems with UNC paths. 
    let l:sourceFilespec = fnamemodify( a:source, ':p' )
    let l:targetFilespec = fnamemodify( a:target, ':p' )

    if has('win32') || has('win64')
	let l:copyCmd = 'copy /Y "' . l:sourceFilespec . '" "' . l:targetFilespec . '"'
    elseif has('unix')
	let l:copyCmd = 'cp -- "' . l:sourceFilespec . '" "' . l:targetFilespec . '"'
    else
	throw 'WriteBackupVersionControl: Unsupported operating system type.'
    endif

    let l:cmdOutput = system( l:copyCmd )
    if v:shell_error != 0
	throw l:cmdOutput
    endif
endfunction
function! s:Restore( source, target, confirmationMessage )
"*******************************************************************************
"* PURPOSE:
"   Restores a:source over an existing a:target. The user is asked to confirm
"   this destructive operation, using the passed a:confirmationMessage. 
"* ASSUMPTIONS / PRECONDITIONS:
"   none
"* EFFECTS / POSTCONDITIONS:
"   Modifies a:target on the file system. 
"* INPUTS:
"   a:source filespec
"   a:target filespec
"   a:confirmationMessage
"* RETURN VALUES: 
"   Boolean indicating whether the file has actually been restored. 
"   Throws 'WriteBackupVersionControl: Failed to restore file: <reason>'
"*******************************************************************************
    let l:response = confirm( a:confirmationMessage, "&No\n&Yes", 1, 'Question' )
    if l:response != 2
	echomsg 'Restore canceled.'
	return 0
    endif

    " We could restore using only VIM functionality:
    "	edit! a:target
    " 	normal ggdG
    " 	0read a:source
    " 	write
    " But that would make the target's modification date different from the one
    " of the source, which would fool superficial synchronization tools. 
    " In addition, there's the (small) risk that VIM autocmds or settings like
    " 'fileencoding' or 'fileformat' are now different from when the backup was
    " written, and may thus lead to conversion errors or different file
    " contents. 
    " Thus, we invoke an external command to create a perfect copy.
    " Unfortunately, this introduces platform-specific code. 
    try
	call s:Copy( a:source, a:target )
    catch
	throw 'WriteBackupVersionControl: Failed to restore file: ' . v:exception
    endtry
    return 1
endfunction
function! writebackupVersionControl#RestoreFromPred( originalFilespec )
"*******************************************************************************
"* PURPOSE:
"   Restores the passed original file with its latest backup. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"	? Explanation of each argument that isn't obvious.
"* RETURN VALUES: 
"   none
"*******************************************************************************
    try
	let l:predecessor = s:VerifyIsOriginalFileAndHasPredecessor( a:originalFilespec, 'You can only restore the original file, not a backup!' )
	if empty( l:predecessor )
	    return
	endif

	if s:Restore( l:predecessor, a:originalFilespec, printf("Really override this file with backup '%s'?", s:GetVersion(l:predecessor) ))
	    edit!
	endif
    catch /^WriteBackup\%(VersionControl\)\?:/
	call s:ExceptionMsg(v:exception)
    endtry
endfunction

function! writebackupVersionControl#RestoreThisBackup( filespec )
"*******************************************************************************
"* PURPOSE:
"   Restores the passed file as the original file. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"	? Explanation of each argument that isn't obvious.
"* RETURN VALUES: 
"   none
"*******************************************************************************
    try
	let l:currentVersion = s:GetVersion( a:filespec )
	if empty( l:currentVersion )
	    call s:ErrorMsg('You can only restore backup files!')
	    return
	endif

	let l:originalFilespec = s:GetOriginalFilespec( a:filespec, 0 )
	if empty( l:originalFilespec )
	    " TODO: 'Unable to determine the location of the original file; open it in another buffer.'
	    call s:ErrorMsg('Unable to determine the location of the original file.')
	    return
	endif

	if s:Restore( a:filespec, l:originalFilespec, printf("Really override '%s' with this backup '%s'?", l:originalFilespec, l:currentVersion) )
	    execute 'edit! ' . escape( tr( l:originalFilespec, '\', '/'), ' \%#' )
	endif
    catch /^WriteBackup\%(VersionControl\)\?:/
	call s:ExceptionMsg(v:exception)
    endtry
endfunction

function! writebackupVersionControl#WriteBackupOfSavedOriginal( filespec )
"*******************************************************************************
"* PURPOSE:
"   Instead of backing up the current buffer, back up the saved version of the
"   buffer. 
"* ASSUMPTIONS / PRECONDITIONS:
"	? List of any external variable, control, or other element whose state affects this procedure.
"* EFFECTS / POSTCONDITIONS:
"	? List of the procedure's effect on each external variable, control, or other element.
"* INPUTS:
"	? Explanation of each argument that isn't obvious.
"* RETURN VALUES: 
"   Throws 'WriteBackupVersionControl: You can only backup the latest file version, not a backup file itself!'
"   Throws 'WriteBackup:' or any exception resulting from query for backup dir. 
"*******************************************************************************
    try
	if ! writebackupVersionControl#IsOriginalFile( a:filespec )
	    throw 'WriteBackupVersionControl: You can only backup the latest file version, not a backup file itself!'
	endif

	let l:backupfilename = writebackup#GetBackupFilename( a:filespec )
	call s:Copy(  a:filespec, l:backupfilename )
	echomsg '"' . l:backupfilename . '" written'
    catch /^WriteBackup\%(VersionControl\)\?:/
	" Report problem. Probably, all backup letters a-z are already used. 
	call s:ExceptionMsg(v:exception)
    catch
	call s:ErrorMsg('Failed to backup file: ' . v:exception)
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :