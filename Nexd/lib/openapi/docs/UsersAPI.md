# UsersAPI

All URIs are relative to *https://nexd-backend.herokuapp.com:443/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**userControllerFindMe**](UsersAPI.md#usercontrollerfindme) | **GET** /users/me | Get user profile of the requesting user
[**userControllerFindOne**](UsersAPI.md#usercontrollerfindone) | **GET** /users/{userId} | Get user profile of a specific user
[**userControllerGetAll**](UsersAPI.md#usercontrollergetall) | **GET** /users | Get all users
[**userControllerUpdate**](UsersAPI.md#usercontrollerupdate) | **PUT** /users/{userId} | Update profile of a specific user
[**userControllerUpdateMyself**](UsersAPI.md#usercontrollerupdatemyself) | **PUT** /users/me | Update profile of the requesting user


# **userControllerFindMe**
```swift
    open class func userControllerFindMe() -> Observable<User>
```

Get user profile of the requesting user

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient


// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**User**](User.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userControllerFindOne**
```swift
    open class func userControllerFindOne(userId: String) -> Observable<User>
```

Get user profile of a specific user

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let userId = "userId_example" // String | user id

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String** | user id | 

### Return type

[**User**](User.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userControllerGetAll**
```swift
    open class func userControllerGetAll(xAdminSecret: String) -> Observable<[User]>
```

Get all users

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let xAdminSecret = "xAdminSecret_example" // String | Secret to access the admin functions.

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xAdminSecret** | **String** | Secret to access the admin functions. | 

### Return type

[**[User]**](User.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userControllerUpdate**
```swift
    open class func userControllerUpdate(userId: String, updateUserDto: UpdateUserDto) -> Observable<User>
```

Update profile of a specific user

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let userId = "userId_example" // String | user id
let updateUserDto = UpdateUserDto(firstName: "firstName_example", lastName: "lastName_example", street: "street_example", number: "number_example", zipCode: "zipCode_example", city: "city_example", role: "role_example", phoneNumber: "phoneNumber_example") // UpdateUserDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String** | user id | 
 **updateUserDto** | [**UpdateUserDto**](UpdateUserDto.md) |  | 

### Return type

[**User**](User.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **userControllerUpdateMyself**
```swift
    open class func userControllerUpdateMyself(updateUserDto: UpdateUserDto) -> Observable<User>
```

Update profile of the requesting user

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let updateUserDto = UpdateUserDto(firstName: "firstName_example", lastName: "lastName_example", street: "street_example", number: "number_example", zipCode: "zipCode_example", city: "city_example", role: "role_example", phoneNumber: "phoneNumber_example") // UpdateUserDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateUserDto** | [**UpdateUserDto**](UpdateUserDto.md) |  | 

### Return type

[**User**](User.md)

### Authorization

[bearer](../README.md#bearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

