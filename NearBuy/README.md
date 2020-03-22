# Initial Setup

```
$ pod install
```

# Chose backend url

- change `baseUrl` in `AppConfiguration`

# Update REST client

## From localhost
```
$ swagger-codegen generate -i http://localhost:3001/api/docs-json -l swift5  --additional-properties podHomepage=https://github.com/NearBuyVsVirus/nearbuy-ios,podSummary="Swagger Client",responseAs=RxSwift --type-mappings BigDecimal=Int
```

## From heroku
```
$ swagger-codegen generate -i https://wirvsvirus-nearbuy.herokuapp.com/api/docs-json -l swift5  --additional-properties podHomepage=https://github.com/NearBuyVsVirus/nearbuy-ios,podSummary="Swagger Client",responseAs=RxSwift --type-mappings BigDecimal=Int
$ cd NearBuy
$ pod install
```


# Local backend

## Launch db

```
$ docker-compose up -d db
```

## Reset db

```
$ docker-compose down
$ docker volume ls
$ docker volume remove nearbuy-backend_data-volume
$ docker-compose up -d db
```

## Known issues

- update of access token in API client right after registration/login is ingored -> app needs to be killed and restarted
