" Test warning on no diff output. 
"
call vimtest#StartTap()
call vimtap#Plan(5) 

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackup
WriteBackup!

echomsg 'Test: diff original with pred' 
WriteBackupViewDiffWithPred

call vimtap#file#IsFilename('important.txt', 'still at original')
call vimtap#file#IsFile('still at original')
call vimtap#Is(winnr('$'), 1, 'only original window') 

echomsg 'Test: diff original with 2nd pred' 
2WriteBackupViewDiffWithPred

echomsg 'Test: diff modified original with pred' 
%s/current/modified/
WriteBackupViewDiffWithPred

echomsg 'Test: diff pred with 2nd pred' 
WriteBackupGoPrev!
WriteBackupViewDiffWithPred

echomsg 'Test: diff modified pred with 2nd pred' 
%s/current/modified/
WriteBackupViewDiffWithPred

call vimtap#file#IsFile('still at backup')
call vimtap#Is(winnr('$'), 1, 'only original window') 

call vimtest#Quit() 

