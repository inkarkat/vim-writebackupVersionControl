" Test restore from backup. 

if has('gui_running')
    call vimtest#SkipMsgout('Dialog confirmation message is not captured in GUI.')
endif

call vimtest#StartTap()
call vimtap#Plan(6)

cd $TEMP/WriteBackupTest
edit important.txt
echomsg 'Test: Cannot restore from original file'
WriteBackupRestoreThisBackup

edit important.txt.20061231a
call vimtest#RequestInput('No')
WriteBackupRestoreThisBackup
call vimtap#file#IsFilename('important.txt.20061231a', 'RestoreThisBackup - N')
edit important.txt
call vimtap#Is(getline(1), 'current revision', 'RestoreThisBackup - N current contents kept')

edit important.txt.20061231a
call vimtest#RequestInput('Yes')
WriteBackupRestoreThisBackup
call vimtap#file#IsFilename('important.txt', 'RestoreThisBackup - Y')
call vimtap#Is(getline(1), 'second revision', 'RestoreThisBackup - Y restored backup contents')
call vimtap#file#IsFile('RestoreThisBackup - Y')
" Really make sure that the restore didn't just change the buffer contents, but
" also the file on disk. 
edit! important.txt
call vimtap#Is(getline(1), 'second revision', 'RestoreThisBackup - Y restored backup contents on disk')

call vimtest#Quit() 

