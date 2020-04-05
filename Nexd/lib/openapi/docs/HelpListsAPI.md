# HelpListsAPI

All URIs are relative to *https://nexd-backend-staging.herokuapp.com:443/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**helpListsControllerAddHelpRequestToList**](HelpListsAPI.md#helplistscontrolleraddhelprequesttolist) | **PUT** /help-lists/{helpListId}/help-request/{helpRequestId} | Add a help request to a help list
[**helpListsControllerDeleteHelpRequestFromHelpList**](HelpListsAPI.md#helplistscontrollerdeletehelprequestfromhelplist) | **DELETE** /help-lists/{helpListId}/help-request/{helpRequestId} | Delete a help request from help list
[**helpListsControllerFindOne**](HelpListsAPI.md#helplistscontrollerfindone) | **GET** /help-lists/{helpListId} | Get a specific help list
[**helpListsControllerGetUserLists**](HelpListsAPI.md#helplistscontrollergetuserlists) | **GET** /help-lists | Get help lists of the requesting user
[**helpListsControllerInsertNewHelpList**](HelpListsAPI.md#helplistscontrollerinsertnewhelplist) | **POST** /help-lists | Add a new help list for the current user
[**helpListsControllerModifyArticleInAllHelpRequests**](HelpListsAPI.md#helplistscontrollermodifyarticleinallhelprequests) | **PUT** /help-lists/{helpListId}/article/{articleId} | Set/unset article done in all help requests
[**helpListsControllerModifyArticleInHelpRequest**](HelpListsAPI.md#helplistscontrollermodifyarticleinhelprequest) | **PUT** /help-lists/{helpListId}/help-request/{helpRequestId}/article/{articleId} | Set/unset articleDone of an article in a specific help request
[**helpListsControllerUpdateHelpLists**](HelpListsAPI.md#helplistscontrollerupdatehelplists) | **PUT** /help-lists/{helpListId} | Modify a help list


# **helpListsControllerAddHelpRequestToList**
```swift
    open class func helpListsControllerAddHelpRequestToList(helpListId: Int, helpRequestId: Int) -> Observable<HelpList>
```

Add a help request to a help list

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let helpListId = 987 // Int | Id of the help list
let helpRequestId = 987 // Int | Id of the help request

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpListId** | **Int** | Id of the help list | 
 **helpRequestId** | **Int** | Id of the help request | 

### Return type

[**HelpList**](HelpList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpListsControllerDeleteHelpRequestFromHelpList**
```swift
    open class func helpListsControllerDeleteHelpRequestFromHelpList(helpListId: Int, helpRequestId: Int) -> Observable<HelpList>
```

Delete a help request from help list

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let helpListId = 987 // Int | Id of the help list
let helpRequestId = 987 // Int | Id of the help request

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpListId** | **Int** | Id of the help list | 
 **helpRequestId** | **Int** | Id of the help request | 

### Return type

[**HelpList**](HelpList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpListsControllerFindOne**
```swift
    open class func helpListsControllerFindOne(helpListId: Int64) -> Observable<HelpList>
```

Get a specific help list

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let helpListId = 987 // Int64 | Id of the help list

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpListId** | **Int64** | Id of the help list | 

### Return type

[**HelpList**](HelpList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpListsControllerGetUserLists**
```swift
    open class func helpListsControllerGetUserLists(userId: String? = nil) -> Observable<[HelpList]>
```

Get help lists of the requesting user

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let userId = "userId_example" // String | If included, filter by userId, otherwise by requesting user. (optional)

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String** | If included, filter by userId, otherwise by requesting user. | [optional] 

### Return type

[**[HelpList]**](HelpList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpListsControllerInsertNewHelpList**
```swift
    open class func helpListsControllerInsertNewHelpList(helpListCreateDto: HelpListCreateDto) -> Observable<HelpList>
```

Add a new help list for the current user

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let helpListCreateDto = HelpListCreateDto(helpRequestsIds: [123], status: "status_example") // HelpListCreateDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpListCreateDto** | [**HelpListCreateDto**](HelpListCreateDto.md) |  | 

### Return type

[**HelpList**](HelpList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpListsControllerModifyArticleInAllHelpRequests**
```swift
    open class func helpListsControllerModifyArticleInAllHelpRequests(articleDone: Bool, helpListId: Int, articleId: Int64) -> Observable<HelpList>
```

Set/unset article done in all help requests

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let articleDone = true // Bool | true to set the article as \"bought\"
let helpListId = 987 // Int | Id of the help list
let articleId = 987 // Int64 | Id of the article

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **articleDone** | **Bool** | true to set the article as \&quot;bought\&quot; | 
 **helpListId** | **Int** | Id of the help list | 
 **articleId** | **Int64** | Id of the article | 

### Return type

[**HelpList**](HelpList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpListsControllerModifyArticleInHelpRequest**
```swift
    open class func helpListsControllerModifyArticleInHelpRequest(articleDone: Bool, helpListId: Int, helpRequestId: Int, articleId: Int) -> Observable<HelpList>
```

Set/unset articleDone of an article in a specific help request

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let articleDone = true // Bool | true to set the article as \"bought\"
let helpListId = 987 // Int | Id of the help list
let helpRequestId = 987 // Int | Id of the help request
let articleId = 987 // Int | Id of the article

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **articleDone** | **Bool** | true to set the article as \&quot;bought\&quot; | 
 **helpListId** | **Int** | Id of the help list | 
 **helpRequestId** | **Int** | Id of the help request | 
 **articleId** | **Int** | Id of the article | 

### Return type

[**HelpList**](HelpList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **helpListsControllerUpdateHelpLists**
```swift
    open class func helpListsControllerUpdateHelpLists(helpListId: Int, helpListCreateDto: HelpListCreateDto) -> Observable<HelpList>
```

Modify a help list

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let helpListId = 987 // Int | Id of the help list
let helpListCreateDto = HelpListCreateDto(helpRequestsIds: [123], status: "status_example") // HelpListCreateDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **helpListId** | **Int** | Id of the help list | 
 **helpListCreateDto** | [**HelpListCreateDto**](HelpListCreateDto.md) |  | 

### Return type

[**HelpList**](HelpList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

