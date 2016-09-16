#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
pushd "$DIR">/dev/null

domain="http://hyperpolyglot.org"
httrack=$(locate.bat -f "$APPDATA\exe-index" "\\\\httrack.exe" | head -n 1)

if [ ! -d "_output" ]; then
   mkdir _output
   "$httrack" $domain --path "_output"
fi

popd >/dev/null
