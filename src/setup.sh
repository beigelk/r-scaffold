#!/bin/bash

# Check if jq is installed
if ! command -v jq >/dev/null 2>&1; then
    echo "Error: 'jq' is not installed. Please install it to use this script."
    exit 1
fi

# Parse config file from command-line arg
while getopts "c:" opt; do
  case $opt in
    c) config_file="$OPTARG" ;;
    *) echo "Usage: $0 -c <config_file>"; exit 1 ;;
  esac
done

# Check if config file is provided and exists
if [[ -z "$config_file" || ! -f "$config_file" ]]; then
    echo "Error: Config file not provided or doesn't exist."
    echo "Usage: $0 -c <config_file>"
    exit 1
fi

# Read values from JSON config
project=$(jq -r '.project // empty' "$config_file")
framework=$(jq -r '.framework // empty' "$config_file")
destination=$(jq -r '.destination // empty' "$config_file")
git_add_origin=$(jq -r '.git_add_origin // empty' "$config_file")
gh_username=$(jq -r '.gh_username // empty' "$config_file")

# Validate required fields
if [[ -z "$project" || -z "$framework" || -z "$destination" ]]; then
    echo "Error: Missing required fields in config file."
    echo "Make sure 'project', 'framework', and 'destination' are set."
    exit 1
fi

# Display options
echo "== Project Setup =="
echo "Project: $project"
echo "Framework: $framework"
echo "Destination: $destination"
echo ""

# Set up the project directory
project_path="${destination}/${project}"

if [ -d "$project_path" ]; then
  echo "Directory already exists: $project_path"
else
  mkdir -p "$project_path"
  echo "Created project directory: $project_path"
fi

# Construct full path for where to copy config
proj_config="${project_path}/.proj_config/config.json"

echo "DEBUG: Project config path: $proj_config"

# Sanity check: Make sure the variable is not empty
if [[ -z "$proj_config" ]]; then
  echo "ERROR: proj_config path is empty!"
  exit 1
fi

# Check if the config file already exists at the project_path
if [ ! -f "$proj_config" ]; then
    echo "DEBUG: $proj_config does not exist. Proceeding to copy."

    if [ -f "$config_file" ]; then
        echo "DEBUG: Source config file found: $config_file"

        # Create the project_path directory if it doesn't exist
        mkdir -p "${project_path}/.proj_config"
        if [[ $? -ne 0 ]]; then
            echo "ERROR: Failed to create directory: ${project_path}/.proj_config"
            exit 1
        fi

        # Copy the file
        cp "$config_file" "$proj_config"
        if [[ $? -eq 0 ]]; then
            echo "✔ Copied project config file to $proj_config"
        else
            echo "ERROR: Failed to copy config file."
            exit 1
        fi
    else
        echo "ERROR: Source config file does not exist: $config_file"
        exit 1
    fi
else
    echo "Project config file already exists: $proj_config"
fi


# Framework-specific setup
case "$framework" in
  basic)
    echo "Setting up basic R project structure."

    dirs=(
      "${project_path}/data"
      "${project_path}/R"
    )

    for dir_path in "${dirs[@]}"; do
      if [ -d "$dir_path" ]; then
        echo "  - Exists: $dir_path"
      else
        mkdir -p "$dir_path"
        echo "  - Created: $dir_path"
      fi
    done

    readme="${project_path}/README.md"
    if [ ! -f "$readme" ]; then
      echo "# $project" > "$readme"
      echo "  - Created README.md"
    else
      echo "  - README.md already exists"
    fi

    r_dirbase="content/basic"
    items=(
        "R/"
    )

    for item in "${items[@]}"; do
        src_path="${r_dirbase}/${item}"
        dest_path="${project_path}/${item}"
        parent_dir="$(dirname "$dest_path")"

        if [ -e "$src_path" ]; then
            # Create parent directory if needed
            mkdir -p "$parent_dir"
            if [[ $? -ne 0 ]]; then
                echo "  - Error: Failed to create directory $parent_dir"
            continue
            fi

            # Copy the file or directory
            cp -r "$src_path"/. "$dest_path"/
            if [[ $? -eq 0 ]]; then
                echo "  - Copied: $src_path -> $dest_path"
            else
                echo "  - Error: Failed to copy $src_path"
            fi
        else
            echo "  - Warning: Source $src_path does not exist"
        fi
    done
    
    ;;

    *)
    echo "Warning: Framework '$framework' is not recognized. No specific setup done."
    ;;
esac

if [ -d "$project_path/.git" ]; then
    echo "Git repository already initialized in $project_path"
else
    echo "Initializing Git repository in $project_path"
    git init "$project_path"
    cp content/basic/.gitignore "$project_path/.gitignore"
    cd "$project_path" || exit 1
    git add .
    git commit -m "Initial commit."
    echo "Git repository initialized and initial commit created."
fi

if [ $git_add_origin == "y" ]; then
    # Example values — replace or extract from config
    project_name="$project"
    remote_name="origin"

    # Construct GitHub SSH URL
    repo_url="git@github.com:${gh_username}/${project_name}.git"

    # Navigate to the project directory
    cd "$project_path" || {
    echo "Error: Could not cd into $project_path"
    exit 1
    }

    # Check if it's already a git repo
    if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init
    git add .
    git commit -m "Initial commit."
    fi

    # Add remote if it doesn't exist
    if git remote get-url "$remote_name" >/dev/null 2>&1; then
        echo "Git remote '$remote_name' already exists: $(git remote get-url "$remote_name")"
        echo "Current remotes:"
        git remote -v
        echo "==== Create a new repository on GitHub called $project_name, then push. ===="
    else
        git remote add "$remote_name" "$repo_url"
        if [[ $? -eq 0 ]]; then
            echo "Remote '$remote_name' added: $repo_url"
            echo "Current remotes:"
            git remote -v
            echo "==== Create a new repository on GitHub called $project_name, then push. ===="
        else
            echo "Error: Failed to add remote."
            echo "Current remotes:"
            exit 1
        fi
    fi
fi
