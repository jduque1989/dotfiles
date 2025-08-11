# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                                     🚀 Functions Module                                        ┃
# ┃                               Interactive Shell Functions                                       ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# FZF-POWERED FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# Fuzzy find and edit files
vf() {
    local file
    if command -v fzf >/dev/null 2>&1; then
        file=$(find . -type f -not -path '*/\.git/*' 2>/dev/null | fzf --preview 'bat --color=always --style=numbers {}' --height 60% --border)
        if [[ -n $file ]]; then
            nvim "$file"
        fi
    else
        echo "fzf not found. Please install fzf for fuzzy finding."
        return 1
    fi
}

# Fuzzy find and cd to directories
cf() {
    local dir
    if command -v fzf >/dev/null 2>&1; then
        dir=$(find . -type d -not -path '*/\.git/*' 2>/dev/null | fzf --height 40% --border)
        if [[ -n $dir ]]; then
            cd "$dir"
        fi
    else
        echo "fzf not found. Please install fzf for fuzzy finding."
        return 1
    fi
}

# Fuzzy search command history
fh() {
    if command -v fzf >/dev/null 2>&1; then
        eval $(fc -ln 1 | fzf --tac --no-sort)
    else
        echo "fzf not found. Please install fzf for fuzzy searching."
        return 1
    fi
}

# Fuzzy git checkout branches
fgb() {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Not in a git repository"
        return 1
    fi
    
    if command -v fzf >/dev/null 2>&1; then
        local branch
        branch=$(git branch -a | grep -v HEAD | sed 's/^..//' | sed 's/remotes\///' | sort -u | fzf --height 40% --border)
        if [[ -n $branch ]]; then
            git checkout "$branch"
        fi
    else
        echo "fzf not found. Please install fzf for fuzzy searching."
        return 1
    fi
}

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# SYSTEM INFORMATION FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# System info overview (check if show_system_info exists first)
sysinfo() {
    if typeset -f show_system_info > /dev/null; then
        show_system_info
    else
        echo "System info functions not loaded properly"
    fi
}

# Short system info
si() {
    sysinfo
}

# Weather function
weather() {
    local city=${1:-""}
    if [[ -n $city ]]; then
        curl -s "wttr.in/$city?format=3"
    else
        curl -s "wttr.in?format=3"
    fi
}

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# DEVELOPMENT FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# Create a new project directory with git init
newproject() {
    local project_name=$1
    if [[ -z $project_name ]]; then
        echo "Usage: newproject <project_name>"
        return 1
    fi
    
    mkdir -p "$project_name"
    cd "$project_name"
    git init
    echo "# $project_name" > README.md
    echo "Created new project: $project_name"
}

# Quick server for current directory
serve() {
    local port=${1:-8000}
    echo "Serving current directory at http://localhost:$port"
    if command -v python3 >/dev/null 2>&1; then
        python3 -m http.server "$port"
    elif command -v python >/dev/null 2>&1; then
        python -m SimpleHTTPServer "$port"
    else
        echo "Python not found. Cannot start server."
        return 1
    fi
}

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# FILE MANAGEMENT FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# Find large files in current directory
findlarge() {
    local size=${1:-100M}
    find . -type f -size +"$size" -exec ls -lh {} \; | awk '{ print $NF ": " $5 }' | sort -k 2 -hr
}

# Count files in directories
countfiles() {
    find . -maxdepth 1 -type d -exec sh -c 'echo "{}: $(find "{}" -type f | wc -l | tr -d " ")"' \;
}

# Create backup of a file
backup() {
    local file=$1
    if [[ -z $file ]]; then
        echo "Usage: backup <filename>"
        return 1
    fi
    
    if [[ -f $file ]]; then
        cp "$file" "$file.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backup created: $file.backup.$(date +%Y%m%d_%H%M%S)"
    else
        echo "File not found: $file"
        return 1
    fi
}

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# NETWORK FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# Check if a website is up
isup() {
    local url=$1
    if [[ -z $url ]]; then
        echo "Usage: isup <website>"
        return 1
    fi
    
    if curl -s --head "$url" | head -n 1 | grep -q "200 OK"; then
        echo "$url is up"
    else
        echo "$url is down"
    fi
}

# Speed test using speedtest-cli
speedtest() {
    if command -v speedtest-cli >/dev/null 2>&1; then
        speedtest-cli
    else
        echo "speedtest-cli not found. Install with: pip install speedtest-cli"
        return 1
    fi
}

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# UTILITY FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# Generate a random password
genpass() {
    local length=${1:-16}
    if command -v openssl >/dev/null 2>&1; then
        openssl rand -base64 $((length * 3 / 4)) | cut -c1-$length
    else
        echo "OpenSSL not found"
        return 1
    fi
}

# Convert timestamp to human readable date
timestamp() {
    local ts=$1
    if [[ -z $ts ]]; then
        echo "Usage: timestamp <unix_timestamp>"
        return 1
    fi
    
    date -r "$ts"
}

# Get file encoding
encoding() {
    local file=$1
    if [[ -z $file ]]; then
        echo "Usage: encoding <filename>"
        return 1
    fi
    
    file -I "$file"
}