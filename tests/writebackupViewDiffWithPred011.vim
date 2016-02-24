" Test saving of scratch diff buffer. 

call vimtest#StartTap()
call vimtap#Plan(8)

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
saveas important.txt.diff

wincmd w
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch1]', '2nd scratch buffer')
call vimtap#file#IsNoFile('2nd scratch buffer')
call vimtap#window#IsWindows(['important.txt.diff', 'important.txt.diff [Scratch1]', 'important.txt'], 'original, saved scratch and 2nd diff scratch buffer')

saveas important2.txt.diff
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch2]', '3rd scratch buffer')
call vimtap#file#IsNoFile('3rd scratch buffer')
call vimtap#window#IsWindows(['important.txt.diff', 'important.txt.diff [Scratch2]', 'important2.txt.diff', 'important.txt'], 'original, two saved scratch and 3rd diff scratch buffer')

call vimtest#Quit() 

