" Test diff many days changes from current.

call vimtest#StartTap()
call vimtap#Plan(4)

cd $TEMP/WriteBackupTest
edit important.txt
call vimtap#err#Errors("Couldn't locate a backup from up to 98 days ago: important.txt", '99WriteBackupDiffDaysChanges', 'error shown')
call vimtap#file#IsFilename('important.txt', 'stay at original')

9999WriteBackupDiffDaysChanges
call vimtap#file#IsFilename('important.txt', 'stay at original')
wincmd h
call vimtap#file#IsFilename('important.txt.19990815a', '9999 days is very first backup to the left')

call vimtest#Quit()
