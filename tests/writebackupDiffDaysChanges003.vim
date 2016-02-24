" Test diff previous days changes from backups. 

call vimtest#StartTap()
call vimtap#Plan(10)

cd $TEMP/WriteBackupTest
edit important.txt.20061201a
%s/first/week later/g
write important.txt.20061208a
%s/week/day/g
write important.txt.20061209a
%s/$/ and changed/
write important.txt.20061209b
saveas important.txt.20061210a

2WriteBackupDiffDaysChanges
call vimtap#file#IsFilename('important.txt.20061210a', 'stay at changed')
wincmd h
call vimtap#file#IsFilename('important.txt.20061209a', '2 days is first Dec-09 backup to the left')
close

edit important.txt.20061210a
3WriteBackupDiffDaysChanges
call vimtap#file#IsFilename('important.txt.20061210a', 'stay at changed')
wincmd h
call vimtap#file#IsFilename('important.txt.20061208a', '3 days is first Dec-08 backup to the left')
close

edit important.txt.20061210a
4WriteBackupDiffDaysChanges
call vimtap#file#IsFilename('important.txt.20061210a', 'stay at changed')
wincmd h
call vimtap#file#IsFilename('important.txt.20061208a', '4 days is first Dec-08 backup to the left')
close

edit important.txt.20061210a
9WriteBackupDiffDaysChanges
call vimtap#file#IsFilename('important.txt.20061210a', 'stay at changed')
wincmd h
call vimtap#file#IsFilename('important.txt.20061208a', '9 days is first Dec-08 backup to the left')
close

edit important.txt.20061210a
10WriteBackupDiffDaysChanges
call vimtap#file#IsFilename('important.txt.20061210a', 'stay at changed')
wincmd h
call vimtap#file#IsFilename('important.txt.20061201a', '10 days is first Dec-01 backup to the left')
close

call vimtest#Quit() 
