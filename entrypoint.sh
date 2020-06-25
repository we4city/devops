#!/bin/sh

#test
ls
date
echo $(cat VERSION)
chmod 0777 ./tests/scripts/validate_version.sh
./tests/scripts/validate_version.sh

#Build Code
npm version
grunt --version
npm update -f
date
uname -a
pwd
composer --working-dir=$(echo $(pwd)/src) update --no-ansi --no-dev --no-interaction --no-progress --no-scripts --optimize-autoloader
grunt build_linux
echo $(cat VERSION)
