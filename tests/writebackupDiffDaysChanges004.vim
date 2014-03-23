" Test diff many days changes from current.

call vimtest#StartTap()
call vimtap#Plan(4)

cd $TEMP/WriteBackupTest
edit important.txt
try
    99WriteBackupDiffDaysChanges
    call vimtap#Fail('expected error when no backup in day span')
catch
    call vimtap#err#Thrown("Couldn't locate a backup from up to 98 days ago: important.txt", 'error shown')
endtry
call vimtap#file#IsFilename('important.txt', 'stay at original')

9999WriteBackupDiffDaysChanges
call vimtap#file#IsFilename('important.txt', 'stay at original')
wincmd h
call vimtap#file#IsFilename('important.txt.19990815a', '9999 days is very first backup to the left')

call vimtest#Quit()
