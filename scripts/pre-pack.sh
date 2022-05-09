#! /bin/bash
# Reduce nested commands and jobs to files under src/commands or src/jobs so they can be packed by 'circleci orb pack src/'.
# Allows you to group collections of commands under directories.

# Directory under which prepack directories reside.
SRC="${1:-src}"

# The subdirectory to prepack.
TYP="${2:-commands}"

cd "$SRC/$TYP/" || exit 1

for directory in *; do
    if [ -d "${directory}" ] && [ -n "$(ls -A "${directory}")" ]; then
        for f in "${directory}"/*; do
            fname="$(basename "$f")"
            if [ ! -f "${directory}-${fname}" ]; then
                cp "${f}" "${directory}-${fname}"
            fi
        done
    else
        printf "INFO: Ignoring '%s', module is empty.\\n" "${SRC}/${TYP}/${directory}"
    fi
done

cd - || exit 1
