" Test failed check for identical backup due to borked-up compare shell command. 

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackup

let g:WriteBackup_CompareShellCommand = 'diff --huh --what'

echomsg 'Test: borked-up diff options'
WriteBackupIsBackedUp

call vimtest#Quit() 

