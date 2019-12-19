#!/bin/sh

tests=(./tests/*.py)

for ((i=0; i<${#tests[@]}; i++)); do
    python "${tests[$i]}"
done