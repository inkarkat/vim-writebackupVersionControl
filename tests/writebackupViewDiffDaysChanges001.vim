" Test view diff of todays changes.

call vimtest#StartTap()
call vimtap#Plan(15)

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackup
%s/current/more/
WriteBackup
%s/more/even &/
write

WriteBackupViewDaysChanges --normal
echomsg 'Test: scratch buffer'
setlocal buftype? bufhidden? buflisted? swapfile? readonly? modifiable? modified? filetype?
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtest#SaveOut()
close
call vimtap#file#IsFilename('important.txt', 'still at original')
call vimtap#file#IsFile('still at original')
call vimtap#Is(winnr('$'), 1, 'only original window')

WriteBackupViewDaysChanges
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch1]', 'new scratch buffer')
call vimtap#file#IsNoFile('same scratch buffer')
wincmd w
call vimtap#file#IsFilename('important.txt', 'still at original')
call vimtap#file#IsFile('still at original')
call vimtap#Is(winnr('$'), 2, 'only original and diff scratch buffer windows')

WriteBackupViewDaysChanges
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch1]', 'reused scratch buffer')
call vimtap#file#IsNoFile('reused scratch buffer')
wincmd w
call vimtap#file#IsFilename('important.txt', 'still at original')
call vimtap#file#IsFile('still at original')
call vimtap#Is(winnr('$'), 2, 'only original and reused diff scratch buffer windows')

call vimtest#Quit()
