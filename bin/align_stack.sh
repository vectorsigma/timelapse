#!/bin/bash
#
# Align your stack, with sane naming conventions.  I abuse tmpnam
# here for fun and profit, to get around align_image_stack's inability
# to write files with more than one process at once without clobbering
# all over the output files.
if [[ "$1" == "" ]]; then
    echo "Please pass in the filenames of the photos you want to align."
    exit 1
fi

# Total # of files to handle
NUMFILES=${#@}

# Make a copy of the input files
declare -a INFILES=(${@})

# Create a temporary directory to output all of your stuff.
TEMPDIR=$(mktemp -d)

# this is the prefix (including slash) to pass to align_image_stack
PREFIX="${TEMPDIR}/wut"

# Run the alignment.
align_image_stack -a "$PREFIX" ${@}

# align_image_stack orders the files it produced based on the input file order.
# so some semblance of sequence remains.  Now we just rename it from its temp
# location to the aligned subdirectory with its original filenames, and we should
# be G2G.  Just be sure to create the destination directory first.
mkdir -p "$PWD/aligned"
for ((I=0; I < $NUMFILES; I++)); do
		BASE="$(basename ${INFILES[$I]})"
		mv -v "${PREFIX}000${I}.tif" "$PWD/aligned/${BASE}"
done
rmdir $TEMPDIR
