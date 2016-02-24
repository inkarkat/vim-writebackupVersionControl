" Test running out and forcing backup during backup of saved file. 

cd $TEMP/WriteBackupTest

edit important.txt
%s/current/fifth/
for i in range(1, 26)
    WriteBackup!
endfor
WriteBackupOfSavedOriginal!

call ListFiles()
call vimtest#Quit() 

