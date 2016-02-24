" Test diff many days changes from backups.

cd $TEMP/WriteBackupTest
edit important.txt.20080101b
call vimtest#StartTap()
call vimtap#Plan(1)

call vimtap#err#Errors('Sorry, cannot go beyond first day of month for backups.', '99WriteBackupDiffDaysChanges', 'error shown')

call vimtest#Quit()
