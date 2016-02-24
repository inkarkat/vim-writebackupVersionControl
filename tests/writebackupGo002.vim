" Test going through backup versions in a different relative directory.

call vimtest#StartTap()
call vimtap#Plan(5)

let g:WriteBackup_BackupDir = './backup'
cd $TEMP/WriteBackupTest
edit someplace\ else.txt

2WriteBackupGoPrev
call vimtap#file#IsFilespec('WriteBackupTest/backup/someplace else.txt.20080124b', '2GoPrev')
call vimtap#file#IsFile('GoPrev')

WriteBackupGoNext
call vimtap#file#IsFilespec('WriteBackupTest/backup/someplace else.txt.20080124c', 'GoNext')
call vimtap#file#IsFile('GoNext')

call vimtap#err#Errors('Unable to determine the location of the original file.', 'WriteBackupGoOriginal', 'error shown')
" Note: Lookup in buffer list not yet implemented.
"call vimtap#file#IsFilespec('WriteBackupTest/someplace else.txt', 'GoOriginal')
"call vimtap#file#IsFile('GoOriginal')

call vimtest#Quit()
