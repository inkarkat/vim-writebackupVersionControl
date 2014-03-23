" Test view diff with predecessor error conditions.

call vimtest#StartTap()
call vimtap#Plan(5)

cd $TEMP/WriteBackupTest
edit important.txt.19990815a
try
    WriteBackupViewDiffWithPred
    call vimtap#Fail('expected error when no predecessor')
catch
    call vimtap#err#Thrown('This is the earliest backup: important.txt.19990815a', 'error shown')
endtry
call vimtap#file#IsFilename('important.txt.19990815a', 'no predecessor')

edit not\ important.txt
WriteBackupViewDiffWithPred
try
    WriteBackupViewDiffWithPred
    call vimtap#Fail('expected error when no backups')
catch
    call vimtap#err#Thrown('No backups exist for this file.', 'error shown')
endtry
call vimtap#file#IsFilename('not important.txt', 'no backups')

let g:WriteBackup_DiffShellCommand = ''
try
    WriteBackupViewDiffWithPred
    call vimtap#Fail('expected error with unconfigured diff command')
catch
    call vimtap#err#Thrown('No diff shell command configured. Unable to show differences to predecessor.', 'error shown')
endtry

call vimtest#Quit()
