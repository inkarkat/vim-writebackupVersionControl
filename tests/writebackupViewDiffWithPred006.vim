" Test view diff non-existing diff command. 

call vimtest#StartTap()
call vimtap#Plan(6)

let g:WriteBackup_DiffShellCommand = 'doesnotexist'
cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
echomsg 'Test: diff output'
echomsg getline(1)
if ! vimtap#Skip(1, (v:shell_error != 1), 'Windows returns 1 if shell command not found')
    call vimtap#Isnt('diff', &l:filetype, 'No diff filetype on error diff scratch buffer')
endif

wincmd w
call vimtap#file#IsFilename('important.txt', 'still at original')
call vimtap#file#IsFile('still at original')
call vimtap#Is(winnr('$'), 2, 'only original and diff scratch buffer windows')

call vimtest#Quit() 

