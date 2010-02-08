" Test diff with predecessor. 

function! s:EchoDiff()
    let l:winNr = winnr()
    windo setlocal diff?
    execute l:winNr . 'wincmd w' 
endfunction

call vimtest#StartTap()
call vimtap#Plan(7)

cd $TEMP/WriteBackupTest
edit important.txt.19990815a
echomsg 'Test: No predecessor'
WriteBackupDiffWithPred
call vimtap#file#IsFilespec('important.txt.19990815a', 'no predecessor')

edit important.txt
WriteBackupDiffWithPred
call vimtap#file#IsFilespec('important.txt', 'stay at original')
wincmd h
call vimtap#file#IsFilespec('important.txt.20080101b', 'fourth revision to the left')
call vimtap#window#IsWindows( map(['.20080101b', ''], '"important.txt" . v:val'), 'DiffWithPred fourth & original')
echomsg 'Test: DiffWithPred fourth & original'
call s:EchoDiff()

WriteBackupDiffWithPred
call vimtap#file#IsFilespec('important.txt.20080101b', 'stay at fourth revision')
wincmd h
call vimtap#file#IsFilespec('important.txt.20080101a', 'third revision to the left')
call vimtap#window#IsWindows( map(['.20080101a', '.20080101b', ''], '"important.txt" . v:val'), 'DiffWithPred third & fourth & original')
echomsg 'Test: DiffWithPred third & fourth & original'
call s:EchoDiff()

call vimtest#Quit() 

