#!/bin/bash

STATUS_FILES=$(ls $HOME/.venvs/)
PYTHON_ENV=$(gum choose --header "Choose a Python Environment" $STATUS_FILES)

source "$HOME/.venvs/$PYTHON_ENV/bin/activate"
