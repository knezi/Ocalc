#!/bin/env sh
pushd /home/knezi/Documents/server/ffos/Ocalc
cake build

cat lib/element.js > lib/public.js
cat lib/init.js >> lib/public.js
cat lib/function.js >> lib/public.js
cat lib/operand.js >> lib/public.js
cat lib/variable.js >> lib/public.js
cat lib/constant.js >> lib/public.js
cat lib/number.js >> lib/public.js
cat lib/block.js >> lib/public.js
cat lib/brackets.js >> lib/public.js
cat lib/root.js >> lib/public.js

cat lib/cursor.js >> lib/public.js
cat lib/formula.js >> lib/public.js
cat lib/result.js >> lib/public.js
cat lib/js.js >> lib/public.js
popd
