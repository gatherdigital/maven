#!/bin/bash

BUILD_DIR=$PWD
PROJECT_DIR=$1

# Build artifacts
cd $PROJECT_DIR
./gradlew -Dorg.gradle.project.repoDir="$BUILD_DIR" uploadArchives

# Create pretty directory listing
cd $BUILD_DIR
for DIR in $(find ./ \( -name build -o -name .git \) -prune -o -type d); do
  (
    echo "<html><body><h1>Directory listing</h1><hr/><pre>"
    ls -1p "${DIR}" | grep -v "^\./$" | grep -v "build-" | grep -v "index.html" | awk '{ printf "<a href=\"%s\">%s</a>\n",$1,$1 }'
    echo "</pre></body></html>"
  ) > "${DIR}/index.html"
done

# Stage all files in git and create a commit
git add --all .
git commit -m "Built $(basename $PROJECT_DIR) on $(date)"
