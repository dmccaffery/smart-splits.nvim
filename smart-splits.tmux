#!/usr/bin/env bash

get_tmux_option() {
  local option value default
  option="$1"
  default="$2"
  value=$(tmux show-option -gqv "$option")

  if [ -n "$value" ]; then
    if [ "$value" = "null" ]; then
      echo ""
    else
      echo "$value"
    fi
  else
    echo "$default"
  fi
}

bind_key_vim() {
  local key tmux_cmd
  key="$1"
  tmux_cmd="$2"

  tmux bind-key -n "$key" if -F "#{@pane-is-vim}" "send-keys '$key'" "$tmux_cmd"
  tmux bind-key -T copy-mode-vi "$key" $tmux_cmd
}

move_left="$(get_tmux_option "@smart_splits_move_left" 'C-h')"
move_right="$(get_tmux_option "@smart_splits_move_right" 'C-l')"
move_up="$(get_tmux_option "@smart_splits_move_up" 'C-k')"
move_down="$(get_tmux_option "@smart_splits_move_down" 'C-j')"
move_prev="$(get_tmux_option "@smart_splits_move_prev" 'C-\')"

for k in $(echo "$move_left");  do bind_key_vim "$k" "select-pane -L"; done
for k in $(echo "$move_down");  do bind_key_vim "$k" "select-pane -D"; done
for k in $(echo "$move_up");    do bind_key_vim "$k" "select-pane -U"; done
for k in $(echo "$move_right"); do bind_key_vim "$k" "select-pane -R"; done
for k in $(echo "$move_prev");  do bind_key_vim "$k" "select-pane -l"; done

resize_left="$(get_tmux_option "@smart_splits_resize_left" 'M-h')"
resize_right="$(get_tmux_option "@smart_splits_resize_right" 'M-l')"
resize_up="$(get_tmux_option "@smart_splits_resize_up" 'M-k')"
resize_down="$(get_tmux_option "@smart_splits_resize_down" 'M-j')"

for k in $(echo "$resize_left");  do bind_key_vim "$k" "resize-pane -L 3"; done
for k in $(echo "$resize_down");  do bind_key_vim "$k" "resize-pane -D 3"; done
for k in $(echo "$resize_up");    do bind_key_vim "$k" "resize-pane -U 3"; done
for k in $(echo "$resize_right"); do bind_key_vim "$k" "resize-pane -R 3"; done

# Restoring clear screen
tmux bind C-l send-keys 'C-l'
