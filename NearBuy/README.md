# Initial Setup

```
$ pod install
```

# Update REST client

## From localhost
```
$ swagger-codegen generate -i http://localhost:3001/api/docs-json -l swift5  --additional-properties podHomepage=https://github.com/NearBuyVsVirus/nearbuy-ios,podSummary="Swagger Client",responseAs=RxSwift --type-mappings BigDecimal=Int
```

## From heroku
```
$ swagger-codegen generate -i https://wirvsvirus-nearbuy.herokuapp.com/api/docs-json -l swift5  --additional-properties podHomepage=https://github.com/NearBuyVsVirus/nearbuy-ios,podSummary="Swagger Client",responseAs=RxSwift --type-mappings BigDecimal=Int
```
