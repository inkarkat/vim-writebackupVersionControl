" Test same fileformat on view diff with predecessor.

" The test data is in Unix format; make Vim default to DOS.
set fileformats=dos,unix

call vimtest#StartTap()
call vimtap#Plan(4)

cd $TEMP/WriteBackupTest
edit important.txt
call vimtap#Is(&l:fileformat, 'unix', 'test data fileformat')
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(&l:fileformat, 'unix', 'diff fileformat')

call vimtest#Quit()
