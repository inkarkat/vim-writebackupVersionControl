" Test view diff with predecessor error conditions. 

call vimtest#StartTap()
call vimtap#Plan(2)

cd $TEMP/WriteBackupTest
edit important.txt.19990815a
echomsg 'Test: No predecessor'
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('important.txt.19990815a', 'no predecessor')

edit not\ important.txt
WriteBackupViewDiffWithPred
echomsg 'Test: No backups'
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('not important.txt', 'no backups')

call vimtest#Quit() 

