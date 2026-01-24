" # Respect XDG Base Directory Specification

" Utility Function
" Ensure that a directory exists
function EnsureDir(dir)
	if !isdirectory(expand(a:dir))
		call mkdir(expand(a:dir), "p")
	endif
endfunction

" Base cache directory
let s:vim_cache_dir = $XDG_CACHE_HOME . "/" . "vim"

" Cache sub-directories
let &viminfo .= "," . "n" . s:vim_cache_dir . "/" . "viminfo"
let &directory = s:vim_cache_dir . "/" . "swap"
let &backupdir = s:vim_cache_dir . "/" . "backup"
let &undodir = s:vim_cache_dir . "/" . "undo"
let g:netrw_home = s:vim_cache_dir . "/" . "netrw"

" Ensure all directories exist
call EnsureDir(s:vim_cache_dir)
call EnsureDir(&directory)
call EnsureDir(&backupdir)
call EnsureDir(&undodir)
call EnsureDir(g:netrw_home)
