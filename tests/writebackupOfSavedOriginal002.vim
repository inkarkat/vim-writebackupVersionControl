" Test running out of backup filenames during backup of saved file.

call vimtest#StartTap()
call vimtap#Plan(1)

cd $TEMP/WriteBackupTest

edit important.txt
%s/current/up-to-date/
for i in range(1, 26)
    WriteBackup!
endfor
try
    WriteBackupOfSavedOriginal
    call vimtap#Fail('expected error: Exhausted all backup filenames')
catch
    call vimtap#err#Thrown('Ran out of backup file names', 'error shown')
endtry

call vimtest#Quit()
