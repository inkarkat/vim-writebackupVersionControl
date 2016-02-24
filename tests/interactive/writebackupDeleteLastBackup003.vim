" Test deletion of last backup from another backup.

cd $TEMP/WriteBackupTest
edit important.txt.20061231a
call vimtest#RequestInput('Yes')
WriteBackupDeleteLastBackup

call ListFiles()
call vimtest#Quit()
