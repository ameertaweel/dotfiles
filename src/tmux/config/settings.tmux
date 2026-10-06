# Make tmux read bash colors
set -g default-terminal "screen-256color"
set -g terminal-overrides ",xterm-256color:Tc"

# Enable mouse support
set -g mouse on

# Set starting window index
set -g base-index 0

# Set starting pane index
setw -g pane-base-index 0

# Keep the window numbers consistent
set -g renumber-windows on

# Address Vim window switching delay
set -s escape-time 0

# Increase scroll-back buffer size
set -g history-limit 50000

# Messages are displayed for x milliseconds
set -g display-time 4000

# Focus events enabled for terminals that support them
set -g focus-events on

# [ Panes ]

# Pane border styles
set -g pane-border-style $PANE_BORDER_STYLE
set -g pane-active-border-style $PANE_ACTIVE_BORDER_STYLE

# Pane number styles
set -g display-panes-colour $DISPLAY_PANES_COLOR
set -g display-panes-active-colour $DISPLAY_PANES_ACTIVE_COLOR

# [ Windows ]

# Enable activity alerts
set -g visual-activity on

# [ Status Bar ]

# Update status bar every x seconds
set -g status-interval 2

# Global status bar and message styles
set -g message-style $MSG_STYLE
set -g status-style $STATUS_STYLE

# [[ Left Status Bar ]]

# Display padded session name
set -g status-left "$SESSION_NAME_FORMAT #S "

# [[ Center Status Bar ]]

# Center the window names
set-option -g status-justify absolute-centre

# Set the formatting for active and inactive windows
set -g window-status-current-format "$WINDOW_STATUS_CURRENT_FORMAT #I #W "
set -g window-status-format "$WINDOW_STATUS_FORMAT #I #W "

# [[ Right Status Bar ]]

# Show hint on prefix key press
set -g status-right "#{?client_prefix,$PREFIX_HIGHLIGHT_FORMAT ^B ,\
    }#[default]"

# Separator
set -ag status-right " "

# Show zoom state
set -ag status-right "#{?window_zoomed_flag,$ZOOMED_MODE_FORMAT ZOOMED ,\
$NORMAL_MODE_FORMAT NORMAL }"
