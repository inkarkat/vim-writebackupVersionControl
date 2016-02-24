" Test repeat view diff with predecessor. 
" This test relies on the scratch buffer to repeat the diff. 

call vimtest#StartTap()
call vimtap#Plan(32)

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(4), '-fourth revision', 'diff from fourth revision')
call vimtap#Is(getline(6), '+current revision', 'diff to current revision')

wincmd w
1s/current/new/
write
wincmd w
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(4), '-fourth revision', 'diff from fourth revision')
call vimtap#Is(getline(6), '+new revision', 'diff to new revision')

" An explicit count overrides the previous diff. 
"wincmd w
3WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(4), '-second revision', 'diff from second revision')
call vimtap#Is(getline(6), '+new revision', 'diff to new revision')

wincmd w
1s/new/updated \0/
write
wincmd w
" Without a count, the previous diff is repeated. 
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(4), '-second revision', 'diff from second revision')
call vimtap#Is(getline(6), '+updated new revision', 'diff to updated new revision')

" An explicit 1 overrides the previous diff. 
"wincmd w
1WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(4), '-fourth revision', 'diff from fourth revision')
call vimtap#Is(getline(6), '+updated new revision', 'diff to updated new revision')


wincmd w
2WriteBackupGoPrev
wincmd w
" The diff participants are kept even when the buffer went to another version. 
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(4), '-fourth revision', 'diff from fourth revision')
call vimtap#Is(getline(6), '+updated new revision', 'diff to updated new revision')

" A command from the buffer version overrides the previous diff. 
wincmd w
WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(4), '-second revision', 'diff from second revision')
call vimtap#Is(getline(5), '+third revision', 'diff to third revision')

" The non-original participant is stored as well. 
"wincmd w
2WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(4), '-first revision', 'diff from first revision')
call vimtap#Is(getline(5), '+third revision', 'diff to third revision')

call vimtest#Quit() 

