" Test returning to original buffer on no diff output. 
"
call vimtest#StartTap()
call vimtap#Plan(4) 

cd $TEMP/WriteBackupTest
edit someplace\ else.txt
botright split not\ important.txt
botright split important.txt
WriteBackup
WriteBackup!

" Make the diff scratch buffer appear at the very top, so that it is *not*
" directly above the original buffer. 
let g:WriteBackup_ScratchBufferCommandModifiers = 'topleft'

WriteBackupViewDiffWithPred

call vimtap#file#IsFilename('important.txt', 'still at original')
call vimtap#file#IsFile('still at original')
call vimtap#Is(winnr('$'), 3, 'only original windows') 
call vimtap#Is(winnr(), 3, 'at original window') 

call vimtest#Quit() 

