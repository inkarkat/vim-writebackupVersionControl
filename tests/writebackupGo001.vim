" Test going through backup versions.

call vimtest#StartTap()
call vimtap#Plan(16)

cd $TEMP/WriteBackupTest
edit important.txt

WriteBackupGoPrev
call vimtap#file#IsFilename('important.txt.20080101b', 'GoPrev')
call vimtap#file#IsFile('GoPrev')

3WriteBackupGoPrev
call vimtap#file#IsFilename('important.txt.20061201a', '3GoPrev')
call vimtap#file#IsFile('3GoPrev')

WriteBackupGoNext
call vimtap#file#IsFilename('important.txt.20061231a', 'GoNext')
call vimtap#file#IsFile('GoNext')

WriteBackupGoPrev 2
call vimtap#file#IsFilename('important.txt.19990815a', 'GoPrev 2')
call vimtap#file#IsFile('GoPrev 2')

call vimtap#err#Errors('This is the earliest backup: important.txt.19990815a', 'WriteBackupGoPrev', 'error shown')
call vimtap#file#IsFilename('important.txt.19990815a', 'GoPrev beyond first')
call vimtap#file#IsFile('GoPrev beyond first')

WriteBackupGoOriginal
call vimtap#file#IsFilename('important.txt', 'GoOriginal')
call vimtap#file#IsFile('GoOriginal')

WriteBackupGoPrev
call vimtap#err#Errors('This is the latest backup: important.txt.20080101b', 'WriteBackupGoNext', 'error shown')
call vimtap#file#IsFilename('important.txt.20080101b', 'GoNext beyond last')
call vimtap#file#IsFile('GoNext beyond last')

call vimtest#Quit()
