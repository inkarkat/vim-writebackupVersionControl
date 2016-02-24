" Test failed restore from backup due to readonly original file.

source helpers/file.vim

call vimtest#StartTap()
call vimtap#Plan(2)

cd $TEMP/WriteBackupTest
call MakeReadonly('important.txt')

edit important.txt.20061231a
call vimtap#err#Errors("Cannot overwrite readonly 'important.txt' (add ! to override)", 'WriteBackupRestoreThisBackup', 'error shown')
call vimtap#file#IsFilename('important.txt.20061231a', 'RestoreThisBackup over readonly original fails')

call vimtest#Quit()
