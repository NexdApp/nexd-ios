# ArticlesAPI

All URIs are relative to *http://undefined:80*

Method | HTTP request | Description
------------- | ------------- | -------------
[**articlesControllerFindAll**](ArticlesAPI.md#articlescontrollerfindall) | **GET** /api/articles | 
[**articlesControllerInsertOne**](ArticlesAPI.md#articlescontrollerinsertone) | **POST** /api/articles | 


# **articlesControllerFindAll**
```swift
    open class func articlesControllerFindAll() -> Observable<[Article]>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient


// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**[Article]**](Article.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **articlesControllerInsertOne**
```swift
    open class func articlesControllerInsertOne(createArticleDto: CreateArticleDto) -> Observable<Article>
```



### Example 
```swift
// The following code samples are still beta. For any issue, please report via http://github.com/OpenAPITools/openapi-generator/issues/new
import NexdClient

let createArticleDto = CreateArticleDto(name: "name_example") // CreateArticleDto | 

// TODO RxSwift sample code not yet implemented. To contribute, please open a ticket via http://github.com/OpenAPITools/openapi-generator/issues/new
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createArticleDto** | [**CreateArticleDto**](CreateArticleDto.md) |  | 

### Return type

[**Article**](Article.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

