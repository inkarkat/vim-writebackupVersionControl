" Test failed check for identical backup due to unavailable compare shell command. 

" This test does not work on Windows, because the shell returns 1 if the
" executable cannot be found. writebackupVersionControl interprets this 1 as
" "differing files", though.
" In practice, this shouldn't be a problem because the auto-detection of the
" compare shell command checks whether the command is executable(), so this
" could only occur if the user configures a non-existing compare shell
" command. 
call vimtest#SkipAndQuitIf(has('win32') || has('win64'), 'Windows returns 1 for both differing files and no executable found')

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackup

" Prune the PATH so that the 'cmp' or 'diff' executable isn't found. 
let $PATH = '.'
echomsg 'Test: diff not in PATH'
WriteBackupIsBackedUp

let g:WriteBackup_CompareShellCommand = 'doesnotexist -xyz'
echomsg 'Test: doesnotexit compare command'
WriteBackupIsBackedUp

call vimtest#Quit() 

