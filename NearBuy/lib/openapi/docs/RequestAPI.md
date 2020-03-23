# RequestAPI

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**requestControllerGetAll**](RequestAPI.md#requestcontrollergetall) | **GET** /api/request | 
[**requestControllerGetSingleRequest**](RequestAPI.md#requestcontrollergetsinglerequest) | **GET** /api/request/{requestId} | 
[**requestControllerInsertRequestWithArticles**](RequestAPI.md#requestcontrollerinsertrequestwitharticles) | **POST** /api/request | 
[**requestControllerMarkArticleAsDone**](RequestAPI.md#requestcontrollermarkarticleasdone) | **PUT** /api/request/{requestId}/{articleId} | 
[**requestControllerUpdateRequest**](RequestAPI.md#requestcontrollerupdaterequest) | **PUT** /api/request/{requestId} | 


# **requestControllerGetAll**
```swift
    open class func requestControllerGetAll(onlyMine: String? = nil, zipCode: String? = nil) -> Observable<[RequestEntity]>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let onlyMine = "onlyMine_example" // String | if \"true\", only the requesting user requests will be replied. (optional)
let zipCode = "zipCode_example" // String | if set, only requests within the same zip code will be replied (optional)

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **onlyMine** | **String** | if \&quot;true\&quot;, only the requesting user requests will be replied. | [optional] 
 **zipCode** | **String** | if set, only requests within the same zip code will be replied | [optional] 

### Return type

[**[RequestEntity]**](RequestEntity.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestControllerGetSingleRequest**
```swift
    open class func requestControllerGetSingleRequest(requestId: Int) -> Observable<RequestEntity>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let requestId = 987 // Int | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **Int** |  | 

### Return type

[**RequestEntity**](RequestEntity.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestControllerInsertRequestWithArticles**
```swift
    open class func requestControllerInsertRequestWithArticles(requestFormDto: RequestFormDto) -> Observable<RequestEntity>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let requestFormDto = RequestFormDto(street: "street_example", number: "number_example", zipCode: "zipCode_example", city: "city_example", articles: [CreateRequestArticleDto(articleId: 123, articleCount: 123)], status: "status_example", additionalRequest: "additionalRequest_example", deliveryComment: "deliveryComment_example", phoneNumber: "phoneNumber_example") // RequestFormDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestFormDto** | [**RequestFormDto**](RequestFormDto.md) |  | 

### Return type

[**RequestEntity**](RequestEntity.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestControllerMarkArticleAsDone**
```swift
    open class func requestControllerMarkArticleAsDone(requestId: Int, articleId: Int, requestArticleStatusDto: RequestArticleStatusDto) -> Observable<RequestEntity>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let requestId = 987 // Int | 
let articleId = 987 // Int | 
let requestArticleStatusDto = RequestArticleStatusDto(articleDone: false) // RequestArticleStatusDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **Int** |  | 
 **articleId** | **Int** |  | 
 **requestArticleStatusDto** | [**RequestArticleStatusDto**](RequestArticleStatusDto.md) |  | 

### Return type

[**RequestEntity**](RequestEntity.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestControllerUpdateRequest**
```swift
    open class func requestControllerUpdateRequest(requestId: Int, requestFormDto: RequestFormDto) -> Observable<RequestEntity>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let requestId = 987 // Int | 
let requestFormDto = RequestFormDto(street: "street_example", number: "number_example", zipCode: "zipCode_example", city: "city_example", articles: [CreateRequestArticleDto(articleId: 123, articleCount: 123)], status: "status_example", additionalRequest: "additionalRequest_example", deliveryComment: "deliveryComment_example", phoneNumber: "phoneNumber_example") // RequestFormDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **Int** |  | 
 **requestFormDto** | [**RequestFormDto**](RequestFormDto.md) |  | 

### Return type

[**RequestEntity**](RequestEntity.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

