" Test failed deletion of last backup.

source ../helpers/file.vim

if has('gui_running')
    call vimtest#SkipMsgout('Dialog confirmation message is not captured in GUI.')
endif

call vimtest#StartTap()
call vimtap#Plan(1)

cd $TEMP/WriteBackupTest
edit important.txt
call MakeReadonly('important.txt.20080101b')
call vimtest#RequestInput('Yes')
try
    WriteBackupDeleteLastBackup
    call vimtap#Fail('expected error on readonly backup')
catch
    echomsg v:exception
    call vimtap#err#Thrown("Cannot delete readonly backup '20080101b' (add ! to override)", 'error shown')
endtry

call ListFiles()
call vimtest#Quit()
