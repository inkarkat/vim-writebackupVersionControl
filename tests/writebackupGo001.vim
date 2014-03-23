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

try
    WriteBackupGoPrev
    call vimtap#Fail('expected error when going beyond first')
catch
    call vimtap#err#Thrown('This is the earliest backup: important.txt.19990815a', 'error shown')
endtry
call vimtap#file#IsFilename('important.txt.19990815a', 'GoPrev beyond first')
call vimtap#file#IsFile('GoPrev beyond first')

WriteBackupGoOriginal
call vimtap#file#IsFilename('important.txt', 'GoOriginal')
call vimtap#file#IsFile('GoOriginal')

WriteBackupGoPrev
try
    WriteBackupGoNext
    call vimtap#Fail('expected error when going beyond last')
catch
    call vimtap#err#Thrown('This is the latest backup: important.txt.20080101b', 'error shown')
endtry
call vimtap#file#IsFilename('important.txt.20080101b', 'GoNext beyond last')
call vimtap#file#IsFile('GoNext beyond last')

call vimtest#Quit()
