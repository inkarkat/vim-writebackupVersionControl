" Test check for backup.

call vimtest#StartTap()
call vimtap#Plan(2)

cd $TEMP/WriteBackupTest
edit important.txt.20080101b
try
    WriteBackupIsBackedUp
    call vimtap#Fail('expected error: Cannot check backup status of backup file')
catch
    call vimtap#err#Thrown('You can only check the backup status of the original file, not of backups!', 'error shown')
endtry

edit not\ important.txt
try
    WriteBackupIsBackedUp
    call vimtap#Fail('expected error when no backup exists')
catch
    call vimtap#err#Thrown('No backups exist for this file.', 'error shown')
endtry

edit important.txt
echomsg 'Test: Differing backup'
WriteBackupIsBackedUp

WriteBackup
echomsg 'Test: Identical'
WriteBackupIsBackedUp

normal! Goedited.
echomsg 'Test: Saved identical'
WriteBackupIsBackedUp

edit! important.txt
normal! ggg~~
write
echomsg 'Test: Backup differing only in file contents, not size'
WriteBackupIsBackedUp

call vimtest#Quit()
