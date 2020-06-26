#!/bin/bash
set -e
composer --working-dir=$(echo $(pwd)/src) update --no-ansi --no-dev --no-interaction --no-progress --no-scripts --optimize-autoloader
npm install
grunt build_linux
