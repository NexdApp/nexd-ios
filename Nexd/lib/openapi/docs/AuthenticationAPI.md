# AuthenticationAPI

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authControllerLogin**](AuthenticationAPI.md#authcontrollerlogin) | **POST** /api/auth/login | 
[**authControllerRegister**](AuthenticationAPI.md#authcontrollerregister) | **POST** /api/auth/register | 


# **authControllerLogin**
```swift
    open class func authControllerLogin(loginPayload: LoginPayload) -> Observable<ResponseTokenDto>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let loginPayload = LoginPayload(email: "email_example", password: "password_example") // LoginPayload | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginPayload** | [**LoginPayload**](LoginPayload.md) |  | 

### Return type

[**ResponseTokenDto**](ResponseTokenDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRegister**
```swift
    open class func authControllerRegister(registerPayload: RegisterPayload) -> Observable<ResponseTokenDto>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let registerPayload = RegisterPayload(email: "email_example", firstName: "firstName_example", lastName: "lastName_example", role: "role_example", password: "password_example") // RegisterPayload | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerPayload** | [**RegisterPayload**](RegisterPayload.md) |  | 

### Return type

[**ResponseTokenDto**](ResponseTokenDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

