" Test avoiding backups identical to last backup.
" Tests that an identical old backup file is re-dated.

call vimtest#ErrorAndQuitIf(g:WriteBackup_AvoidIdenticalBackups !=# 'redate', 'Default behavior on identical backups is redate')

call vimtest#StartTap()
call vimtap#Plan(1)

cd $TEMP/WriteBackupTest
edit important.txt
%s/current/fourth/
%s/simplified/removed a line/
write
%s/fourth/fifth/
echomsg 'Test: Saved original is identical to old backup'
WriteBackupOfSavedOriginal

call vimtap#err#ErrorsLike("\\VThis file is already backed up as '20\\d\\{6}a'", 'WriteBackupOfSavedOriginal', 'error shown')

call ListFiles()
call vimtest#Quit()
