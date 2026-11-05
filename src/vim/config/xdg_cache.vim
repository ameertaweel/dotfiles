" # Respect XDG Base Directory Specification

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ## Utility Functions

function s:NonEmpty(val)
    return !empty(a:val)
endfunction

" Ensure that a directory exists
function s:EnsureDir(dir)
	if !isdirectory(expand(a:dir))
		call mkdir(expand(a:dir), "p")
	endif
endfunction

" Directories ending in two path separators ensure unique file names.
" Read more via `:h 'directory'`
function s:MakeUnique(dir)
    return a:dir . "//"
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ## Cache State Directories

" Base XDG Cache/State Directories (With Fallback)
let s:xdg_cache_home = s:NonEmpty($XDG_CACHE_HOME) ? $XDG_CACHE_HOME : $HOME . "/.cache"
let s:xdg_state_home = s:NonEmpty($XDG_STATE_HOME) ? $XDG_STATE_HOME : $HOME . "/.local/state"

" Vim Cache/State Directories
let s:vim_cache_dir = s:xdg_cache_home . "/vim"
let s:vim_state_dir = s:xdg_state_home . "/vim"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ## Define Directory/File Paths

" Vim's swap files are transient session files, so they fit best in cache.
let s:swap_dir     = s:vim_cache_dir . "/swap"
let s:backup_dir   = s:vim_state_dir . "/backup"
let s:undo_dir     = s:vim_state_dir . "/undo"
let s:netrw_dir    = s:vim_state_dir . "/netrw"
let s:viminfo_file = s:vim_state_dir . "/viminfo"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ## Set Vim Settings

let &directory   = s:MakeUnique(s:swap_dir)
let &backupdir   = s:MakeUnique(s:backup_dir)
let &undodir     = s:MakeUnique(s:undo_dir)
let g:netrw_home = s:netrw_dir

let &viminfo    .= "," . "n" . s:viminfo_file

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ## Ensure all directories exist

call s:EnsureDir(s:swap_dir)
call s:EnsureDir(s:backup_dir)
call s:EnsureDir(s:undo_dir)
call s:EnsureDir(s:netrw_dir)
