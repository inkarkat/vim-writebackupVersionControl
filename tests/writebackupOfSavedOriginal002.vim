" Test running out of backup filenames during backup of saved file. 

cd $TEMP/WriteBackupTest

edit important.txt
%s/current/up-to-date/
for i in range(1, 26)
    WriteBackup!
endfor
echomsg 'Test: Exhausted all backup filenames'
WriteBackupOfSavedOriginal

call vimtest#Quit() 

