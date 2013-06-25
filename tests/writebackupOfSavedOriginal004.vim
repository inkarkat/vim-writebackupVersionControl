" Test avoiding backups identical to last backup. 

let g:WriteBackup_AvoidIdenticalBackups = 1

cd $TEMP/WriteBackupTest
edit important.txt
%s/current/fourth/
%s/simplified/removed a line/
write
%s/fourth/fifth/
echomsg 'Test: Saved original is identical to old backup'
WriteBackupOfSavedOriginal

call ListFiles()
call vimtest#Quit() 
