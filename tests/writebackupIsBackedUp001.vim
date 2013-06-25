" Test check for backup. 

cd $TEMP/WriteBackupTest
edit important.txt.20080101b
echomsg 'Test: Cannot check backup status of backup file'
WriteBackupIsBackedUp

edit not\ important.txt
echomsg 'Test: No backup exists'
WriteBackupIsBackedUp

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

