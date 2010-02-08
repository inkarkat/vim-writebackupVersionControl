" Test diffs with original and backup share scratch buffer. 

call vimtest#StartTap()
call vimtap#Plan(8)

let g:WriteBackup_ScratchBufferCommandModifiers = 'topleft'

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')

wincmd w
botright split
2WriteBackupGoPrev
2WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#window#IsWindows(['important.txt.diff [Scratch]', 'important.txt', 'important.txt.20080101a'], 'original, 2nd predecessor and a diff scratch buffer')

" If the CWD is changed, the diff belongs to another directory and thus also
" another diff scratch buffer. 
wincmd b
lcd ..
2WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('important.txt.diff [Scratch]', 'scratch buffer 2')
call vimtap#file#IsNoFile('scratch buffer 2')
call vimtap#window#IsWindows(['important.txt.diff [Scratch]', 'WriteBackupTest/important.txt.diff [Scratch]', 'WriteBackupTest/important.txt', 'WriteBackupTest/important.txt.20080101a'], 'original, 2nd predecessor, diff and ../diff scratch buffers')

call vimtest#Quit() 

