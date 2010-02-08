" Test going through backup versions. 

call vimtest#StartTap()
call vimtap#Plan(14)

cd $TEMP/WriteBackupTest
edit important.txt

WriteBackupGoPrev
call vimtap#file#IsFilespec('important.txt.20080101b', 'GoPrev')
call vimtap#file#IsFile('GoPrev')

3WriteBackupGoPrev
call vimtap#file#IsFilespec('important.txt.20061201a', '3GoPrev')
call vimtap#file#IsFile('3GoPrev')

WriteBackupGoNext
call vimtap#file#IsFilespec('important.txt.20061231a', 'GoNext')
call vimtap#file#IsFile('GoNext')

WriteBackupGoPrev 2
call vimtap#file#IsFilespec('important.txt.19990815a', 'GoPrev 2')
call vimtap#file#IsFile('GoPrev 2')

echomsg 'Test: Going beyond first'
WriteBackupGoPrev
call vimtap#file#IsFilespec('important.txt.19990815a', 'GoPrev beyond first')
call vimtap#file#IsFile('GoPrev beyond first')

WriteBackupGoOriginal
call vimtap#file#IsFilespec('important.txt', 'GoOriginal')
call vimtap#file#IsFile('GoOriginal')

WriteBackupGoPrev
echomsg 'Test: Going beyond last'
WriteBackupGoNext
call vimtap#file#IsFilespec('important.txt.20080101b', 'GoNext beyond last')
call vimtap#file#IsFile('GoNext beyond last')

call vimtest#Quit() 

