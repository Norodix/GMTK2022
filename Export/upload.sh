#!/bin/bash

NAME="DiceDash"
LINK="dice-dash"

cd "${0%/*}" #must change to own directory for bash
cp "./DiceDash_HTML5/DiceDash.html" "./DiceDash_HTML5/index.html"
make
butler push "DiceDash_HTML5"        "Norodix/dice-dash:html"
butler push "DiceDash_Windows.zip"  "Norodix/dice-dash:windows"
butler push "DiceDash_Linux.zip"    "Norodix/dice-dash:linux"
