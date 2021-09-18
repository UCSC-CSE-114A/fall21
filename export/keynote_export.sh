#!/usr/bin/env bash
PACKAGE=$(basename $0)
DIR=$(dirname $0)
VERSION="0.0.0.9001"

set -x

absolute_path () {
  if [[ "$1" = /* ]]; then
    echo ${1%/}
  else
    echo $(pwd)/${1%/}
  fi
}

echo_help () {
  echo "$PACKAGE - Export Keynote file to PDF/JPEG"
  echo " "
  echo "$PACKAGE [options] keynote_dir"
  echo "options:"
  echo "-h, --help                show brief help"
  echo "-o, --output-dir=DIR      Output directory."
  echo "-t, --type                pdf or jpeg"
}

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo_help
      exit 0;;
    -o|--output-dir*)
      shift
      OUTPUTDIR=$(absolute_path $1)
      shift;;
    -t|--type*)
      shift
      TYPE=$1
      shift;;
    *)
      if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
        param+=( "$1" )
      fi
      shift;;
  esac
done

INPUTKEY=$(absolute_path ${param[0]})
INPUTDIR=$(dirname ${INPUTKEY})
if [[ -z "$INPUTDIR" ]]; then
  echo "Input directory is not specified."
  exit 1
fi

[[ -z "$OUTPUTDIR" ]] && OUTPUTDIR="$INPUTDIR"
[[ -z "$TYPE" ]] && TYPE="pdf"

# The main loop
# Call an applescript to do the conversion.
BASE=$(basename "${INPUTKEY}")
OUTFILE=$OUTPUTDIR/${BASE%.*}.$TYPE
HANDOUTFILE=$OUTPUTDIR/${BASE%.*}-handout.$TYPE
osascript $DIR/keynote_export.applescript "${INPUTKEY}" "$OUTFILE" "$HANDOUTFILE"

exit 0
