" Test diff many days changes from backups.

cd $TEMP/WriteBackupTest
edit important.txt.20080101b
call vimtest#StartTap()
call vimtap#Plan(1)

try
    99WriteBackupDiffDaysChanges
    call vimtap#Fail('expected error when too high day span')
catch
    call vimtap#err#Thrown('Sorry, cannot go beyond first day of month for backups.', 'error shown')
endtry

call vimtest#Quit()
