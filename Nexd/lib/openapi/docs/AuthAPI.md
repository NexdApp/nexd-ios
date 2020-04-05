# AuthAPI

All URIs are relative to *https://nexd-backend-staging.herokuapp.com:443/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authControllerLogin**](AuthAPI.md#authcontrollerlogin) | **POST** /auth/login | Login by email and password 
[**authControllerRefreshToken**](AuthAPI.md#authcontrollerrefreshtoken) | **POST** /auth/refresh | Not yet implemented, token refresh
[**authControllerRegister**](AuthAPI.md#authcontrollerregister) | **POST** /auth/register | Register with email and password 


# **authControllerLogin**
```swift
    open class func authControllerLogin(loginDto: LoginDto) -> Observable<TokenDto>
```

Login by email and password 

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let loginDto = LoginDto(email: "email_example", password: "password_example") // LoginDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginDto** | [**LoginDto**](LoginDto.md) |  | 

### Return type

[**TokenDto**](TokenDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRefreshToken**
```swift
    open class func authControllerRefreshToken(tokenDto: TokenDto) -> Observable<TokenDto>
```

Not yet implemented, token refresh

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let tokenDto = TokenDto(accessToken: "accessToken_example") // TokenDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tokenDto** | [**TokenDto**](TokenDto.md) |  | 

### Return type

[**TokenDto**](TokenDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerRegister**
```swift
    open class func authControllerRegister(registerDto: RegisterDto) -> Observable<TokenDto>
```

Register with email and password 

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let registerDto = RegisterDto(email: "email_example", firstName: "firstName_example", lastName: "lastName_example", password: "password_example") // RegisterDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerDto** | [**RegisterDto**](RegisterDto.md) |  | 

### Return type

[**TokenDto**](TokenDto.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

