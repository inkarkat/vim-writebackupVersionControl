" Test view multiple concurrent diffs with predecessor. 

call vimtest#StartTap()
call vimtap#Plan(5)

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')

split someplace\ else.txt
let g:WriteBackup_BackupDir = $TEMP . '/WriteBackupTest/backup'
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/someplace else.txt.diff [Scratch]', 'scratch buffer 2')
call vimtap#file#IsNoFile('scratch buffer 2')

call vimtap#window#IsWindows(['someplace else.txt.diff [Scratch]', 'someplace else.txt', 'important.txt.diff [Scratch]', 'important.txt'], 'two original files and two corresponding diff scratch buffers')

call vimtest#Quit() 

