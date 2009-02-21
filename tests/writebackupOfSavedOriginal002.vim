" Test running out of backup filenames during backup of saved file. 

cd $TEMP/WriteBackupTest
let g:WriteBackup_AvoidIdenticalBackups = 0

edit important.txt
for i in range(1, 26)
    WriteBackup
endfor
echomsg 'Test: Exhausted all backup filenames'
WriteBackupOfSavedOriginal

call vimtest#Quit() 

