" Test dependency check of writebackupVersionControl.vim. 

call vimtest#SkipAndQuitIf(exists('g:loaded_writebackupVersionControl'), 'writebackupVersionControl plugin already loaded')

let g:loaded_writebackup = 210
echomsg 'Test: Dependency check wants higher version'
runtime plugin/writebackupVersionControl.vim

call vimtest#Quit() 

