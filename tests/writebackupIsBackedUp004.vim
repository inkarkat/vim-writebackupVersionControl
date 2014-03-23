" Test failed check for identical backup due to unconfigured compare shell command.

call vimtest#StartTap()
call vimtap#Plan(1)

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackup

let g:WriteBackup_CompareShellCommand = ''

try
    WriteBackupIsBackedUp
    call vimtap#Fail('expected error with unconfigured compare command')
catch
    call vimtap#err#Thrown('No compare shell command configured. Unable to compare with latest backup.', 'error shown')
endtry

call vimtest#Quit()
