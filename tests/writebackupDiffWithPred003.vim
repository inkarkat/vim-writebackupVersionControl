" Test diff with nth predecessor.

call vimtest#StartTap()
call vimtap#Plan(7)

cd $TEMP/WriteBackupTest
edit important.txt
2WriteBackupDiffWithPred
call vimtap#file#IsFilename('important.txt', 'stay at original')
wincmd h
call vimtap#file#IsFilename('important.txt.20080101a', 'third revision to the left')
call vimtap#window#IsWindows( map(['.20080101a', ''], '"important.txt" . v:val'), 'DiffWithPred third & original')

WriteBackupDiffWithPred 999
wincmd h
call vimtap#file#IsFilename('important.txt.19990815a', 'start revision to the left')
call vimtap#window#IsWindows( map(['.19990815a', '.20080101a', ''], '"important.txt" . v:val'), 'DiffWithPred start & third & original')

call vimtap#err#Errors('This is the earliest backup: important.txt.19990815a', 'WriteBackupDiffWithPred 4', 'error shown')
call vimtap#file#IsFilename('important.txt.19990815a', 'no predecessor')

call vimtest#Quit()
