" Test avoiding backups identical to last backup. 
" Tests that an identical old backup file is re-dated. 

call vimtest#ErrorAndQuitIf(g:WriteBackup_AvoidIdenticalBackups !=# 'redate', 'Default behavior on identical backups is redate')

cd $TEMP/WriteBackupTest
edit important.txt
%s/current/fourth/
%s/simplified/removed a line/
write
%s/fourth/fifth/
echomsg 'Test: Saved original is identical to old backup'
WriteBackupOfSavedOriginal

echomsg 'Test: Saved original is identical to recent backup'
WriteBackupOfSavedOriginal

call ListFiles()
call vimtest#Quit() 
