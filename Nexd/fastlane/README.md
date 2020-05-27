fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios bootstrap
```
fastlane ios bootstrap
```

### ios lint
```
fastlane ios lint
```

### ios test
```
fastlane ios test
```
Run the tests
### ios create_screenshots
```
fastlane ios create_screenshots
```
Create screenshots
### ios testflight_beta
```
fastlane ios testflight_beta
```
Build for distribution (via App Store and TestFlight)

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
