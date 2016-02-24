" Test maintaining diff mode when going through backup versions.

source helpers/diff.vim

call vimtest#StartTap()
call vimtap#Plan(7)

cd $TEMP/WriteBackupTest
edit important.txt.20080101b
WriteBackupDiffWithPred
call vimtap#file#IsFilename('important.txt.20080101b', 'stay at fourth revision')
wincmd h
call vimtap#file#IsFilename('important.txt.20080101a', 'third revision to the left')
call vimtap#window#IsWindows( map(['.20080101a', '.20080101b'], '"important.txt" . v:val'), 'DiffWithPred third & fourth')
echomsg 'Test: DiffWithPred third & fourth'
call EchoDiff()

WriteBackupGoNext
call vimtap#file#IsFilename('important.txt.20080101b', 'third revision to the left, too')
call vimtap#window#IsWindows( map(['.20080101b', '.20080101b'], '"important.txt" . v:val'), 'Diff third & third')
echomsg 'Test: WriteBackupGoNext to third & third'
call EchoDiff()

WriteBackupGoOriginal
call vimtap#file#IsFilename('important.txt', 'original to the left')
call vimtap#window#IsWindows( map(['', '.20080101b'], '"important.txt" . v:val'), 'Diff original & third')
echomsg 'Test: WriteBackupGoOriginal'
call EchoDiff()

call vimtest#Quit()
