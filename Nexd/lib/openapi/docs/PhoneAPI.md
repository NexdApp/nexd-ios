# PhoneAPI

All URIs are relative to *https://api.nexd.app:443/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**phoneControllerConverted**](PhoneAPI.md#phonecontrollerconverted) | **POST** /phone/calls/{sid}/help-request | Creates a new help request for a call and creates a user for the phoneNumber
[**phoneControllerGetCalls**](PhoneAPI.md#phonecontrollergetcalls) | **GET** /phone/calls | Returns all calls with the given parameters
[**phoneControllerGetNumbers**](PhoneAPI.md#phonecontrollergetnumbers) | **GET** /phone/numbers | Returns available numbers


# **phoneControllerConverted**
```swift
    open class func phoneControllerConverted(sid: String, helpRequestCreateDto: HelpRequestCreateDto) -> Observable<Call>
```

Creates a new help request for a call and creates a user for the phoneNumber

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let sid = "sid_example" // String | call sid
let helpRequestCreateDto = HelpRequestCreateDto(firstName: "firstName_example", lastName: "lastName_example", street: "street_example", number: "number_example", zipCode: "zipCode_example", city: "city_example", articles: [CreateHelpRequestArticleDto(articleId: 123, articleName: "articleName_example", language: AvailableLanguages(), articleCount: 123, unitId: 123)], status: "status_example", additionalRequest: "additionalRequest_example", deliveryComment: "deliveryComment_example", phoneNumber: "phoneNumber_example") // HelpRequestCreateDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **sid** | **String** | call sid | 
 **helpRequestCreateDto** | [**HelpRequestCreateDto**](HelpRequestCreateDto.md) |  | 

### Return type

[**Call**](Call.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **phoneControllerGetCalls**
```swift
    open class func phoneControllerGetCalls(userId: String? = nil, limit: Double? = nil, converted: Bool? = nil, country: String? = nil, zip: String? = nil, city: String? = nil) -> Observable<[Call]>
```

Returns all calls with the given parameters

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let userId = "userId_example" // String | If included, filter by userId, \"me\" for the requesting user, otherwise all users are replied.  (optional)
let limit = 987 // Double |  (optional)
let converted = true // Bool | true if you only want to query calls which are already converted to a        'help request, false otherwise. Returns all calls if undefined. (optional)
let country = "country_example" // String |  (optional)
let zip = "zip_example" // String |  (optional)
let city = "city_example" // String |  (optional)

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String** | If included, filter by userId, \&quot;me\&quot; for the requesting user, otherwise all users are replied.  | [optional] 
 **limit** | **Double** |  | [optional] 
 **converted** | **Bool** | true if you only want to query calls which are already converted to a        &#39;help request, false otherwise. Returns all calls if undefined. | [optional] 
 **country** | **String** |  | [optional] 
 **zip** | **String** |  | [optional] 
 **city** | **String** |  | [optional] 

### Return type

[**[Call]**](Call.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **phoneControllerGetNumbers**
```swift
    open class func phoneControllerGetNumbers() -> Observable<[PhoneNumberDto]>
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

[**[PhoneNumberDto]**](PhoneNumberDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

