" Test same iskeyword on view diff with predecessor.

call vimtest#StartTap()
call vimtap#Plan(3)

cd $TEMP/WriteBackupTest
edit important.txt
setlocal iskeyword=@,48-57,_,192-255,#,%

WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(&l:iskeyword, '@,48-57,_,192-255,#,%', 'diff iskeyword option')

call vimtest#Quit()
