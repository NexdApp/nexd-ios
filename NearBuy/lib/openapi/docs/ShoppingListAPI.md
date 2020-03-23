# ShoppingListAPI

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**shoppingListControllerAddRequestToList**](ShoppingListAPI.md#shoppinglistcontrolleraddrequesttolist) | **PUT** /api/shopping-list/{shoppingListId}/{requestId} | 
[**shoppingListControllerDeleteRequestFromList**](ShoppingListAPI.md#shoppinglistcontrollerdeleterequestfromlist) | **DELETE** /api/shopping-list/{shoppingListId}/{requestId} | 
[**shoppingListControllerFindOne**](ShoppingListAPI.md#shoppinglistcontrollerfindone) | **GET** /api/shopping-list/{id} | 
[**shoppingListControllerGetUserLists**](ShoppingListAPI.md#shoppinglistcontrollergetuserlists) | **GET** /api/shopping-list | 
[**shoppingListControllerInsertNewShoppingList**](ShoppingListAPI.md#shoppinglistcontrollerinsertnewshoppinglist) | **POST** /api/shopping-list | 
[**shoppingListControllerUpdateShoppingList**](ShoppingListAPI.md#shoppinglistcontrollerupdateshoppinglist) | **PUT** /api/shopping-list/{id} | 


# **shoppingListControllerAddRequestToList**
```swift
    open class func shoppingListControllerAddRequestToList(shoppingListId: Int, requestId: Int) -> Observable<ShoppingList>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let shoppingListId = 987 // Int | 
let requestId = 987 // Int | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **shoppingListId** | **Int** |  | 
 **requestId** | **Int** |  | 

### Return type

[**ShoppingList**](ShoppingList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shoppingListControllerDeleteRequestFromList**
```swift
    open class func shoppingListControllerDeleteRequestFromList(shoppingListId: Int, requestId: Int) -> Observable<ShoppingList>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let shoppingListId = 987 // Int | 
let requestId = 987 // Int | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **shoppingListId** | **Int** |  | 
 **requestId** | **Int** |  | 

### Return type

[**ShoppingList**](ShoppingList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shoppingListControllerFindOne**
```swift
    open class func shoppingListControllerFindOne(id: Int) -> Observable<ShoppingList>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = 987 // Int | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **Int** |  | 

### Return type

[**ShoppingList**](ShoppingList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shoppingListControllerGetUserLists**
```swift
    open class func shoppingListControllerGetUserLists() -> Observable<[ShoppingList]>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient


// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**[ShoppingList]**](ShoppingList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shoppingListControllerInsertNewShoppingList**
```swift
    open class func shoppingListControllerInsertNewShoppingList(shoppingListFormDto: ShoppingListFormDto) -> Observable<ShoppingList>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let shoppingListFormDto = ShoppingListFormDto(requests: 123, status: "status_example") // ShoppingListFormDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **shoppingListFormDto** | [**ShoppingListFormDto**](ShoppingListFormDto.md) |  | 

### Return type

[**ShoppingList**](ShoppingList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **shoppingListControllerUpdateShoppingList**
```swift
    open class func shoppingListControllerUpdateShoppingList(id: Int, shoppingListFormDto: ShoppingListFormDto) -> Observable<ShoppingList>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import OpenAPIClient

let id = 987 // Int | 
let shoppingListFormDto = ShoppingListFormDto(requests: 123, status: "status_example") // ShoppingListFormDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **Int** |  | 
 **shoppingListFormDto** | [**ShoppingListFormDto**](ShoppingListFormDto.md) |  | 

### Return type

[**ShoppingList**](ShoppingList.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

