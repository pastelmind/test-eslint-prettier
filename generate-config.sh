#!/bin/bash
for cfg in *.eslintrc.*
do
    npx eslint --no-eslintrc --config=$cfg --print-config=dummy.js \
        > config-${cfg%.*.*}.json
done
