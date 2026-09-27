# Helper to manage cdpath dynamically

_init_cdpath() {
  local file="$HOME/.config/zsh/cdpaths"
  if [[ -f "$file" ]]; then
    # Read lines, filter empty/comments, and set cdpath
    cdpath=(. ~ ${(f)"$(grep -v '^\s*$' "$file" | grep -v '^\s*#')"})
  else
    cdpath=(. ~)
  fi
}

_init_cdpath
unfunction _init_cdpath

cdpath() {
  local file="$HOME/.config/zsh/cdpaths"
  local action="$1"
  local dir="$2"
  
  if [[ -z "$action" ]]; then
    # Show current cdpath variable content
    print -l $cdpath
    return 0
  fi
  
  if [[ "$action" == "show" ]]; then
    if [[ -f "$file" ]]; then
      cat "$file"
    else
      echo "cdpath config file empty or missing."
    fi
    return 0
  fi
  
  if [[ "$action" == "add" ]]; then
    if [[ -z "$dir" ]]; then
      echo "Usage: cdpath add <dir>"
      return 1
    fi
    
    local abs_dir
    if [[ -d "$dir" ]]; then
      abs_dir=$(realpath "$dir")
    else
      echo "Not a directory: $dir"
      return 1
    fi
    
    if [[ -f "$file" ]] && grep -qxF "$abs_dir" "$file"; then
      echo "Already in cdpath: $abs_dir"
      return 0
    fi
    
    echo "$abs_dir" >> "$file"
    echo "Added to cdpath: $abs_dir"
    
  elif [[ "$action" == "remove" ]]; then
    if [[ -z "$dir" ]]; then
      echo "Usage: cdpath remove <dir>"
      return 1
    fi
    
    local abs_dir
    if [[ -d "$dir" ]]; then
      abs_dir=$(realpath "$dir")
    else
      abs_dir="$dir"
    fi
    
    if [[ ! -f "$file" ]]; then
      echo "cdpath config file is empty"
      return 1
    fi
    
    if ! grep -qxF "$abs_dir" "$file"; then
      if ! grep -qxF "$dir" "$file"; then
        echo "Not found in cdpath config: $dir"
        return 1
      fi
      abs_dir="$dir"
    fi
    
    local temp=$(mktemp)
    grep -vFx "$abs_dir" "$file" > "$temp"
    mv "$temp" "$file"
    echo "Removed from cdpath: $abs_dir"
  else
    echo "Unknown action: $action"
    echo "Usage: cdpath [add|remove|show] [dir]"
    return 1
  fi
  
  # Re-load cdpath variable
  if [[ -f "$file" ]]; then
    cdpath=(. ~ ${(f)"$(grep -v '^\s*$' "$file" | grep -v '^\s*#')"})
  else
    cdpath=(. ~)
  fi
}
