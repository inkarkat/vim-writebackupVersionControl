" Test backup of saved file.

call vimtest#StartTap()
call vimtap#Plan(4)

cd $TEMP/WriteBackupTest
edit important.txt.20080101b
try
    WriteBackupOfSavedOriginal
    call vimtap#Fail('expected error: Cannot backup a backup file')
catch
    call vimtap#err#Thrown('You can only backup the latest file version, not a backup file itself!', 'error shown')
endtry

edit important.txt
let s:beforeEdit = getline(1)
normal! ggg~~A-edited
let s:afterEdit = getline(1)
WriteBackupOfSavedOriginal
WriteBackupGoPrev!
call vimtap#Ok(getftime(expand('%')) > getftime('important.txt'), 'Backup modification date is newer than that of original file')
let s:backupFile = getline(1)
call vimtap#Is(s:backupFile, s:beforeEdit, 'Backup contents match line before edit')
call vimtap#Isnt(s:backupFile, s:afterEdit, 'Backup contents do not match line after edit')

call vimtest#Quit()
