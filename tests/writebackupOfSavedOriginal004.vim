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
try
    WriteBackupOfSavedOriginal
    call vimtap#Fail('expected error: Saved original is identical to old backup')
catch
    call vimtap#err#Thrown("This file is already backed up as '20080101b'", 'error shown')
endtry

call ListFiles()
call vimtest#Quit()
