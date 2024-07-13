#!/usr/bin/env bash

scriptDir=$(dirname "$0")
java -Xmx512M -jar "$scriptDir/../freecelljsolver.jar" "$@"
