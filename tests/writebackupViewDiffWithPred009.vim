" Test diffs with same filename do not share scratch buffer. 

call vimtest#StartTap()
call vimtap#Plan(7)

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')

wincmd w
cd another\ dir
saveas important.txt
WriteBackup
:1s/current/new/
write
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/another dir/important.txt.diff [Scratch]', 'scratch buffer 2')
call vimtap#file#IsNoFile('scratch buffer 2')
call vimtap#window#IsWindows(['WriteBackupTest/another dir/important.txt.diff [Scratch]', 'WriteBackupTest/important.txt.diff [Scratch]', 'WriteBackupTest/another dir/important.txt'], 'another original, diff and another diff scratch buffers')

" Test that a repeated :WriteBackupViewDiffWithPred command jumps to the correct
" window. 
wincmd b
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/another dir/important.txt.diff [Scratch]', 'scratch buffer 2')
call vimtap#file#IsNoFile('scratch buffer 2')

call vimtest#Quit() 

