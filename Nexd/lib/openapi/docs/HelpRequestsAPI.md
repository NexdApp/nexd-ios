# HelpRequestsAPI

All URIs are relative to *https://nexd-backend-staging.herokuapp.com:443/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**helpRequestsControllerAddArticleInHelpRequest**](HelpRequestsAPI.md#helprequestscontrolleraddarticleinhelprequest) | **PUT** /help-requests/{helpRequestId}/article/{articleId} | Put an article to a help request, endpoint overrides.
[**helpRequestsControllerGetAll**](HelpRequestsAPI.md#helprequestscontrollergetall) | **GET** /help-requests | Get and filter for various help requests
[**helpRequestsControllerGetSingleRequest**](HelpRequestsAPI.md#helprequestscontrollergetsinglerequest) | **GET** /help-requests/{helpRequestId} | Get a single help request by id
[**helpRequestsControllerInsertRequestWithArticles**](HelpRequestsAPI.md#helprequestscontrollerinsertrequestwitharticles) | **POST** /help-requests | Add a help request
[**helpRequestsControllerRemoveArticleInHelpRequest**](HelpRequestsAPI.md#helprequestscontrollerremovearticleinhelprequest) | **DELETE** /help-requests/{helpRequestId}/article/{articleId} | Remove an article from a help request
[**helpRequestsControllerUpdateRequest**](HelpRequestsAPI.md#helprequestscontrollerupdaterequest) | **PUT** /help-requests/{helpRequestId} | Modify a help request (e.g. address or articles)


# **helpRequestsControllerAddArticleInHelpRequest**
```swift
    open class func helpRequestsControllerAddArticleInHelpRequest(helpRequestId: Int64, articleId: Int64, createOrUpdateHelpRequestArticleDto: CreateOrUpdateHelpRequestArticleDto) -> Observable<HelpRequest>
```

Put an article to a help request, endpoint overrides.

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let helpRequestId = 987 // Int64 | Id of the help request
let articleId = 987 // Int64 | Id of the article
let createOrUpdateHelpRequestArticleDto = CreateOrUpdateHelpRequestArticleDto(articleCount: 123, articleDone: false) // CreateOrUpdateHelpRequestArticleDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpRequestId** | **Int64** | Id of the help request | 
 **articleId** | **Int64** | Id of the article | 
 **createOrUpdateHelpRequestArticleDto** | [**CreateOrUpdateHelpRequestArticleDto**](CreateOrUpdateHelpRequestArticleDto.md) |  | 

### Return type

[**HelpRequest**](HelpRequest.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpRequestsControllerGetAll**
```swift
    open class func helpRequestsControllerGetAll(userId: String? = nil, excludeUserId: Bool? = nil, zipCode: [String]? = nil, includeRequester: Bool? = nil, status: [String]? = nil) -> Observable<[HelpRequest]>
```

Get and filter for various help requests

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let userId = "userId_example" // String | If included, filter by userId, \"me\" for the requesting user, otherwise all users are replied. (optional)
let excludeUserId = true // Bool | If true, the given userId is excluded (and not filtered for as default) (optional)
let zipCode = ["inner_example"] // [String] | Filter by an array of zipCodes (optional)
let includeRequester = true // Bool | If \"true\", the requester object is included in each help request (optional)
let status = ["status_example"] // [String] | Array of status to filter for (optional)

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String** | If included, filter by userId, \&quot;me\&quot; for the requesting user, otherwise all users are replied. | [optional] 
 **excludeUserId** | **Bool** | If true, the given userId is excluded (and not filtered for as default) | [optional] 
 **zipCode** | [**[String]**](String.md) | Filter by an array of zipCodes | [optional] 
 **includeRequester** | **Bool** | If \&quot;true\&quot;, the requester object is included in each help request | [optional] 
 **status** | [**[String]**](String.md) | Array of status to filter for | [optional] 

### Return type

[**[HelpRequest]**](HelpRequest.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpRequestsControllerGetSingleRequest**
```swift
    open class func helpRequestsControllerGetSingleRequest(helpRequestId: Int64) -> Observable<HelpRequest>
```

Get a single help request by id

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let helpRequestId = 987 // Int64 | Id of the help request

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpRequestId** | **Int64** | Id of the help request | 

### Return type

[**HelpRequest**](HelpRequest.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpRequestsControllerInsertRequestWithArticles**
```swift
    open class func helpRequestsControllerInsertRequestWithArticles(helpRequestCreateDto: HelpRequestCreateDto) -> Observable<HelpRequest>
```

Add a help request

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let helpRequestCreateDto = HelpRequestCreateDto(street: "street_example", number: "number_example", zipCode: "zipCode_example", city: "city_example", articles: [CreateHelpRequestArticleDto(articleId: 123, articleCount: 123)], status: "status_example", additionalRequest: "additionalRequest_example", deliveryComment: "deliveryComment_example", phoneNumber: "phoneNumber_example") // HelpRequestCreateDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpRequestCreateDto** | [**HelpRequestCreateDto**](HelpRequestCreateDto.md) |  | 

### Return type

[**HelpRequest**](HelpRequest.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpRequestsControllerRemoveArticleInHelpRequest**
```swift
    open class func helpRequestsControllerRemoveArticleInHelpRequest(helpRequestId: Int64, articleId: Int64) -> Observable<HelpRequest>
```

Remove an article from a help request

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let helpRequestId = 987 // Int64 | Id of the help request
let articleId = 987 // Int64 | Id of the article

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpRequestId** | **Int64** | Id of the help request | 
 **articleId** | **Int64** | Id of the article | 

### Return type

[**HelpRequest**](HelpRequest.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpRequestsControllerUpdateRequest**
```swift
    open class func helpRequestsControllerUpdateRequest(helpRequestId: Int64, helpRequestCreateDto: HelpRequestCreateDto) -> Observable<HelpRequest>
```

Modify a help request (e.g. address or articles)

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let helpRequestId = 987 // Int64 | Id of the help request
let helpRequestCreateDto = HelpRequestCreateDto(street: "street_example", number: "number_example", zipCode: "zipCode_example", city: "city_example", articles: [CreateHelpRequestArticleDto(articleId: 123, articleCount: 123)], status: "status_example", additionalRequest: "additionalRequest_example", deliveryComment: "deliveryComment_example", phoneNumber: "phoneNumber_example") // HelpRequestCreateDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpRequestId** | **Int64** | Id of the help request | 
 **helpRequestCreateDto** | [**HelpRequestCreateDto**](HelpRequestCreateDto.md) |  | 

### Return type

[**HelpRequest**](HelpRequest.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

