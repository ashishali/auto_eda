#!/bin/bash

# PyPI Upload Script for Auto EDA
# This script automates the process of building and uploading to PyPI

set -e  # Exit on error

echo "=========================================="
echo "Auto EDA - PyPI Upload Script"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "setup.py" ]; then
    echo -e "${RED}Error: setup.py not found. Please run this script from the package root directory.${NC}"
    exit 1
fi

# Step 1: Clean previous builds
echo -e "${YELLOW}Step 1: Cleaning previous builds...${NC}"
rm -rf dist/ build/ *.egg-info
echo -e "${GREEN}✓ Cleaned${NC}"
echo ""

# Step 2: Check if build tools are installed
echo -e "${YELLOW}Step 2: Checking build tools...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python not found${NC}"
    exit 1
fi

python3 -m pip install --upgrade --quiet build twine
echo -e "${GREEN}✓ Build tools ready${NC}"
echo ""

# Step 3: Build package
echo -e "${YELLOW}Step 3: Building package...${NC}"
python3 -m build
echo -e "${GREEN}✓ Build complete${NC}"
echo ""

# Step 4: Check package
echo -e "${YELLOW}Step 4: Checking package...${NC}"
python3 -m twine check dist/*
echo -e "${GREEN}✓ Package check passed${NC}"
echo ""

# Step 5: Ask where to upload
echo -e "${YELLOW}Where would you like to upload?${NC}"
echo "1) TestPyPI (recommended for first upload)"
echo "2) PyPI (production)"
read -p "Enter choice (1 or 2): " choice

if [ "$choice" = "1" ]; then
    echo ""
    echo -e "${YELLOW}Uploading to TestPyPI...${NC}"
    python3 -m twine upload --repository testpypi dist/* --verbose
    echo ""
    echo -e "${GREEN}✓ Uploaded to TestPyPI!${NC}"
    echo ""
    echo "To test installation, run:"
    echo "pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ eda-kit"
elif [ "$choice" = "2" ]; then
    echo ""
    echo -e "${YELLOW}Uploading to PyPI...${NC}"
    echo -e "${RED}Warning: This will upload to production PyPI!${NC}"
    read -p "Are you sure? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
        python3 -m twine upload dist/*
        echo ""
        echo -e "${GREEN}✓ Uploaded to PyPI!${NC}"
        echo ""
        echo "To install, run:"
        echo "pip install eda-kit"
    else
        echo "Upload cancelled."
    fi
else
    echo -e "${RED}Invalid choice${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}=========================================="
echo "Upload Complete!"
echo "==========================================${NC}"

