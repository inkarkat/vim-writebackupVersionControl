" Test view diff non-existing diff command. 

call vimtest#StartTap()
call vimtap#Plan(5)

let g:WriteBackup_DiffShellCommand = 'doesnotexist'
cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
echomsg 'Test: diff output'
echomsg getline(1)

wincmd w
call vimtap#file#IsFilespec('important.txt', 'still at original')
call vimtap#file#IsFile('still at original')
call vimtap#Is(winnr('$'), 2, 'only original and diff scratch buffer windows')

call vimtest#Quit() 

