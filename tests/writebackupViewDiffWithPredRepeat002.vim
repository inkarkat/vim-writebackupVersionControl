" Test repeat view diff with different diff arguments. 

call vimtest#StartTap()
call vimtap#Plan(4)

cd $TEMP/WriteBackupTest
edit important.txt
WriteBackupViewDiffWithPred -u
call vimtap#Is(getline(3), '@@ -1,2 +1,2 @@', 'unified diff')
WriteBackupViewDiffWithPred -c
call vimtap#Is(getline(4), '*** 1,2 ****', 'context diff')
WriteBackupViewDiffWithPred --normal
call vimtap#Is(getline(1), '1,2c1,2', 'normal diff')
WriteBackupViewDiffWithPred -q
call vimtap#Is(getline(1), 'Files important.txt.20080101b and important.txt differ', 'brief diff')

call vimtest#Quit() 

