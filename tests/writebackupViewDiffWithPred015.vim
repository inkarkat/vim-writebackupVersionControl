" Test view diff with diff command error. 

call vimtest#StartTap()
call vimtap#Plan(1)

" Use "grep --invalid-switch" to force exit code 2. 
let g:WriteBackup_DiffShellCommand = 'grep'
let g:WriteBackup_DiffCreateDefaultArguments = '--invalid-switch'

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupViewDiffWithPred
call vimtap#Isnt('diff', &l:filetype, 'No diff filetype on error diff scratch buffer')

call vimtest#Quit() 

