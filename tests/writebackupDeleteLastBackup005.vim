" Test forced deletion of last backup. 

source helpers/file.vim

cd $TEMP/WriteBackupTest
edit important.txt
call MakeReadonly('important.txt.20080101b')
WriteBackupDeleteLastBackup!

call ListFiles()
call vimtest#Quit() 

