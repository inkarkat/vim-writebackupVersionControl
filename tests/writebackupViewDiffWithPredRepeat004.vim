" Test repeat view diff after error.

call vimtest#StartTap()
call vimtap#Plan(12)

cd $TEMP/WriteBackupTest
edit important.txt
call vimtap#err#Errors('Diff command failed; shell returned 2', 'WriteBackupViewDiffWithPred --invalid-argument', 'error shown')
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Like(getline(1), '^diff: \%(unrecognized\|unknown\) option .*invalid-argument', 'scratch buffer shows diff error output')

WriteBackupViewDiffWithPred -u
call vimtap#file#IsFilespec('WriteBackupTest/important.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Is(getline(3), '@@ -1,2 +1,2 @@', 'scratch buffers shows unified diff')

edit someplace\ else.txt
WriteBackup
echomsg 'side-by-side'
WriteBackupViewDiffWithPred --side-by-side
call vimtap#file#IsFilespec('WriteBackupTest/someplace else.txt.diff [Scratch]', 'scratch buffer')
call vimtap#file#IsNoFile('scratch buffer')
call vimtap#Like(getline(1), "it's a song\\s\\+it's a song", 'scratch buffer shows side-by-side diff output')
echomsg 'unified diff'
WriteBackupViewDiffWithPred -u
call vimtap#file#IsFilespec('WriteBackupTest/someplace else.txt', 'closed scratch buffer')
call vimtap#file#IsFile('original buffer')

call vimtest#Quit()

