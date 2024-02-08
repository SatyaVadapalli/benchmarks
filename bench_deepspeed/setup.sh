#!/bin/bash

################################################################################
# Script: setup.sh
# Description: Automates the setup of a virtual environment and installs project
# requirements.
################################################################################

set -euo pipefail

# Main script starts here.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/venv"

check_python() {
    if command -v python &> /dev/null; then
        PYTHON_CMD="python"
    elif command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
    else
        echo "Python is not installed."
        exit 1
    fi
}

check_python

# Initialize conda
eval "$(conda shell.bash hook)"

if [ ! -d "$VENV_DIR" ]; then

    # Create the Conda environment with Python 3.11
    conda create -y -p "$VENV_DIR" python=3.11

    # Activate the environment
    conda activate "$VENV_DIR"

    # Print message indicating activation
    echo "Conda environment '$VENV_DIR' with Python 3.11 has been created and activated."

    # Optional: Install additional packages if needed
    # conda install -y package1 package2 ...

    "$PYTHON_CMD" -m pip install --upgrade pip > /dev/null
    conda install -y mpi4py

    "$PYTHON_CMD" -m pip install -r "$SCRIPT_DIR/requirements.txt" --no-cache-dir > /dev/null
else
    # Activate the environment
    conda activate "$VENV_DIR"

    # Print message indicating activation
    echo "Conda environment '$VENV_DIR' with Python 3.11 has been created and activated."
fi
