#!/bin/bash
#
# enfuse_stack.sh <file1>...<fileN> 
#
# Enfuse your stack, keeping some semblance of sequence information
# in the file names.
#
# Editors note: if you have a *lot* of frames, enfuse is single threaded,
# so you should invoke it like this: `ls -1 *.tif | xargs -n3 -P$(grep -c ^processor /proc/cpuinfo) enfuse_stack.sh`
if [[ "$1" == "" ]]; then
    echo "Please pass in the filenames of the photos you want to enfuse."
    exit 1
fi

# this is the prefix (including slash) to pass to enfuse
OUTDIR="${PWD}/enfused"
mkdir -p "${OUTDIR}"

# Trim off the directory portion
OUTFILE=$(basename ${1})

# Enfuse! Use the filename of the first file in the input list as the
# output, to keep sequence information.
enfuse -o "${OUTDIR}/${OUTFILE}" ${@}
