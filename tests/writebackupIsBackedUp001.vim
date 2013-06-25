" Test check for backup.

call vimtest#StartTap()
call vimtap#Plan(6)

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
try
    WriteBackupIsBackedUp
    call vimtap#Fail('expected error when differing backup')
catch
    call vimtap#err#Thrown("The current version of 'important.txt' is different from the latest backup '20080101b'.", 'error shown')
endtry

WriteBackup
try
    WriteBackupIsBackedUp
    call vimtap#Fail('expected error when identical')
catch
    call vimtap#err#ThrownLike("\\VThe current version of 'important.txt' is identical with the latest backup '20\\d\\{6}a'.", 'error shown')
endtry

normal! Goedited.
try
    WriteBackupIsBackedUp
    call vimtap#Fail('expected error when saved identical')
catch
    call vimtap#err#ThrownLike("\\VThe current saved version of 'important.txt' is identical with the latest backup '20\\\\d\\\\{6}a'.", 'error shown')
endtry

edit! important.txt
normal! ggg~~
write
try
    WriteBackupIsBackedUp
    call vimtap#Fail('expected error when backup differing only in file contents, not size')
catch
    call vimtap#err#ThrownLike("\\VThe current version of 'important.txt' is different from the latest backup '20\\\\d\\\\{6}a'.", 'error shown')
endtry

call vimtest#Quit()
