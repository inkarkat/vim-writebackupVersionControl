" Test repeat view diff with predecessor via du mapping. 
" This test relies on the scratch buffer to repeat the diff. 

call vimtest#StartTap()
call vimtap#Plan(20)

cd $TEMP/WriteBackupTest
edit important.txt

3WriteBackupViewDiffWithPred -c
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(5), '! second revision', 'diff from second revision')
call vimtap#Is(getline(8), '! current revision', 'diff to current revision')

" Test keeping both [count] and {diffOptions}. 
wincmd w
1s/current/new/
write
wincmd w
normal du
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(5), '! second revision', 'diff from second revision')
call vimtap#Is(getline(8), '! new revision', 'diff to new revision')


" Test updating with different [count] and default diff options. 
2WriteBackupViewDiffWithPred
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(4), '-third revision', 'unified diff from third revision')
call vimtap#Is(getline(7), '+new revision', 'unified diff to new revision')

wincmd w
1s/new/updated \0/
write
wincmd w
normal du
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(4), '-third revision', 'unified diff from third revision')
call vimtap#Is(getline(7), '+updated new revision', 'unified diff to updated new revision')

" Test override of the version via [count]. 
" XXX: This ignores the [count]. 
" normal 1du
" XXX: This is only executed after this test has finished. 
" call feedkeys('1du')
" XXX: This trick works. 
function! Proceed()
    call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
    call vimtap#file#IsNoFile('scratch buffer')
    call vimtap#Is(getline(4), '-fourth revision', 'unified diff from fourth revision')
    call vimtap#Is(getline(6), '+updated new revision', 'unified diff to updated new revision')

    call vimtest#Quit() 
endfunction
call feedkeys("1du:call Proceed()\<CR>")

