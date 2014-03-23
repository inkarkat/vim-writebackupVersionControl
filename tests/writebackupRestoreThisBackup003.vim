" Test failed restore from backup due to readonly original file.

source helpers/file.vim

call vimtest#StartTap()
call vimtap#Plan(2)

cd $TEMP/WriteBackupTest
call MakeReadonly('important.txt')

edit important.txt.20061231a
try
    WriteBackupRestoreThisBackup
    call vimtap#Fail('expected error: Cannot overwrite readonly original')
catch
    call vimtap#err#Thrown("Cannot overwrite readonly 'important.txt' (add ! to override)", 'error shown')
endtry
call vimtap#file#IsFilename('important.txt.20061231a', 'RestoreThisBackup over readonly original fails')

call vimtest#Quit()
