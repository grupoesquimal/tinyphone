#!/bin/bash
set -e

docker build -f Dockerfile.build  -t tinyphone  .
#docker run -m 2G tinyphone:latest "C:\Build\release.ps1"
cat release.ps1 | docker run -i tinyphone

docker cp $(docker ps -a --last 1 -q):"C:\Code\tinyphone\tinyphone-installer\bin\Release\tinyphone_installer.msi" "tinyphone_installer.$(date +%s).msi"

docker rmi $(docker ps -a --last 1 -q)
