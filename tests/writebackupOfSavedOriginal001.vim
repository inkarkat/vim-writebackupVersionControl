" Test backup of saved file. 

call vimtest#StartTap()
call vimtap#Plan(2)

cd $TEMP/WriteBackupTest
edit important.txt.20080101b
echomsg 'Test: Cannot backup a backup file'
WriteBackupOfSavedOriginal

edit important.txt
let s:beforeEdit = getline(1)
normal! ggg~~A-edited
let s:afterEdit = getline(1)
WriteBackupOfSavedOriginal
WriteBackupGoPrev!
let s:backupFile = getline(1)
call vimtap#Is(s:backupFile, s:beforeEdit, 'Backup contents match line before edit')
call vimtap#Isnt(s:backupFile, s:afterEdit, 'Backup contents do not match line after edit')

call vimtest#Quit() 

