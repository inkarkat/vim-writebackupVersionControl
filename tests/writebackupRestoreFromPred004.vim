" Test restore from nth predecessor. 

if has('gui_running')
    call vimtest#SkipMsgout('Dialog confirmation message is not captured in GUI.')
endif

call vimtest#StartTap()
call vimtap#Plan(6)

cd $TEMP/WriteBackupTest

edit important.txt
call vimtest#RequestInput('Yes')
2WriteBackupRestoreFromPred
call vimtap#file#IsFilespec('important.txt', '2RestoreFromPred')
call vimtap#file#IsFile('2RestoreFromPred')
call vimtap#Is(getline(1), 'third revision', '2RestoreFromPred 2nd predecessor''s contents')

edit important.txt
call vimtest#RequestInput('Yes')
999WriteBackupRestoreFromPred
call vimtap#file#IsFilespec('important.txt', '999RestoreFromPred')
call vimtap#file#IsFile('999RestoreFromPred')
call vimtap#Is(getline(1), 'it all started here', '999RestoreFromPred start revision''s contents')

call vimtest#Quit() 

