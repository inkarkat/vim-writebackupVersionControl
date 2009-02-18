" Test failed restore from predecessor. 

call vimtest#StartTap()
call vimtap#Plan(3)

cd $TEMP/WriteBackupTest
edit important.txt

if has('win32') || has('win64')
    silent ! attrib +R important.txt
else
    silent ! chmod -w important.txt
endif

echomsg "User: PLEASE PRESS 'Y'"
WriteBackupRestoreFromPred
call vimtap#file#IsFilespec('important.txt', 'RestoreFromPred')
call vimtap#file#IsFile('RestoreFromPred')
call vimtap#Is(getline(1), 'current revision', 'RestoreFromPred current contents')

call vimtest#Quit() 

