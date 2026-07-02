" Leader Key
let mapleader = ','

" # Splitting windows

nnoremap <leader>- :split<cr>
nnoremap <leader>/ :vsplit<cr>

" # Window Movement

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" # System Clipboard

" NOTE: Vim needs to be compiled with the +clipboard flag for this to work.

" Normal Mode
nnoremap <leader>y "+y
nnoremap <leader>d "+d
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" Visual Mode
vnoremap <leader>d "+d
vnoremap <leader>y "+y
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" # Tabs

nnoremap <leader>tn  :tabnew<cr>
nnoremap <leader>tc  :tabclose<cr>

" # Git and Version Control

" Opens git status with the ability to stage and unstage commits
nnoremap <leader>gm :G<cr>
" Stage current file
nnoremap <leader>ga :Git add %<cr>
" Commit
nnoremap <leader>gc :Git commit<cr>
" Push
nnoremap <leader>gp :Git push<cr>

" # Other Mappings

" Enter creates a new line in normal mode
nnoremap <cr> o<esc>

" Go back in the last t, f, T, and F using space
nnoremap <space> ,

" Remove highlighted search results
nnoremap <leader>th :noh<cr>

" Show registers
nnoremap <leader>rg :reg<cr>

" Make . to work with visually selected lines
vnoremap . :normal.<cr>

" Swap Window
nnoremap <leader>ww :call WindowSwap#EasyWindowSwap()<cr>
