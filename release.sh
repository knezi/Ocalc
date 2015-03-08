#!/bin/env sh
rm release/* -rf
cp index.html release/
cp style.css release/
cp computer_modern.ttf release/
cp latin.otf release/
cp manifest.webapp release/

mkdir release/lib
cp lib/hammer-2.0.2.js release/lib
cp lib/jquery.hammer.js release/lib
cp lib/jquery-2.0.3.min.js release/lib
cp lib/public.js release/lib

cp *.png release/
