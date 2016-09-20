#!/bin/sh
source /init.sh

BASE_URL=https://app.wercker.com
#OWNER=wercker
OWNER=$(echo "$1" | cut -d/ -f 1)
NAME=$(echo "$1" | cut -d/ -f 2)
#NAME=bash-template
FULL_URL="${BASE_URL}/api/v2/steps/${OWNER}/${NAME}/*"
TARBALL_URL=$(curl "${FULL_URL}" | jq -r '.tarballUrl')


# cd to the workspace
cd "$2" || exit

WORKING=working
rm -rf ${WORKING}
mkdir -p ${WORKING}/output ${WORKING}/cache ${WORKING}/report
WERCKER_ROOT=$(pwd)
WERCKER_SOURCE_DIR="${WERCKER_ROOT}"
WERCKER_OUTPUT_DIR="${WERCKER_ROOT}/${WORKING}/output"
WERCKER_REPORT_DIR="${WERCKER_ROOT}/${WORKING}/report"
WERCKER_CACHE_DIR="${WERCKER_ROOT}/${WORKING}/cache"

WERCKER="false"
WERCKER_STEP_ROOT="${WERCKER_ROOT}/${WORKING}"
WERCKER_STEP_NAME="${NAME}"
WERCKER_STEP_OWNER="${OWNER}"

cd "${WORKING}" || exit
curl -o step.tar "${TARBALL_URL}"
tar -xvf step.tar
cd ..
source "${WERCKER_ROOT}/${WORKING}/run.sh"
