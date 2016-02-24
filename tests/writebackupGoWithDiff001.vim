" Test maintaining diff mode when going through backup versions.

source helpers/diff.vim

call vimtest#StartTap()
call vimtap#Plan(11)

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupDiffWithPred
call vimtap#file#IsFilename('important.txt', 'stay at original')
wincmd h
call vimtap#file#IsFilename('important.txt.20080101b', 'fourth revision to the left')
call vimtap#window#IsWindows( map(['.20080101b', ''], '"important.txt" . v:val'), 'DiffWithPred fourth & original')
echomsg 'Test: DiffWithPred fourth & original'
call EchoDiff()

WriteBackupGoPrev
call vimtap#file#IsFilename('important.txt.20080101a', 'third revision to the left')
call vimtap#window#IsWindows( map(['.20080101a', ''], '"important.txt" . v:val'), 'Diff third & original')
echomsg 'Test: WriteBackupGoPrev to third & original'
call EchoDiff()

2WriteBackupGoPrev
call vimtap#file#IsFilename('important.txt.20061201a', 'first revision to the left')
call vimtap#window#IsWindows( map(['.20061201a', ''], '"important.txt" . v:val'), 'Diff first & original')
echomsg 'Test: WriteBackupGoPrev to first & original'
call EchoDiff()

WriteBackupGoNext
call vimtap#file#IsFilename('important.txt.20061231a', 'second revision to the left')
call vimtap#window#IsWindows( map(['.20061231a', ''], '"important.txt" . v:val'), 'Diff second & original')
echomsg 'Test: WriteBackupGoNext to second & original'
call EchoDiff()

edit #
call vimtap#file#IsFilename('important.txt.20061201a', 'first revision to the left')
call vimtap#window#IsWindows( map(['.20061201a', ''], '"important.txt" . v:val'), 'Diff first & original')
echomsg 'Test: edit alternate file to second & original'
call EchoDiff()

call vimtest#Quit()
