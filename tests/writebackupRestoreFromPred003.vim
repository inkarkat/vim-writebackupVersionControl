" Test forced restore from predecessor.
" Tests that restore from backup file is still disallowed.
" Tests that restore works without confirmation.

call vimtest#StartTap()
call vimtap#Plan(4)

cd $TEMP/WriteBackupTest
edit important.txt.20080101b
call vimtap#err#Errors('You can only restore the original file, not a backup!', 'WriteBackupRestoreFromPred!', 'error shown')

edit important.txt
WriteBackupRestoreFromPred!
call vimtap#file#IsFilename('important.txt', 'RestoreFromPred!')
call vimtap#file#IsFile('RestoreFromPred!')
call vimtap#Is(getline(1), 'fourth revision', 'RestoreFromPred! predecessor''s contents')

call vimtest#Quit()
