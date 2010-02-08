" Test error conditions while going through backup versions. 

call vimtest#StartTap()
call vimtap#Plan(3)

cd $TEMP/WriteBackupTest
edit important.txt
normal! Goedited.
echomsg 'Test: Modified original buffer'
WriteBackupGoPrev
call vimtap#file#IsFilespec('important.txt', 'GoPrev on modified buffer')

WriteBackupGoPrev!
call vimtap#file#IsFilespec('important.txt.20080101b', 'GoPrev! on modified buffer')
call vimtap#file#IsFile('GoPrev! on modified buffer')

call vimtest#Quit() 

