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

## From deployed backend

```
$ ./update_swagger_client.sh https://nexd-backend-staging.herokuapp.com/api/v1
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
