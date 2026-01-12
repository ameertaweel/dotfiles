" Leader Key
let mapleader = ','

" # Moving between windows

nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" # Windows

" Splitting
nnoremap <leader>- :split<cr>
nnoremap <leader>/ :vsplit<cr>

" Moving
map gt <Action>(NextTab)
map gT <Action>(PreviousTab)

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

" # Code Formatting and Navigation

map <leader>ar <Action>(RenameElement)
map <leader>af <Action>(ReformatCode)
" Fuzzy find files by name
map <leader>ff <Action>(GotoFile)
map <leader>gd <Action>(GotoDeclaration)
" List References
map <leader>lr <Action>(FindUsages)
map [d <Action>(GotoPreviousError)
map ]d <Action>(GotoNextError)

" # Other Mappings

" Enter creates a new line in normal mode
nnoremap <cr> o<esc>

" Enable folding with the space bar
map <space> <Action>(CollapseBlock)

" Remove highlighted search results
nnoremap <leader>th :noh<cr>

" Show registers
nnoremap <leader>rg :reg<cr>

" Make . to work with visually selected lines
vnoremap . :normal.<cr>
