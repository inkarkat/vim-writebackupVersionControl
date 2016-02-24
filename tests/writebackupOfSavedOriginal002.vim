" Test running out of backup filenames during backup of saved file.

call vimtest#StartTap()
call vimtap#Plan(1)

cd $TEMP/WriteBackupTest

edit important.txt
%s/current/up-to-date/
for i in range(1, 26)
    WriteBackup!
endfor
call vimtap#err#Errors('Ran out of backup file names', 'WriteBackupOfSavedOriginal', 'error shown')

call vimtest#Quit()
