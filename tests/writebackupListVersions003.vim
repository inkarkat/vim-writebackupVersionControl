" Test listing of and going to backups with Windows filenames differing in case.

cd $TEMP/WriteBackupTest

edit important.txt.20061201a
%s/first/UPPERCASE/
saveas IMPORTANT.TXT.20070707a
%s/UPPERCASE/EXTENSION/
saveas important.txt.20070707B
%s/EXTENSION/MiXed/
saveas imPOrtANT.txt.20061212a
edit important.txt
if len(split(glob('important.txt.*'), "\n")) < 8
    call vimtest#Skip('This file system is case-sensitive.')
    call vimtest#Quit()
endif

echomsg 'Test: Listing of differing case files from file''s directory'
WriteBackupListVersions

echomsg 'Test: Listing with a different CWD, new recent backup'
cd $VIM
%s/current/fifth/
WriteBackup
WriteBackupListVersions


call vimtest#StartTap()
call vimtap#Plan(2)
7WriteBackupGoPrev!
call vimtap#file#IsFilename('imPOrtANT.txt.20061212a', '7GoPrev')
call vimtap#file#IsFile('GoPrev')

call vimtest#Quit()
