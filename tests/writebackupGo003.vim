" Test error conditions while going through backup versions.

call vimtest#StartTap()
call vimtap#Plan(4)

cd $TEMP/WriteBackupTest
edit important.txt
normal! Goedited.
call vimtap#err#Errors('E37: No write since last change (add ! to override)', 'WriteBackupGoPrev', 'error shown')
call vimtap#file#IsFilename('important.txt', 'GoPrev on modified buffer')

WriteBackupGoPrev!
call vimtap#file#IsFilename('important.txt.20080101b', 'GoPrev! on modified buffer')
call vimtap#file#IsFile('GoPrev! on modified buffer')

call vimtest#Quit()
