#!/bin/bash

# Move into parent folder
cd ..

# Clone the repositories
git clone git@github.com:Kolawole99/nextjs-template.git
git clone git@github.com:Kolawole99/react-template.git
git clone git@github.com:Kolawole99/js-backend.git

# Install dependencies. Iterate through all folders in the current directory
for folder in */; do
    # Remove trailing slash to get the folder name
    folder_name=$(basename "$folder")

    # Skip the "project" folder
    if [ "$folder_name" == "project" ]; then
        continue
    fi

    # Check if package.json exists in the folder
    if [ -f "$folder/package.json" ]; then
        # Read package.json and look for indicators to determine the runtime
        if grep -q "pnpm" "$folder/package.json"; then
            echo "Node with pnpm detected"
            echo "Installing dependencies for $folder_name using pnpm configure..."
            (cd "$folder" && pnpm configure)
        elif grep -q "bun" "$folder/package.json"; then
            echo "Bun detected"
            echo "Installing dependencies for $folder_name using bun install..."
            (cd "$folder" && bun install)
        fi
    fi

    # Check if go.mod exists in the folder
    if [ -f "$folder/go.mod" ]; then
        echo "Installing dependencies for $folder_name using go install..."
        (cd "$folder" && go install)
    fi
done

# Move into the project subdirectory
cd project

# Open the project in VS Code
code templates.code-workspace
