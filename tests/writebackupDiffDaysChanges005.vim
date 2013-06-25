" Test diff many days changes from backups. 

cd $TEMP/WriteBackupTest
edit important.txt.20080101b
echomsg 'Test: Too high day span'
99WriteBackupDiffDaysChanges

call vimtest#Quit() 
