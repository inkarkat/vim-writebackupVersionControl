" Test diff with predecessor.

source helpers/diff.vim

call vimtest#StartTap()
call vimtap#Plan(8)

cd $TEMP/WriteBackupTest
edit important.txt.19990815a
try
    WriteBackupDiffWithPred
    call vimtap#Fail('expected error when no predecessor')
catch
    call vimtap#err#Thrown('This is the earliest backup: important.txt.19990815a', 'error shown')
endtry
call vimtap#file#IsFilename('important.txt.19990815a', 'no predecessor')

edit important.txt
WriteBackupDiffWithPred
call vimtap#file#IsFilename('important.txt', 'stay at original')
wincmd h
call vimtap#file#IsFilename('important.txt.20080101b', 'fourth revision to the left')
call vimtap#window#IsWindows( map(['.20080101b', ''], '"important.txt" . v:val'), 'DiffWithPred fourth & original')
echomsg 'Test: DiffWithPred fourth & original'
call EchoDiff()

WriteBackupDiffWithPred
call vimtap#file#IsFilename('important.txt.20080101b', 'stay at fourth revision')
wincmd h
call vimtap#file#IsFilename('important.txt.20080101a', 'third revision to the left')
call vimtap#window#IsWindows( map(['.20080101a', '.20080101b', ''], '"important.txt" . v:val'), 'DiffWithPred third & fourth & original')
echomsg 'Test: DiffWithPred third & fourth & original'
call EchoDiff()

call vimtest#Quit()
