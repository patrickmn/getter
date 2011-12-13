#!/bin/sh
# Getter -- User-friendly retrieval and extraction of archives using a curl oneliner
# Version 1.0 -- December 13th, 2011
# http://patrickmylund.com/projects/getter/
#
# Example usage:
#   curl http://patrickmylund.com/files/tools/getter/getter.sh | sh -s http://example.com/myarchive.tar.gz

set -u # Exit on attempt to use uninitialized variable
set -e # Exit if any command exits with non-zero return value

url=$1
get=0 # Download the file first; don't pipe it

case $url in
    *.tar.gz|*.tgz) cmd="tar xvz";;
    *.tar.bz2) cmd="tar xvj";;
    *.zip) get=1; cmd="unzip";;
    *.rar) get=1; cmd="unrar";;
esac

if [ $get -eq 0 ]; then
    curl -s $url | $cmd
else
    tmpdir=/tmp/getter-$(date +%s)
    mkdir $tmpdir
    curl -s $url > $tmpdir/archive
    $cmd $tmpdir/archive
    rm -f $tmpdir/archive
    rmdir $tmpdir
fi
