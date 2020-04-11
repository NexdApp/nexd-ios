# Deployment status


- develop to TestFlight: ![TestFlight](https://github.com/NexdApp/nexd-ios/workflows/TestFlight/badge.svg?branch=develop)

# Initial Setup

```
$ pod install
```

# Chose backend url

- change `baseUrl` in `AppConfiguration`

# Update REST client

## From local backend

```
$ ./update_swagger_client.sh
```

## From staging backend

```
$ ./update_swagger_client.sh https://nexd-backend-staging.herokuapp.com/api/v1
```


## From producton backend

```
$ ./update_swagger_client.sh https://nexd-backend.herokuapp.com/api/v1
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

# Architecture

## Technologies

- API client generated from swagger with [openapi-generator](https://openapi-generator.tech/)
- [RxSwift & RxCocoa](https://github.com/ReactiveX/RxSwift)
- [Cleanse](https://github.com/square/Cleanse) for dependency injection
- [R.swift](https://github.com/mac-cain13/R.swift) for strongly typed access to resources:
  - Colors: in Collors.xcassets
  - Images: in Assets.xcassets
  - Fonts
  - Strings: maintained in [POEditor](https://poeditor.com)
