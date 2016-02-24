" Test check for backup.

call vimtest#StartTap()
call vimtap#Plan(2)

cd $TEMP/WriteBackupTest
edit important.txt.20080101b
call vimtap#err#Errors('You can only check the backup status of the original file, not of backups!', 'WriteBackupIsBackedUp', 'error shown')

edit not\ important.txt
call vimtap#err#Errors('No backups exist for this file.', 'WriteBackupIsBackedUp', 'error shown')

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
