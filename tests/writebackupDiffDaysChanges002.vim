" Test diff todays changes from current.

source helpers/diff.vim

call vimtest#StartTap()
call vimtap#Plan(5)

cd $TEMP/WriteBackupTest
edit not\ important.txt
try
    WriteBackupDiffDaysChanges
    call vimtap#Fail('expected error when no backups')
catch
    call vimtap#err#Thrown('No backups exist for this file.', 'error shown')
endtry
call vimtap#file#IsFilename('not important.txt', 'no backups')

WriteBackup
%s/junk/text/g
WriteBackup
%s/just/some/g
WriteBackup
%s/some/& more/g
write

WriteBackupDiffDaysChanges
call vimtap#file#IsFilename('not important.txt', 'stay at current')
wincmd h
let s:today = strftime('%Y%m%d')
call vimtap#file#IsFilename('not important.txt.'.s:today.'a', 'third revision to the left')
call vimtap#window#IsWindows(['not important.txt.'.s:today.'a', 'not important.txt'], 'DiffDaysChanges first & current')
echomsg 'Test: DiffDaysChanges'
call EchoDiff()

call vimtest#Quit()
