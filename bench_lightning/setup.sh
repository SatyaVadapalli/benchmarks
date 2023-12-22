#!/bin/bash

################################################################################
# Script: setup.sh <DEVICE>
# Description: Automates the setup of a virtual environment and installs project
# requirements.
################################################################################


setup_environment() {
    if [ ! -d "$VENV_DIR" ]; then
        python -m venv "$VENV_DIR"
        echo "Virtual environment '$VENV_DIR' created."
        # shellcheck disable=SC1091
        source "$VENV_DIR/bin/activate"
        pip install --upgrade pip > /dev/null

        # clone the repo
        if [ -d "$SCRIPT_DIR/lit-gpt" ]; then
            echo "lit-gpt folder already exists."
        else
            git clone https://github.com/Lightning-AI/lit-gpt.git "$SCRIPT_DIR/lit-gpt"
        fi

        # install everything
        pip install -r "$SCRIPT_DIR/lit-gpt/requirements-all.txt"
        pip install -e "$SCRIPT_DIR/lit-gpt"
        echo "Successfully installed lit-gpt and it's dependencies"
    else
        # shellcheck disable=SC1091
        source "$VENV_DIR/bin/activate"
    fi
}

convert_hf_to_litgpt() {
    local HF_WEIGHTS_FOLDER="$1"
    local LITGPT_WEIGHTS_FOLDER="$2"

    if [ -d "$LIT_GPT_MODELS_DIR" ]; then
        echo "Already converted"
    else
        if [ -d "$SCRIPT_DIR/lit-gpt" ]; then
            mkdir "$LITGPT_WEIGHTS_FOLDER"
            python "$SCRIPT_DIR/convert.py" --checkpoint_dir "$HF_WEIGHTS_FOLDER"
            mv "$HF_WEIGHTS_FOLDER/lit_config.json" "$HF_WEIGHTS_FOLDER/lit_model.pth" "$LITGPT_WEIGHTS_FOLDER"
        else
            echo "Please install the repo first and then go for conversion"
            exit 1
        fi
    fi
}


CURRENT_DIR="$(pwd)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

VENV_DIR="$SCRIPT_DIR/venv"
HF_MODELS_DIR="${HF_MODELS_DIR:-"models/llama-2-7b-hf"}"
LIT_GPT_MODELS_DIR="${LIT_GPT_MODELS_DIR:-"models/llama-2-7b-lit-gpt"}"

setup_environment
convert_hf_to_litgpt "$CURRENT_DIR/$HF_MODELS_DIR" "$CURRENT_DIR/$LIT_GPT_MODELS_DIR"
