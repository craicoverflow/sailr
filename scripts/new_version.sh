#!/bin/sh

find $PWD -type f \( ! -iname "new_version.sh" \) | xargs sed -i -e "s|master|$1|g" *.*