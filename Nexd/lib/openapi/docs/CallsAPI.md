# CallsAPI

All URIs are relative to *https://nexd-backend-staging.herokuapp.com:443/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**callsControllerCalls**](CallsAPI.md#callscontrollercalls) | **GET** /call/calls | Returns all calls with the given parameters
[**callsControllerConverted**](CallsAPI.md#callscontrollerconverted) | **PUT** /call/calls/{sid}/converted | Sets a call as converted to shopping list
[**callsControllerGetCallUrl**](CallsAPI.md#callscontrollergetcallurl) | **GET** /call/calls/{sid}/record | Redirects the request to the stored record file.
[**callsControllerGetNumber**](CallsAPI.md#callscontrollergetnumber) | **GET** /call/number | Returns available numbers


# **callsControllerCalls**
```swift
    open class func callsControllerCalls(limit: Double? = nil, converted: String? = nil, country: String? = nil, zip: Double? = nil, city: String? = nil) -> Observable<[Call]>
```

Returns all calls with the given parameters

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let limit = 987 // Double |  (optional)
let converted = "converted_example" // String | True if you only want to query calls which are already converted to a help request, false otherwise. Returns all calls if undefined. (optional)
let country = "country_example" // String |  (optional)
let zip = 987 // Double |  (optional)
let city = "city_example" // String |  (optional)

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **Double** |  | [optional] 
 **converted** | **String** | True if you only want to query calls which are already converted to a help request, false otherwise. Returns all calls if undefined. | [optional] 
 **country** | **String** |  | [optional] 
 **zip** | **Double** |  | [optional] 
 **city** | **String** |  | [optional] 

### Return type

[**[Call]**](Call.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **callsControllerConverted**
```swift
    open class func callsControllerConverted(sid: String, convertedHelpRequestDto: ConvertedHelpRequestDto) -> Observable<Call>
```

Sets a call as converted to shopping list

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let sid = "sid_example" // String | call sid
let convertedHelpRequestDto = ConvertedHelpRequestDto(helpRequestId: 123) // ConvertedHelpRequestDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sid** | **String** | call sid | 
 **convertedHelpRequestDto** | [**ConvertedHelpRequestDto**](ConvertedHelpRequestDto.md) |  | 

### Return type

[**Call**](Call.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **callsControllerGetCallUrl**
```swift
    open class func callsControllerGetCallUrl(sid: String) -> Observable<URL>
```

Redirects the request to the stored record file.

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let sid = "sid_example" // String | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sid** | **String** |  | 

### Return type

**URL**

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: audio/x-wav

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **callsControllerGetNumber**
```swift
    open class func callsControllerGetNumber() -> Observable<String>
```

Returns available numbers

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient


// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters
This endpoint does not need any parameter.

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: applicaton/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

