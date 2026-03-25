#!/bin/bash
set -ex
IMAGE_TEMP_DIR="./temp"

mkdir -p ${IMAGE_TEMP_DIR}
rm -f ./package/package.yaml
rm -rf ${IMAGE_TEMP_DIR}
cp -R ./package ${IMAGE_TEMP_DIR}
find ${IMAGE_TEMP_DIR}/ -type f -name '*.yaml' -exec cat {} >> "package/package.yaml" \; -exec printf '\n---\n' \;
