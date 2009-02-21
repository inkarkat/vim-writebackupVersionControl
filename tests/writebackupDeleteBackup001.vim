" Test backup deletion failures. 

call vimtest#StartTap()
call vimtap#Plan(2)

cd $TEMP/WriteBackupTest

try
    call writebackupVersionControl#DeleteBackup('important.txt')
    call vimtap#Ok(0, 'Should not be able to delete original file')
catch /WriteBackupVersionControl:/
    call vimtap#Ok(1, 'Cannot delete original file')
    echomsg v:exception
endtry

try
    call writebackupVersionControl#DeleteBackup('doesnotexist.txt.20010101z')
    call vimtap#Ok(0, 'Should not be able to delete nonexisting backup file')
catch /WriteBackupVersionControl:/
    call vimtap#Ok(1, 'Cannot delete nonexisting backup file')
    echomsg v:exception
endtry

call ListFiles()
call vimtest#Quit() 

