#!/bin/bash

hadolint_version="2.12.0"

owner=$(stat -c '%U' "$HOME/.pre-commit")

if [[ "$owner" == "root" ]]
then
  sudo chown vscode:vscode "$HOME/.pre-commit"
  pre-commit install
  pre-commit install-hooks
  terrascan init
  if [[ $(hadolint --version | grep -oP '^Haskell Dockerfile Linter \K(\d+\.\d+\.\d+)$') == "$hadolint_version" ]]
  then
    echo "Required version installed"
  else
    echo "Required version not installed"
    sudo wget -O /bin/hadolint "https://github.com/hadolint/hadolint/releases/download/v$hadolint_version/hadolint-Linux-x86_64"
    sudo chmod +x /bin/hadolint
  fi
  pip install -r src/app/requirements.txt
fi
