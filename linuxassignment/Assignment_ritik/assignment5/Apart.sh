#!/bin/bash

set -x
template_file="$1"

if [ -f "$template_file" ]; then
    org_content=$(cat "$template_file")
    shift

    for arg in "$@"; do
        key=$(echo "$arg" | cut -d '=' -f 1)
        value=$(echo "$arg" | cut -d '=' -f 2)

        updated_content=$(echo "$org_content" | sed "0,/{{$key}}/s/{{$key}}/$value/")

        echo "$updated_content" > "$template_file"

        org_content="$updated_content"
    done
else
    echo "File doesn't exist in the: $(pwd) directory!"
fi
