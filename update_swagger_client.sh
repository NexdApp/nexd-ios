#!/bin/bash

HOST="http://localhost:3001"

if [ -n "$1" ]
then
  HOST="$1"
fi

pushd Nexd
echo "Updating Swagger client from host: ${HOST}"
rm -rf lib/openapi
openapi-generator generate --input-spec ${HOST}/docs-json --generator-name swift5 --output lib/openapi --additional-properties podHomepage="https://github.com/NexdApp/nexd-ios",podSummary="OpenAPI Client",responseAs=RxSwift,projectName=NexdClient --type-mappings integer=Int64
pod install
popd
