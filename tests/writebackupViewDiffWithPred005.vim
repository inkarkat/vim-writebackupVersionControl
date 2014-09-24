" Test view diff with backups in a different absolute directory. 

call vimtest#StartTap()
call vimtap#Plan(2)

let g:WriteBackup_BackupDir = $TEMP . '/WriteBackupTest/backup'
cd $TEMP/WriteBackupTest

edit someplace\ else.txt
WriteBackupViewDiffWithPred
call vimtap#Like(getline(1), '^--- backup[/\\]someplace else\.txt\.20080124c', 'diff from .')
close

cd ..
WriteBackupViewDiffWithPred
call vimtap#Like(getline(1), '^--- WriteBackupTest[/\\]backup[/\\]someplace else\.txt\.20080124c', 'diff from ..')
close

call vimtest#Quit() 

