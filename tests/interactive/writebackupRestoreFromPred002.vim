" Test failed restore from predecessor.

source ../helpers/file.vim

call vimtest#StartTap()
call vimtap#Plan(3)

cd $TEMP/WriteBackupTest
edit important.txt

call MakeReadonly('important.txt')

call vimtest#RequestInput('Yes')
WriteBackupRestoreFromPred
call vimtap#file#IsFilename('important.txt', 'RestoreFromPred')
call vimtap#file#IsFile('RestoreFromPred')
call vimtap#Is(getline(1), 'current revision', 'RestoreFromPred current contents')

call vimtest#Quit()
