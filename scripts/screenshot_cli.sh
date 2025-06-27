#!/bin/bash

# AppStore Screenshots CLI Launcher
# This script makes it easier to run the CLI tool

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Run the Dart CLI tool
cd "$PROJECT_DIR"
dart run bin/screenshot_cli.dart "$@"
