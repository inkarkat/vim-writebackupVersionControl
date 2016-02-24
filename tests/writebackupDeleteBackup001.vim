" Test backup deletion failures. 
" Tests that an original file cannot be deleted, even when forced. 
" Tests exception on nonexisting backup file. 
" Tests exception on readonly backup file, and how it is overcome when forced. 

source helpers/file.vim

call vimtest#StartTap()
call vimtap#Plan(4)

cd $TEMP/WriteBackupTest

try
    call writebackupVersionControl#DeleteBackup('important.txt', 1)
    call vimtap#Ok(0, 'Should not be able to delete original file')
catch /WriteBackupVersionControl:/
    call vimtap#Ok(1, 'Cannot delete original file')
    echomsg v:exception
endtry

try
    call writebackupVersionControl#DeleteBackup('doesnotexist.txt.20010101z', 0)
    call vimtap#Ok(0, 'Should not be able to delete nonexisting backup file')
catch /WriteBackupVersionControl:/
    call vimtap#Ok(1, 'Cannot delete nonexisting backup file')
    echomsg v:exception
endtry

call MakeReadonly('important.txt.20080101b')
try
    call writebackupVersionControl#DeleteBackup('important.txt.20080101b', 0)
    call vimtap#Ok(0, 'Should not be able to delete readonly backup file')
catch /WriteBackupVersionControl:/
    call vimtap#Ok(1, 'Cannot delete readonly backup file')
    echomsg v:exception
endtry

call MakeReadonly('important.txt.20080101a')
try
    call writebackupVersionControl#DeleteBackup('important.txt.20080101a', 1)
    call vimtap#Ok(1, 'Can forcibly delete readonly backup file')
catch /WriteBackupVersionControl:/
    call vimtap#Ok(0, 'Should be able to forcibly delete readonly backup file')
    echomsg v:exception
endtry

call ListFiles()
call vimtest#Quit() 

