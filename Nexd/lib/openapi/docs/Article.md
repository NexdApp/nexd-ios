# Article

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **Int64** | Auto-incremented ID of an article. | 
**name** | **String** | Name of the article (without unit) | 
**language** | [**AvailableLanguages**](AvailableLanguages.md) |  | 
**statusOverwritten** | **Bool** | The article status can be enforced by an admin (e.g. to remove profanity). | [optional] [default to false]
**popularity** | **Int64** | Popularity of the article, the higher the more frequent used. | 
**unitIdOrder** | **[Int64]** | Determined order of the units. If the array is empty, there is no order yet identified. | [optional] 
**categoryId** | **Int64** |  | [optional] 
**status** | **String** |  | [optional] 
**category** | [**Category**](Category.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


