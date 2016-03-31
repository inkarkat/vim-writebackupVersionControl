" Show bad interaction of diff with predecessor with 'autochdir' + :cd. 

call vimtest#SkipAndQuitIf(! exists('+autochdir'), "Need 'autochdir' option")

call vimtest#StartTap()
call vimtap#Plan(3)

set autochdir

cd $TEMP/WriteBackupTest
edit important.txt
" This creates a discrepancy between the relative filespec and the CWD. 
cd ..
WriteBackupDiffWithPred
call vimtap#file#IsFilename('important.txt', 'stay at original')
wincmd h
call vimtap#file#IsFilename('important.txt.20080101b', 'fourth revision to the left')
" Resulting in a wrong pathspec to the backup file here. 
call vimtap#file#IsNoFile('fourth revision to the left')

call vimtest#Quit() 

