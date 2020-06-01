# ArticlesAPI

All URIs are relative to *https://nexd-backend-staging.herokuapp.com:443/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**articlesControllerFindAll**](ArticlesAPI.md#articlescontrollerfindall) | **GET** /article/articles | List articles
[**articlesControllerGetUnits**](ArticlesAPI.md#articlescontrollergetunits) | **GET** /article/units | Get a list of units
[**articlesControllerInsertOne**](ArticlesAPI.md#articlescontrollerinsertone) | **POST** /article/articles | Create an article


# **articlesControllerFindAll**
```swift
    open class func articlesControllerFindAll(limit: Double? = nil, startsWith: String? = nil, contains: String? = nil, orderByPopularity: Bool? = nil, language: AvailableLanguages? = nil, onlyVerified: Bool? = nil) -> Observable<[Article]>
```

List articles

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let limit = 987 // Double | Maximum number of articles  (optional)
let startsWith = "startsWith_example" // String | Starts with the given string. Empty string does not filter. (optional)
let contains = "contains_example" // String | Contains with the given string. Empty string does not filter. (optional)
let orderByPopularity = true // Bool | If true, orders by the most frequent used articles first. Defaults to false. (optional)
let language = AvailableLanguages() // AvailableLanguages |  (optional)
let onlyVerified = true // Bool | true to only gets the list of curated articles (default: true) (optional)

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Double** | Maximum number of articles  | [optional] 
 **startsWith** | **String** | Starts with the given string. Empty string does not filter. | [optional] 
 **contains** | **String** | Contains with the given string. Empty string does not filter. | [optional] 
 **orderByPopularity** | **Bool** | If true, orders by the most frequent used articles first. Defaults to false. | [optional] 
 **language** | [**AvailableLanguages**](.md) |  | [optional] 
 **onlyVerified** | **Bool** | true to only gets the list of curated articles (default: true) | [optional] 

### Return type

[**[Article]**](Article.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **articlesControllerGetUnits**
```swift
    open class func articlesControllerGetUnits(language: AvailableLanguages? = nil) -> Observable<[Unit]>
```

Get a list of units

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let language = AvailableLanguages() // AvailableLanguages |  (optional)

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **language** | [**AvailableLanguages**](.md) |  | [optional] 

### Return type

[**[Unit]**](Unit.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **articlesControllerInsertOne**
```swift
    open class func articlesControllerInsertOne(createArticleDto: CreateArticleDto) -> Observable<Article>
```

Create an article

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let createArticleDto = CreateArticleDto(name: "name_example", language: "language_example") // CreateArticleDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createArticleDto** | [**CreateArticleDto**](CreateArticleDto.md) |  | 

### Return type

[**Article**](Article.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

