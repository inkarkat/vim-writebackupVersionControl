" Test diff many days changes from current. 

call vimtest#StartTap()
call vimtap#Plan(3)

cd $TEMP/WriteBackupTest
edit important.txt
echomsg 'Test: No backup in day span'
99WriteBackupDiffDaysChanges
call vimtap#file#IsFilename('important.txt', 'stay at original')

9999WriteBackupDiffDaysChanges
call vimtap#file#IsFilename('important.txt', 'stay at original')
wincmd h
call vimtap#file#IsFilename('important.txt.19990815a', '9999 days is very first backup to the left')

call vimtest#Quit() 
