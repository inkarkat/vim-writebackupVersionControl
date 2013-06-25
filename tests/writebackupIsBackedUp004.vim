" Test failed check for identical backup due to unconfigured compare shell command. 

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackup

let g:WriteBackup_CompareShellCommand = ''

echomsg 'Test: unconfigured compare command'
WriteBackupIsBackedUp

call vimtest#Quit() 

