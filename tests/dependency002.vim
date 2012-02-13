" Test dependency check of writebackupVersionControl.vim. 

call vimtest#SkipAndQuitIf(exists('g:loaded_writebackupVersionControl'), 'writebackupVersionControl plugin already loaded')

let g:loaded_writebackup = 300
echomsg 'Test: Dependency check wants same major version'
runtime plugin/writebackupVersionControl.vim

call vimtest#Quit() 

