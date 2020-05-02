# AuthAPI

All URIs are relative to *https://nexd-backend.herokuapp.com:443/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authControllerLogin**](AuthAPI.md#authcontrollerlogin) | **POST** /auth/login | Login by email and password 
[**authControllerRefreshToken**](AuthAPI.md#authcontrollerrefreshtoken) | **POST** /auth/refresh | Not yet implemented, token refresh
[**authControllerRegister**](AuthAPI.md#authcontrollerregister) | **POST** /auth/register | Register with email and password 
[**authControllerResetEmailPasswordInitiate**](AuthAPI.md#authcontrollerresetemailpasswordinitiate) | **GET** /auth/reset_email_password_initiate/{email} | Email password reset initiation
[**authControllerResetPasswordComplete**](AuthAPI.md#authcontrollerresetpasswordcomplete) | **POST** /auth/reset_email_password_complete | Email password reset initiation


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

let registerDto = RegisterDto(email: "email_example", firstName: "firstName_example", lastName: "lastName_example", phoneNumber: "phoneNumber_example", password: "password_example") // RegisterDto | 

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

# **authControllerResetEmailPasswordInitiate**
```swift
    open class func authControllerResetEmailPasswordInitiate(email: String) -> Observable<Void>
```

Email password reset initiation

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let email = "email_example" // String | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **email** | **String** |  | 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authControllerResetPasswordComplete**
```swift
    open class func authControllerResetPasswordComplete(emailPasswordResetDto: EmailPasswordResetDto) -> Observable<Void>
```

Email password reset initiation

### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let emailPasswordResetDto = EmailPasswordResetDto(email: "email_example", passwordResetToken: "passwordResetToken_example", password: "password_example") // EmailPasswordResetDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **emailPasswordResetDto** | [**EmailPasswordResetDto**](EmailPasswordResetDto.md) |  | 

### Return type

Void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

