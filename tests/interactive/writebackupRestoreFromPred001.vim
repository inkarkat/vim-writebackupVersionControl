" Test restore from predecessor.

if has('gui_running')
    call vimtest#SkipMsgout('Dialog confirmation message is not captured in GUI.')
endif

call vimtest#StartTap()
call vimtap#Plan(7)

cd $TEMP/WriteBackupTest
edit important.txt.20080101b
call vimtap#err#Errors('You can only restore the original file, not a backup!', 'WriteBackupRestoreFromPred', 'error shown')

edit important.txt
call vimtest#RequestInput('No')
WriteBackupRestoreFromPred
call vimtap#file#IsFilename('important.txt', 'RestoreFromPred - N')
call vimtap#file#IsFile('RestoreFromPred - N')
call vimtap#Is(getline(1), 'current revision', 'RestoreFromPred - N current contents')

call vimtest#RequestInput('Yes')
WriteBackupRestoreFromPred
call vimtap#file#IsFilename('important.txt', 'RestoreFromPred - Y')
call vimtap#file#IsFile('RestoreFromPred - Y')
call vimtap#Is(getline(1), 'fourth revision', 'RestoreFromPred - Y predecessor''s contents')

call vimtest#Quit()
