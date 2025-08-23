#!/bin/sh
if [ -z "$KILLING_FLOOR_SYSTEM" ] || [ ! -d "$KILLING_FLOOR_SYSTEM" ]; then
    echo "KILLING_FLOOR_SYSTEM undefined or invalid directory."
    read -p "Killing Floor System path: " KILLING_FLOOR_SYSTEM

    if [ ! -d "$KILLING_FLOOR_SYSTEM" ]; then
        mkdir -p "$KILLING_FLOOR_SYSTEM"
    fi
fi

PROJECT_DIRECTORY=$(pwd)

rm -rf "$KILLING_FLOOR_SYSTEM/../PlayToEarnMutator"
cp -r ./PlayToEarnMutator "$KILLING_FLOOR_SYSTEM/../PlayToEarnMutator"
cp -r ./PlayToEarnMutator/Configs/* "$KILLING_FLOOR_SYSTEM"

cd "$KILLING_FLOOR_SYSTEM"
rm -rf ./PlayToEarnMutator.u
rm -rf ./PlayToEarnMutator.ucl
rm -rf ./RegisterTCP.u
rm -rf ./RegisterTCP.ucl

if [ "$(uname -s)" = "Linux" ]; then
    echo "Running linux script..."
    # If you are a linux user use a wine script to compile for you
    ./compile.sh
elif [[ "$(uname -s)" == MINGW* || "$(uname -s)" == CYGWIN* ]]; then
    echo "Running UCC.exe make..."
    ./UCC.exe make
else
    echo "System not supported: $(uname -s)"
    exit 1
fi

mkdir -p "$PROJECT_DIRECTORY/Release"
cp -r ./PlayToEarnMutator.u "$PROJECT_DIRECTORY/Release"
cp -r ./PlayToEarnMutator.ucl "$PROJECT_DIRECTORY/Release"
cp -r ./PlayToEarnMutator.ini "$PROJECT_DIRECTORY/Release"