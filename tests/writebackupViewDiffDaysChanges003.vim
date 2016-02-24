" Test view diff of nth days changes. 

call vimtest#StartTap()
call vimtap#Plan(1)

cd $TEMP/WriteBackupTest

edit important.txt
9999WriteBackupViewDaysChanges
call vimtap#Like(getline(1), '^\V--- important.txt.19990815a', 'diff with start revision')
close

call vimtest#Quit() 
