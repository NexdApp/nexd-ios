Pod::Spec.new do |s|
  s.name = 'NexdClient'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '3.0'
  s.version = '1.0'
  s.source = { :git => 'git@github.com:OpenAPITools/openapi-generator.git', :tag => 'v1.0' }
  s.authors = 'OpenAPI Generator'
  s.license = 'Proprietary'
  s.homepage = 'https://github.com/NexdApp/nexd-ios'
  s.summary = 'OpenAPI Client'
  s.source_files = 'NexdClient/Classes/**/*.swift'
  s.dependency 'RxSwift', '~> 5.0.0'
end
