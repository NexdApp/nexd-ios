#!/bin/bash

HOST="https://api.nexd.app/api/v1"

if [ -n "$1" ]
then
  HOST="$1"
fi

pushd Nexd
echo "Updating Swagger client from host: ${HOST}"
rm -rf lib/openapi
openapi-generator generate --input-spec ${HOST}/docs-json --generator-name swift5 --output lib/openapi -c ../openapi_config.yaml --type-mappings integer=Int64
pod install
popd
