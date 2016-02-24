" Test view diff options and arguments. 

cd $TEMP/WriteBackupTest
edit important.txt

let g:WriteBackup_DiffCreateDefaultArguments = '-u'
let g:WriteBackup_DiffCreateAlwaysArguments = '-a -t'

echomsg 'Test: set diffopt+=icase,iwhite'
set diffopt=icase,iwhite
WriteBackupViewDiffWithPred
set diffopt&
close

echomsg 'Test: passed additional arguments'
WriteBackupViewDiffWithPred -c -F "revision" -I "^[\\t ]\\\\"
close

echomsg 'Test: complex default arguments'
let g:WriteBackup_DiffCreateDefaultArguments = '-c -F "foo" -I "^[\\t ]\\\\"'
WriteBackupViewDiffWithPred
close

echomsg 'Test: no arguments at all'
let g:WriteBackup_DiffCreateDefaultArguments = ''
let g:WriteBackup_DiffCreateAlwaysArguments = ''
WriteBackupViewDiffWithPred
close

call vimtest#Quit() 

