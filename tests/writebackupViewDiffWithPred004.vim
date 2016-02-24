" Test view diff with different diff roots / CWDs. 

call vimtest#StartTap()
call vimtap#Plan(3)

cd $TEMP/WriteBackupTest

edit important.txt
cd backup
WriteBackupViewDiffWithPred
call vimtap#Like(getline(1), '^--- .*[/\\]WriteBackupTest[/\\]important\.txt\.20080101b', 'diff from ./backup')
close

cd $VIM
WriteBackupViewDiffWithPred
call vimtap#Like(getline(1), '^--- .*[/\\]WriteBackupTest[/\\]important\.txt\.20080101b', 'diff from $VIM')
close

cd $TEMP
WriteBackupViewDiffWithPred
call vimtap#Like(getline(1), '^--- WriteBackupTest[/\\]important\.txt\.20080101b', 'diff from ..')
close


call vimtest#Quit() 

