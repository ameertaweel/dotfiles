# Reload .tmux.conf
bind r source-file ~/.tmux.conf \; display-message "~/.tmux.conf Reloaded."

# [ Splitting ]

# Unbind original screen splitting bindings
unbind '"'
unbind %

# Split screen with the current path as root
bind - split-window -v -c "#{pane_current_path}"
bind / split-window -h -c "#{pane_current_path}"

# Split screen with default path as root
bind _ split-window -v
bind ? split-window -h

# [ Windows ]

# Create a new window with the current path
bind c new-window -c "#{pane_current_path}"

# Create a new window with the default path
bind C new-window

# [ Panes ]

# Pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Break a pane out to a new window
bind b break-pane -d

# Swap a pane (targeted by pane number) with the current pane
bind S display-panes\; command-prompt -p "Swap with pane: " "swap-pane -t '%%'"
