# Initial Setup

```
$ pod install
```

# Chose backend url

- change `baseUrl` in `AppConfiguration`

# Update REST client

## From local backend

```
$ cd NearBuy
$ openapi-generator generate --input-spec http://localhost:3001/api/docs-json --generator-name swift5 --output lib/openapi --additional-properties podHomepage="https://github.com/NearBuyVsVirus/nearbuy-ios",podSummary="Swagger Client",responseAs=RxSwift
$ pod isntall
```

## From deployed backend

```
$ cd NearBuy
$ openapi-generator generate --input-spec http://nexd-api-alb-1107636132.eu-central-1.elb.amazonaws.com/api/docs-json --generator-name swift5 --output lib/openapi --additional-properties podHomepage="https://github.com/NearBuyVsVirus/nearbuy-ios",podSummary="Swagger Client",responseAs=RxSwift --type-mappings number=Int
$ pod isntall
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
