" Test diff todays changes from backups.

source helpers/diff.vim

call vimtest#StartTap()
call vimtap#Plan(13)

cd $TEMP/WriteBackupTest
edit important.txt.19990815a
try
    WriteBackupDiffDaysChanges
    call vimtap#Fail('expected error when no predecessor')
catch
    call vimtap#err#Thrown('This is the earliest backup: important.txt.19990815a', 'error shown')
endtry
call vimtap#file#IsFilename('important.txt.19990815a', 'no predecessor')

edit important.txt
try
    WriteBackupDiffDaysChanges
    call vimtap#Fail('expected error when no backup from today')
catch
    call vimtap#err#Thrown("Couldn't locate a backup from today: important.txt", 'error shown')
endtry
call vimtap#file#IsFilename('important.txt', 'stay at current')

saveas important.txt.20080101c
WriteBackupDiffDaysChanges
call vimtap#file#IsFilename('important.txt.20080101c', 'stay at current')
wincmd h
call vimtap#file#IsFilename('important.txt.20080101a', 'third revision to the left')
call vimtap#window#IsWindows( map(['.20080101a', '.20080101c'], '"important.txt" . v:val'), 'DiffDaysChanges third & current')
echomsg 'Test: DiffDaysChanges third & current'
call EchoDiff()

try
    WriteBackupDiffDaysChanges
    call vimtap#Fail('expected error when no more backups')
catch
    call vimtap#err#Thrown("This is the day's earliest backup: important.txt.20080101a", 'error shown')
endtry
call vimtap#file#IsFilename('important.txt.20080101a', 'stay at third revision')
call vimtap#window#IsWindows( map(['.20080101a', '.20080101c'], '"important.txt" . v:val'), 'DiffDaysChanges third & current')

edit important.txt.20080101b
only
1WriteBackupDiffDaysChanges
call vimtap#file#IsFilename('important.txt.20080101b', 'stay at fourth revision')
wincmd h
call vimtap#file#IsFilename('important.txt.20080101a', 'third revision to the left')
call vimtap#window#IsWindows( map(['.20080101a', '.20080101b'], '"important.txt" . v:val'), 'DiffDaysChanges third & fourth')
echomsg 'Test: DiffDaysChanges third & fourth'
call EchoDiff()

call vimtest#Quit()
