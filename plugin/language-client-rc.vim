set hidden

let g:LanguageClient_serverCommands = {}

if executable('rls')
  let g:LanguageClient_serverCommands['rust'] = ['rustup', 'run', 'stable', 'rls']
endif

if executable('pyls')
  let g:LanguageClient_serverCommands['python'] = ['pyls']
elseif !empty($PYLS_EXECUTABLE)
  let s:pyls = expand($PYLS_EXECUTABLE)
  if executable(s:pyls)
    let g:LanguageClient_serverCommands['python'] = [s:pyls]
  endif
endif

if executable('clangd')
  let g:LanguageClient_serverCommands['cpp'] = ['clangd']
  let g:LanguageClient_serverCommands['c'] = ['clangd']
elseif executable('/usr/local/opt/llvm/bin/clangd')
  let g:LanguageClient_serverCommands['cpp'] = ['/usr/local/opt/llvm/bin/clangd']
  let g:LanguageClient_serverCommands['c'] = ['/usr/local/opt/llvm/bin/clangd']
endif

if executable('docker-langserver')
  let g:LanguageClient_serverCommands['dockerfile'] = [&shell, &shellcmdflag, 'docker-langserver --stdio']
endif

if executable('gopls')
  let g:LanguageClient_serverCommands['go'] = ['gopls']
endif

if executable('bash-language-server')
  let g:LanguageClient_serverCommands['sh'] = ['bash-language-server', 'start']
endif


" Common Configurations
augroup LanguageClient_config
  autocmd!
  autocmd User LanguageClientStarted setlocal signcolumn=yes
  autocmd User LanguageClientStopped setlocal signcolumn=auto
augroup END

function LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    " any keybindings you want, such as ...
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <silent> <S-C-a> :call LanguageClient_textDocument_codeAction()<CR>
    nnoremap <silent> <Leader>lh :call LanguageClient_textDocument_hover()<CR>
    nnoremap <silent> <Leader>ld :call LanguageClient_textDocument_definition()<CR>
    nnoremap <silent> <Leader>lr :call LanguageClient_textDocument_rename()<CR>
    nnoremap <silent> <Leader>lf :call LanguageClient_textDocument_formatting()<CR>
  endif
endfunction
autocmd FileType * call LC_maps()

augroup LCHighlight
  autocmd!
  autocmd CursorHold,CursorHoldI *.py,*.c,*.cpp call LanguageClient#textDocument_documentHighlight()
augroup END
