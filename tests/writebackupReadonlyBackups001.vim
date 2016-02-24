" Test that backup versions are opened readonly. 

call vimtest#StartTap()
call vimtap#Plan(7)

cd $TEMP/WriteBackupTest
edit important.txt
call vimtap#Ok(! &l:readonly, 'Original is not readonly')

WriteBackupGoPrev
call vimtap#Ok(&l:readonly, 'GoPrev is readonly')

3WriteBackupGoPrev
call vimtap#Ok(&l:readonly, '3GoPrev is readonly')

WriteBackupGoOriginal
call vimtap#Ok(! &l:readonly, 'Original is not readonly')

WriteBackupGoNext
call vimtap#Ok(! &l:readonly, 'Original after GoNext is not readonly')

edit important.txt.20080101a
call vimtap#Ok(! &l:readonly, 'Opened backup is not readonly')

WriteBackupGoNext
call vimtap#Ok(&l:readonly, 'GoNext is readonly')

call vimtest#Quit() 

