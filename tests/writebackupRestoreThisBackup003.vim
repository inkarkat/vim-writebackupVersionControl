" Test failed restore from backup due to readonly original file. 

source helpers/file.vim

call vimtest#StartTap()
call vimtap#Plan(1)

cd $TEMP/WriteBackupTest
call MakeReadonly('important.txt')

edit important.txt.20061231a
echomsg 'Test: Cannot overwrite readonly original'
WriteBackupRestoreThisBackup
call vimtap#file#IsFilename('important.txt.20061231a', 'RestoreThisBackup over readonly original fails')

call vimtest#Quit() 

