" Test failed deletion of last backup. 

source helpers/file.vim

if has('gui_running')
    call vimtest#SkipMsgout('Dialog confirmation message is not captured in GUI.')
endif

cd $TEMP/WriteBackupTest
edit important.txt
call MakeReadonly('important.txt.20080101b')
call vimtest#RequestInput('Yes')
WriteBackupDeleteLastBackup

call ListFiles()
call vimtest#Quit() 

