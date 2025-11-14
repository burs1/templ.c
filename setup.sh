#!/bin/bash

#=============================================================================
# PROJECT SETUP SCRIPT
#=============================================================================
# This script downloads the C library template and replaces all "mylib"
# references with a specified project name. It handles various case variations
# and maintains the project structure.
#=============================================================================

#=============================================================================
# CONFIGURATION
#=============================================================================
# Repository URL to clone from
REPO_URL="https://github.com/burs1/templ.c.git"
#=============================================================================

set -e  # Exit on any error

# Colors for output (matching uv help style)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;36m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}info |${NC} $1"
}

print_success() {
    echo -e "${GREEN}success |${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}warning |${NC} $1"
}

print_error() {
    echo -e "${RED}error |${NC} $1"
}

# Function to show usage
show_usage() {
    echo -e "C Library template project setup script."
    echo ""
    echo -e "${BOLD}${GREEN}Usage:${NC} $0 <project_name> [full_project_name] [target_directory]"
    echo ""
    echo -e "${BOLD}${GREEN}Arguments:${NC}"
    echo -e "  ${BLUE}<project_name>${NC}        The name for your new project (will replace 'mylib')"
    echo -e "  ${BLUE}[full_project_name]${NC}   Optional full project name for titles/descriptions (default: same as project_name)"
    echo -e "  ${BLUE}[target_directory]${NC}    Optional target directory (default: current directory)"
    echo ""
    echo -e "${BOLD}${GREEN}Examples:${NC}"
    echo -e "  ${BLUE}$0 mylogger${NC}                                    # Creates 'mylogger' project"
    echo -e "  ${BLUE}$0 mylogger \"My Logger Library\"${NC}              # Creates 'mylogger' with full name"
    echo -e "  ${BLUE}$0 mylogger \"My Logger Library\" /path/to/projects${NC}  # With custom directory"
}

# Check if help is requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_usage
    exit 0
fi

# Check arguments
if [[ $# -lt 1 ]]; then
    print_error "Missing required argument: project_name"
    echo ""
    show_usage
    exit 1
fi

PROJECT_NAME="$1"
FULL_PROJECT_NAME="${2:-$PROJECT_NAME}"
TARGET_DIR="${3:-.}"

# Validate project name (basic validation)
if [[ ! "$PROJECT_NAME" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
    print_error "Invalid project name: '$PROJECT_NAME'"
    print_error "Project name must start with a letter and contain only letters, numbers, and underscores"
    exit 1
fi

# Repository URL is defined in the CONFIGURATION section at the top of this file

print_info "Setting up new project: '$PROJECT_NAME'"
print_info "Full project name: '$FULL_PROJECT_NAME'"
print_info "Repository URL: $REPO_URL"
print_info "Target directory: $TARGET_DIR"

# Create target directory if it doesn't exist
if [[ ! -d "$TARGET_DIR" ]]; then
    print_info "Creating target directory: $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# Determine the final project directory
if [[ "$TARGET_DIR" == "." ]]; then
    PROJECT_DIR="./$PROJECT_NAME"
else
    PROJECT_DIR="$TARGET_DIR/$PROJECT_NAME"
fi

# Check if project directory already exists
if [[ -d "$PROJECT_DIR" ]]; then
    print_error "Directory '$PROJECT_DIR' already exists!"
    print_error "Please choose a different project name or target directory"
    exit 1
fi

# Clone the repository with submodules
print_info "Cloning repository with submodules..."
if ! git clone --recursive "$REPO_URL" "$PROJECT_DIR"; then
    print_error "Failed to clone repository from $REPO_URL"
    exit 1
fi

# Save submodule information before removing git metadata
print_info "Saving submodule information..."
SUBMODULE_PATHS=()
SUBMODULE_URLS=()
if [[ -f "$PROJECT_DIR/.gitmodules" ]]; then
    CURRENT_PATH=""
    while IFS= read -r line; do
        if [[ "$line" =~ ^[[:space:]]*path[[:space:]]*=[[:space:]]*(.*)$ ]]; then
            CURRENT_PATH="${BASH_REMATCH[1]}"
            SUBMODULE_PATHS+=("$CURRENT_PATH")
        elif [[ "$line" =~ ^[[:space:]]*url[[:space:]]*=[[:space:]]*(.*)$ ]] && [[ -n "$CURRENT_PATH" ]]; then
            SUBMODULE_URLS+=("${BASH_REMATCH[1]}")
            CURRENT_PATH=""
        fi
    done < "$PROJECT_DIR/.gitmodules"
fi

# Remove .git directory and submodule .git files/directories to start fresh
print_info "Removing git metadata..."
rm -rf "$PROJECT_DIR/.git"
find "$PROJECT_DIR" -name ".git" \( -type f -o -type d \) -exec rm -rf {} + 2>/dev/null || true

print_success "Repository cloned successfully"

# Function to replace strings in a file
replace_in_file() {
    local file="$1"
    local old_string="$2"
    local new_string="$3"
    
    if [[ -f "$file" ]]; then
        # Use sed with different delimiters to avoid issues with special characters
        sed -i.bak "s|$old_string|$new_string|g" "$file"
        rm -f "$file.bak"  # Remove backup file
    fi
}

# Function to replace case variations
replace_case_variations() {
    local file="$1"
    local project_name="$2"
    local full_project_name="$3"
    
    # Convert project name to different cases
    local PROJECT_NAME_UPPER=$(echo "$project_name" | tr '[:lower:]' '[:upper:]')
    local PROJECT_NAME_LOWER=$(echo "$project_name" | tr '[:upper:]' '[:lower:]')
    local PROJECT_NAME_CAPITALIZED=$(echo "$project_name" | sed 's/./\U&/')
    
    # Replace various case variations for mylib
    replace_in_file "$file" "mylib" "$PROJECT_NAME_LOWER"
    replace_in_file "$file" "MYLIB" "$PROJECT_NAME_UPPER"
    replace_in_file "$file" "MyLib" "$PROJECT_NAME_CAPITALIZED"
    
    # Replace full project name variations
    replace_in_file "$file" "My Library" "$full_project_name"
    replace_in_file "$file" "my library" "$(echo "$full_project_name" | tr '[:upper:]' '[:lower:]')"
    replace_in_file "$file" "MY LIBRARY" "$(echo "$full_project_name" | tr '[:lower:]' '[:upper:]')"
}

print_info "Replacing 'mylib' references with '$PROJECT_NAME'..."

# Function to automatically discover files to process
discover_files_to_process() {
    local files=()
    
    # Find all relevant files using find command
    while IFS= read -r -d '' file; do
        files+=("$file")
    done < <(find "$PROJECT_DIR" -type f \( \
        -name "*.c" -o \
        -name "*.cpp" -o \
        -name "*.h" -o \
        -name "*.hpp" -o \
        -name "CMakeLists.txt" -o \
        -name "CMakeInfo.txt" -o \
        -name "CMakeOptions.txt" -o \
        -name "README.md" -o \
        -name "Doxyfile" -o \
        -name "*.md" -o \
        -name "*.txt" -o \
        -name "*.cmake" \
    \) -not -path "*/build/*" -not -path "*/.git/*" -not -path "*/vendor/*" -print0)
    
    # Return the array
    printf '%s\n' "${files[@]}"
}

# Get list of files to process
print_info "Discovering files to process..."
FILES_TO_PROCESS=($(discover_files_to_process))

print_info "Found ${#FILES_TO_PROCESS[@]} files to process"

# Process each file
for file in "${FILES_TO_PROCESS[@]}"; do
    if [[ -f "$file" ]]; then
        print_info "Processing: $(basename "$file")"
        replace_case_variations "$file" "$PROJECT_NAME" "$FULL_PROJECT_NAME"
    else
        print_warning "File not found: $file"
    fi
done

# Rename include/mylib directory to include/<project_name>
if [[ -d "$PROJECT_DIR/include/mylib" ]]; then
    print_info "Renaming include/mylib/ to include/$PROJECT_NAME/..."
    mv "$PROJECT_DIR/include/mylib" "$PROJECT_DIR/include/$PROJECT_NAME"
    print_success "Directory renamed successfully"
    
    # Update include paths in source files
    print_info "Updating include paths from 'mylib/' to '$PROJECT_NAME/'..."
    while IFS= read -r -d '' file; do
        if [[ -f "$file" ]]; then
            sed -i.bak "s|mylib/|$PROJECT_NAME/|g" "$file"
            rm -f "$file.bak"
        fi
    done < <(find "$PROJECT_DIR" -type f \( -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.hpp" \) \
        -not -path "*/build/*" -not -path "*/.git/*" -not -path "*/vendor/*" -print0)
    print_success "Include paths updated successfully"
else
    print_warning "Directory include/mylib/ not found, skipping rename"
fi

# Initialize new git repository
print_info "Initializing new git repository..."
cd "$PROJECT_DIR"
rm ./setup.sh
git init

# Re-add submodules if they existed (before git add .)
if [[ ${#SUBMODULE_PATHS[@]} -gt 0 && ${#SUBMODULE_PATHS[@]} -eq ${#SUBMODULE_URLS[@]} ]]; then
    print_info "Re-initializing git submodules..."
    for i in "${!SUBMODULE_PATHS[@]}"; do
        path="${SUBMODULE_PATHS[$i]}"
        url="${SUBMODULE_URLS[$i]}"
        if [[ -n "$path" && -n "$url" ]]; then
            print_info "Adding submodule at $path"
            # Remove the directory if it exists (it will be re-added as submodule)
            if [[ -d "$path" ]]; then
                rm -rf "$path"
            fi
            # Add as submodule
            if git submodule add "$url" "$path" 2>/dev/null; then
                print_success "Submodule added: $path"
            else
                print_warning "Failed to add submodule at $path, it will be included as regular files"
            fi
        fi
    done
fi

# Add all files (submodules are already tracked separately)
git add .

print_success "Project setup completed successfully!"
print_success "New project created at: $PROJECT_DIR"
echo ""
print_info "Next steps:"
echo "  1. cd $PROJECT_DIR"
echo "  2. Review and customize the source files in src/"
echo "  3. Update the header files in include/"
echo "  4. Modify tests in tests/ to match your library functionality"
echo "  5. Update README.md with your project description"
echo "  6. Build your project: mkdir build && cd build && cmake .. && make"
echo ""
print_info "Happy coding! 🚀"
