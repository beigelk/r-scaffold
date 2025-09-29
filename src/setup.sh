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
