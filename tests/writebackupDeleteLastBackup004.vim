" Test deletion of all backups in a different directory. 
" Tests that a different message is printed when the last backup is deleted. 
" Tests that deletion also works with a different (relative) directory. 

let g:WriteBackup_BackupDir = './backup' 
cd $TEMP/WriteBackupTest

edit someplace\ else.txt
WriteBackupDeleteLastBackup!
WriteBackupDeleteLastBackup!
WriteBackupDeleteLastBackup!

call ListFiles()
call vimtest#Quit() 

