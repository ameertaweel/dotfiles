" # Leader Key

let mapleader = ' '

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

" Actions
map <leader>ar <Action>(RenameElement)
map <leader>af <Action>(ReformatCode)

" Search
map <leader>ff <Action>(GotoFile)
map <leader>fl <Action>(TextSearchAction)
map <leader>fe <Action>(SearchEverywhere)

" # Other Mappings

" Enter creates a new line in normal mode
nnoremap <cr> o<esc>
" Remove highlighted search results
nnoremap <leader>th :noh<cr>
" Show registers
nnoremap <leader>rg :reg<cr>
" Make . work with visually selected lines
vnoremap . :normal.<cr>
