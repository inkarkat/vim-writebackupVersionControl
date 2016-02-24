" Test view diff with nth predecessor. 

call vimtest#StartTap()
call vimtap#Plan(3)

cd $TEMP/WriteBackupTest

edit important.txt
2WriteBackupViewDiffWithPred
call vimtap#Like(getline(1), '^\V--- important.txt.20080101a', 'diff with 2nd predecessor')
close

edit important.txt.20080101b
3WriteBackupViewDiffWithPred
call vimtap#Like(getline(1), '^\V--- important.txt.20061201a', 'diff with 3rd predecessor')
close

999WriteBackupViewDiffWithPred
call vimtap#Like(getline(1), '^\V--- important.txt.19990815a', 'diff with start revision')
close

call vimtest#Quit() 

