" Test view diff with predecessor. 

call vimtest#StartTap()
call vimtap#Plan(15)

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupViewDiffWithPred --normal
echomsg 'Test: scratch buffer'
setlocal buftype? bufhidden? buflisted? swapfile? readonly? modifiable? modified?
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtest#SaveOut()
close
call vimtap#file#IsFilespec('important.txt', 'still at original')
call vimtap#file#IsFile('still at original')
call vimtap#Is(winnr('$'), 1, 'only original window')

WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch1]', 'new scratch buffer')
call vimtap#file#IsNoFile('same scratch buffer')
wincmd w
call vimtap#file#IsFilespec('important.txt', 'still at original')
call vimtap#file#IsFile('still at original')
call vimtap#Is(winnr('$'), 2, 'only original and diff scratch buffer windows')

WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch1]', 'reused scratch buffer')
call vimtap#file#IsNoFile('reused scratch buffer')
wincmd w
call vimtap#file#IsFilespec('important.txt', 'still at original')
call vimtap#file#IsFile('still at original')
call vimtap#Is(winnr('$'), 2, 'only original and reused diff scratch buffer windows')

call vimtest#Quit() 

