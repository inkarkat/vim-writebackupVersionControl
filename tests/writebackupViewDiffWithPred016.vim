" Test view diff buffer-local options and arguments.

cd $TEMP/WriteBackupTest
edit important.txt

let g:WriteBackup_DiffCreateDefaultArguments = '-u'
let g:WriteBackup_DiffCreateAlwaysArguments = ''
let b:WriteBackup_DiffCreateDefaultArguments = '-c'
let b:WriteBackup_DiffCreateAlwaysArguments = '-F "foo" -I "^[\\t ]\\\\"'

echomsg 'Test: buffer-local always and default arguments'
WriteBackupViewDiffWithPred
close

echomsg 'Test: passed additional arguments; buffer-local always arguments'
WriteBackupViewDiffWithPred -y
close

call vimtest#Quit()
