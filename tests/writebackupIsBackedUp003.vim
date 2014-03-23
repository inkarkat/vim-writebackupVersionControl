" Test failed check for identical backup due to borked-up compare shell command.

call vimtest#StartTap()
call vimtap#Plan(1)

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackup

let g:WriteBackup_CompareShellCommand = 'diff --huh --what'

try
    WriteBackupIsBackedUp
    call vimtap#Fail('expected error with borked-up diff options')
catch
    call vimtap#err#Thrown("Encountered problems with 'diff --huh --what' invocation. Unable to compare with latest backup.", 'error shown')
endtry

call vimtest#Quit()
