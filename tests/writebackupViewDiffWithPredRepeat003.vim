" Test keeping cursor position when repeating view diff in the scratch buffer.

call vimtest#StartTap()
call vimtap#Plan(4)

cd $TEMP/WriteBackupTest
edit important.txt
" Create a longer diff.
%yank
put!
redir @"
silent! version
redir END
put
WriteBackup
%s/e/x/g
write

WriteBackupViewDiffWithPred
let s:position = searchpos('Compilation:')

wincmd w
%s/x/y/g
wincmd w
WriteBackupViewDiffWithPred
call vimtap#Is([line('.'), col('.')], s:position, 'Kept cursor position when repeating in scratch buffer')

2WriteBackupViewDiffWithPred
call vimtap#Is([line('.'), col('.')], [1,1], 'Moved to first line when issuing other diff in scratch buffer')

let s:position = searchpos('Compilation:')
wincmd w
2WriteBackupViewDiffWithPred
call vimtap#Isnt([line('.'), col('.')], s:position, 'Moved to first line when repeating diff from original file')
call vimtap#Is([line('.'), col('.')], [1,1], 'Moved to first line when repeating diff from original file')

call vimtest#Quit()
