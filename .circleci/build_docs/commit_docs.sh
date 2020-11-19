#!/usr/bin/env bash

set -ex


if [ "$2" == "" ]; then
    echo call as $0 "<src>" "<target branch>"
    echo where src is the built documentation and
    echo branch should be "master" or "1.7" or so
    exit 1
fi

src=$1
target=$2

set -ex
echo "committing docs from ${src} to ${target}"

git checkout gh-pages
mkdir -p ./$target
rm -rf ./$target/*
cp -r ${src}/build/html/* ./$target
if [ "$target" == "master" ]; then
    mkdir -p ./_static
    rm -rf ./_static/*
    cp -r ${src}/build/html/_static/* ./_static
    git add --all ./_static || true
fi
git add --all ./$target || true
git config user.email "soumith+bot@pytorch.org"
git config user.name "pytorchbot"
# If there aren't changes, don't make a commit; push is no-op
git commit -m "auto-generating sphinx docs" || true
git push -u origin gh-pages


