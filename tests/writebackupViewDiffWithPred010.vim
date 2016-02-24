" Test view diff with predecessor error conditions.

call vimtest#StartTap()
call vimtap#Plan(5)

cd $TEMP/WriteBackupTest
edit important.txt.19990815a
call vimtap#err#Errors('This is the earliest backup: important.txt.19990815a', 'WriteBackupViewDiffWithPred', 'error shown')
call vimtap#file#IsFilename('important.txt.19990815a', 'no predecessor')

edit not\ important.txt
WriteBackupViewDiffWithPred
call vimtap#err#Errors('No backups exist for this file.', 'WriteBackupViewDiffWithPred', 'error shown')
call vimtap#file#IsFilename('not important.txt', 'no backups')

let g:WriteBackup_DiffShellCommand = ''
call vimtap#err#Errors('No diff shell command configured. Unable to show differences to predecessor.', 'WriteBackupViewDiffWithPred', 'error shown')

call vimtest#Quit()
