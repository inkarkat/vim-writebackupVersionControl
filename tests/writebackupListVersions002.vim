" Test listing of backups from the future.
" (This can happen when the backup is written e.g. on a Samba share that has a
" different clock setting.)
" Tests that negative time differences are handled gracefully and specially
" reported.

cd $TEMP/WriteBackupTest
if has('win32') || has('win64')
    call vimtest#System('call unix --quiet && touch --date=+45seconds important.txt.20080101b')
else
    call vimtest#System('touch --date=+45seconds important.txt.20080101b')
endif

edit important.txt
echomsg 'Test: Backup from the future'
WriteBackupListVersions

call vimtest#Quit()

