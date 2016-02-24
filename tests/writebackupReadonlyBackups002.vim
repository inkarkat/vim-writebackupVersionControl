" Test that diff with predecessor is opened readonly. 

call vimtest#StartTap()
call vimtap#Plan(3)

cd $TEMP/WriteBackupTest

edit important.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')

WriteBackupDiffWithPred
call vimtap#Ok(! &l:readonly, 'Original after DiffWithPred is not readonly')
wincmd h
call vimtap#Ok(&l:readonly, 'Pred is readonly')

call vimtest#Quit() 

