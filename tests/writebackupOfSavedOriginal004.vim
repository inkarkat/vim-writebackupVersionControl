" Test avoiding backups identical to last backup.

call vimtest#StartTap()
call vimtap#Plan(1)

let g:WriteBackup_AvoidIdenticalBackups = 1

cd $TEMP/WriteBackupTest
edit important.txt
%s/current/fourth/
%s/simplified/removed a line/
write
%s/fourth/fifth/
call vimtap#err#Errors("This file is already backed up as '20080101b'", 'WriteBackupOfSavedOriginal', 'error shown')

call ListFiles()
call vimtest#Quit()
