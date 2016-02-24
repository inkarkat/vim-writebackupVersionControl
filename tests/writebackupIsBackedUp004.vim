" Test failed check for identical backup due to unconfigured compare shell command.

call vimtest#StartTap()
call vimtap#Plan(1)

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackup

let g:WriteBackup_CompareShellCommand = ''

call vimtap#err#Errors('No compare shell command configured. Unable to compare with latest backup.', 'WriteBackupIsBackedUp', 'error shown')

call vimtest#Quit()
