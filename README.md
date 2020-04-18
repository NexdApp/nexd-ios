# Deployment status


- develop to TestFlight: ![TestFlight](https://github.com/NexdApp/nexd-ios/workflows/TestFlight/badge.svg?branch=develop)

# Initial Setup

Make sure you've installed [bundler](https://bundler.io/) on your mac.

```
$ cd Nexd
$ bundle install
$ bundle exec pod install
$ open Nexd.xcworkspace
```

# Update REST client

Needs to be done when the backend deployed changes.

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
- SwiftUI: After the Hackathon I started to dive into SwiftUI and deicded to implement all new screens in SwiftUI (refer to eg. `Transcribe*View.swift` screens)
- [fastlane](https://fastlane.tools/) and [match](https://docs.fastlane.tools/actions/match/) for CI/CD automation
- Branche/Release model: Based on git flow:
  - we work with feature branches based on `develop`
  - features are merged via [pull requests](https://github.com/NexdApp/nexd-ios/pulls) in github
  - releases are prepared in release branches (named something like `release/*`)
  - releae branches are merged into `master` and `master` will be deployed automatically to testflight

# FAQ:

## Where can I find:

- Portal where string translations are mainained: https://poeditor.com/projects/view?id=328861
- Screen designs: https://www.figma.com/file/QsK3lJrsgYLcFFIx49g23R/Nexd?node-id=552%3A45
- Stuff which I can start to work on: https://github.com/NexdApp/nexd-ios/issues
