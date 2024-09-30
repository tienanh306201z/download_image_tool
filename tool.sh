#!/bin/bash

# Make the script executable
chmod +x ./tool.sh

# Check and install wget if not installed
if ! command -v wget &> /dev/null; then
    echo "wget is not installed. Installing..."
    # Install wget. Use brew for Mac, apt-get for Linux.
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install wget
    else
        sudo apt-get install wget -y
    fi
fi

# Check and install jq if not installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Installing..."
    # Install jq. Use brew for Mac, apt-get for Linux.
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install jq
    else
        sudo apt-get install jq -y
    fi
fi

# Define the directory to save downloaded images
download_directory="/Users/user/Downloads/download_image_tool"

# Create the directory if it doesn't exist
mkdir -p "$download_directory"

# Read the JSON file and extract all values, handling both strings and arrays/objects
values=$(jq -r '.[] | if type=="array" or type=="object" then .[] else . end' images.json)

# Download the images or files
for value in $values; do
    wget -P "$download_directory" "$value"
done

# Remove all files ending with .svg.1 in the download directory
find "$download_directory" -type f -name "*.svg.1" -exec rm {} +
find "$download_directory" -type f -name "*.png.1" -exec rm {} +

echo "Download completed."