" Test deletion of last backup.

if has('gui_running')
    call vimtest#SkipMsgout('Dialog confirmation message is not captured in GUI.')
endif

call vimtest#StartTap()
call vimtap#Plan(3)

cd $TEMP/WriteBackupTest
edit not\ important.txt

call vimtap#err#Errors('No backups exist for this file.', 'WriteBackupDeleteLastBackup', 'error shown')

edit important.txt
call vimtest#RequestInput('No')
WriteBackupDeleteLastBackup
call vimtap#Ok(filereadable('important.txt.20080101b'), 'last backup still exists')
call vimtest#RequestInput('Yes')
WriteBackupDeleteLastBackup
call vimtap#Ok(! filereadable('important.txt.20080101b'), 'last backup was removed')
WriteBackupDeleteLastBackup!
WriteBackupDeleteLastBackup!

call ListFiles()
call vimtest#Quit()
