#! /bin/bash
# Reduce nested commands and jobs to files under src/commands or src/jobs so they can be packed by 'circleci orb pack src/'.

# Directory under which prepack directories reside.
SRC="${1:-src}"

# The subdirectory to prepack.
TYP="${2:-commands}"

cd "$SRC/$TYP/" || exit 1

for directory in *; do
    for f in "${directory}"/*; do
        if [ ! -f "${directory}-${f}" ]; then
            cp "${directory}/${f}" "${directory}-${f}"
        fi
    done
done

cd - || exit 1
