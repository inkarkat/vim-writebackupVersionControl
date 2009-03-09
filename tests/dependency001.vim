" Test dependency check of writebackupVersionControl.vim. 

if g:runVimTests =~# '\<user\>'
    call vimtest#Skip('writebackupVersionControl plugin already loaded')
endif

let g:loaded_writebackup = 140
echomsg 'Test: Dependency check wants higher version'
runtime plugin/writebackupVersionControl.vim

call vimtest#Quit() 

