" Test failed check for identical backup due to borked-up compare shell command.

call vimtest#StartTap()
call vimtap#Plan(1)

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackup

let g:WriteBackup_CompareShellCommand = 'diff --huh --what'

call vimtap#err#Errors("Encountered problems with 'diff --huh --what' invocation. Unable to compare with latest backup.", 'WriteBackupIsBackedUp', 'error shown')

call vimtest#Quit()
