" writebackupVersionControl.vim: Version control functions (diff, restore,
" history navigation) for backups made with the writebackup plugin, which have a
" date file extension in the format '.YYYYMMDD[a-z]'.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - writebackup plugin (vimscript #1828)
"   - ingo-library.vim plugin
"   - External command "cmp", "diff" or equivalent for comparison
"   - External command "diff" or equivalent for listing of differences
"
" Copyright: (C) 2007-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
let s:version = 321

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_writebackupVersionControl') || (v:version < 700)
    finish
endif
if ! exists('g:loaded_writebackup')
    runtime plugin/writebackup.vim
endif
if ! exists('g:loaded_writebackup')
    echomsg 'writebackupVersionControl: You need to install the writebackup.vim plugin.'
    finish
elseif g:loaded_writebackup < 300
    echomsg 'writebackupVersionControl: You need a newer version of the writebackup.vim plugin.'
    finish
endif
if g:loaded_writebackup >= 400
    echomsg 'writebackupVersionControl: You need a newer version of this plugin; writebackup.vim is too new.'
    finish
endif
let g:loaded_writebackupVersionControl = s:version

"- configuration --------------------------------------------------------------

" Allow user to choose between vertical or horizontal diffsplit.
if ! exists('g:WriteBackup_DiffVertSplit')
    let g:WriteBackup_DiffVertSplit = 1  " Default to split for diff vertically.
endif

" Shell command used to compare two files to find out whether they are
" identical. The command must take two filespec arguments, return 0 for
" identical files, 1 for different files and anything else for trouble.
if ! exists('g:WriteBackup_CompareShellCommand')
    if executable('cmp')
	" -s	Print nothing for differing files.
	let g:WriteBackup_CompareShellCommand = 'cmp -s'
    elseif executable('diff')
	" -q	Report no details of the differences.
	let g:WriteBackup_CompareShellCommand = 'diff -q'
    else
	let g:WriteBackup_CompareShellCommand = ''
    endif
endif

" Shell command used to diff two files for the :WriteBackupViewDiffWithPred
" command.
if ! exists('g:WriteBackup_DiffShellCommand')
    if executable('diff')
	let g:WriteBackup_DiffShellCommand = 'diff'
    else
	let g:WriteBackup_DiffShellCommand = ''
    endif
endif
" Command-line arguments which are always passed to the diff shell command.
if ! exists('g:WriteBackup_DiffCreateAlwaysArguments')
    let g:WriteBackup_DiffCreateAlwaysArguments = ''
endif
" Command-line arguments which are only passed to the diff shell command when no
" arguments are passed to the :WriteBackupViewDiffWithPred command.
if ! exists('g:WriteBackup_DiffCreateDefaultArguments')
    let g:WriteBackup_DiffCreateDefaultArguments = '-u'
endif

if ! exists('g:WriteBackupCopyShellCommand')
    " Note: This isn't used on Windows.
    let g:WriteBackupCopyShellCommand = 'cp --no-preserve=mode'
endif
if ! exists('g:WriteBackupCopyPreserveArgument')
    let g:WriteBackupCopyPreserveArgument = '--preserve=timestamps'
endif

" Vim command modifiers (:topleft, :belowright, :vertical, etc.) applied when
" opening the diff scratch buffer.
if ! exists('g:WriteBackup_ScratchBufferCommandModifiers')
    let g:WriteBackup_ScratchBufferCommandModifiers = ''
endif


"- commands -------------------------------------------------------------------

command! -bar -count=1 WriteBackupDiffWithPred              if ! writebackupVersionControl#DiffWithPred(expand('%'), <count>) | echoerr ingo#err#Get() | endif
command! -bar -count=1 WriteBackupDiffDaysChanges           if ! writebackupVersionControl#DiffDaysChanges(expand('%'), <count>) | echoerr ingo#err#Get() | endif
command! -nargs=? -count=0 WriteBackupViewDiffWithPred      if ! writebackupVersionControl#ViewDiffWithPred(expand('%'), <count>, <q-args>) | echoerr ingo#err#Get() | endif
command! -nargs=? -count=0 WriteBackupViewDaysChanges       if ! writebackupVersionControl#ViewDiffDaysChanges(expand('%'), <count>, <q-args>) | echoerr ingo#err#Get() | endif
command! -bar WriteBackupListVersions                       if ! writebackupVersionControl#ListVersions(expand('%')) | echoerr ingo#err#Get() | endif
command! -bar -bang -count=1 WriteBackupGoPrev              if ! writebackupVersionControl#WriteBackupGoBackup(expand('%'), <bang>0, -1 * <count>) | echoerr ingo#err#Get() | endif
command! -bar -bang -count=1 WriteBackupGoNext              if ! writebackupVersionControl#WriteBackupGoBackup(expand('%'), <bang>0, <count>) | echoerr ingo#err#Get() | endif
command! -bar -bang WriteBackupGoOriginal                   if ! writebackupVersionControl#WriteBackupGoOriginal(expand('%'), <bang>0) | echoerr ingo#err#Get() | endif
command! -bar WriteBackupIsBackedUp                         if   writebackupVersionControl#IsBackedUp(expand('%')) <= 0 | echoerr ingo#err#Get() | endif
command! -bar -bang -count=1 WriteBackupRestoreFromPred     if ! writebackupVersionControl#RestoreFromPred(expand('%'), <bang>0, <count>) | echoerr ingo#err#Get() | endif
command! -bar -bang WriteBackupRestoreThisBackup            if ! writebackupVersionControl#RestoreThisBackup(expand('%'), <bang>0) | echoerr ingo#err#Get() | endif
command! -bar -bang WriteBackupOfSavedOriginal              if   writebackupVersionControl#WriteBackupOfSavedOriginal(expand('%'), <bang>0) <= 0 | echoerr ingo#err#Get() | endif
command! -bar -bang WriteBackupDeleteLastBackup             if ! writebackupVersionControl#DeleteBackupLastBackup(expand('%'), <bang>0) | echoerr ingo#err#Get() | endif

unlet s:version
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
