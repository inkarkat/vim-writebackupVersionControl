" Test forced restore from backup. 
" Tests that restore works without confirmation. 
" Tests that a readonly original file is overwritten. 

source helpers/file.vim

call vimtest#StartTap()
call vimtap#Plan(4)

cd $TEMP/WriteBackupTest
call MakeReadonly('important.txt')

edit important.txt.20061231a
WriteBackupRestoreThisBackup!
call vimtap#file#IsFilespec('important.txt', 'RestoreThisBackup!')
call vimtap#Is(getline(1), 'second revision', 'RestoreThisBackup! restored backup contents')
call vimtap#file#IsFile('RestoreThisBackup!')
" Really make sure that the restore didn't just change the buffer contents, but
" also the file on disk. 
edit! important.txt
call vimtap#Is(getline(1), 'second revision', 'RestoreThisBackup! restored backup contents on disk')

call vimtest#Quit() 

