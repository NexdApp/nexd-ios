//
// ShoppingListAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire
import RxSwift


open class ShoppingListAPI {
    /**

     - parameter shoppingListId: (path)  
     - parameter requestId: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func shoppingListControllerAddRequestToList(shoppingListId: Int, requestId: Int, completion: @escaping ((_ data: ShoppingList?,_ error: Error?) -> Void)) {
        shoppingListControllerAddRequestToListWithRequestBuilder(shoppingListId: shoppingListId, requestId: requestId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     - parameter shoppingListId: (path)  
     - parameter requestId: (path)  
     - returns: Observable<ShoppingList>
     */
    open class func shoppingListControllerAddRequestToList(shoppingListId: Int, requestId: Int) -> Observable<ShoppingList> {
        return Observable.create { observer -> Disposable in
            shoppingListControllerAddRequestToList(shoppingListId: shoppingListId, requestId: requestId) { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     - PUT /api/shopping-list/{shoppingListId}/{requestId}
     - 

     - :
       - type: http
       - name: bearer
     - examples: [{contentType=application/json, example={
  "owner" : 6.027456183070403,
  "updated_at" : "2000-01-23T04:56:07.000+00:00",
  "created_at" : "2000-01-23T04:56:07.000+00:00",
  "id" : 0.8008281904610115,
  "requests" : [ {
    "requestId" : 1.4658129805029452
  }, {
    "requestId" : 1.4658129805029452
  } ],
  "status" : "status"
}}]
     - parameter shoppingListId: (path)  
     - parameter requestId: (path)  

     - returns: RequestBuilder<ShoppingList> 
     */
    open class func shoppingListControllerAddRequestToListWithRequestBuilder(shoppingListId: Int, requestId: Int) -> RequestBuilder<ShoppingList> {
        var path = "/api/shopping-list/{shoppingListId}/{requestId}"
        let shoppingListIdPreEscape = "\(shoppingListId)"
        let shoppingListIdPostEscape = shoppingListIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{shoppingListId}", with: shoppingListIdPostEscape, options: .literal, range: nil)
        let requestIdPreEscape = "\(requestId)"
        let requestIdPostEscape = requestIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{requestId}", with: requestIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ShoppingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func shoppingListControllerFindOne(_id: Int, completion: @escaping ((_ data: ShoppingList?,_ error: Error?) -> Void)) {
        shoppingListControllerFindOneWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     - parameter _id: (path)  
     - returns: Observable<ShoppingList>
     */
    open class func shoppingListControllerFindOne(_id: Int) -> Observable<ShoppingList> {
        return Observable.create { observer -> Disposable in
            shoppingListControllerFindOne(_id: _id) { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     - GET /api/shopping-list/{id}
     - 

     - :
       - type: http
       - name: bearer
     - examples: [{contentType=application/json, example={
  "owner" : 6.027456183070403,
  "updated_at" : "2000-01-23T04:56:07.000+00:00",
  "created_at" : "2000-01-23T04:56:07.000+00:00",
  "id" : 0.8008281904610115,
  "requests" : [ {
    "requestId" : 1.4658129805029452
  }, {
    "requestId" : 1.4658129805029452
  } ],
  "status" : "status"
}}]
     - parameter _id: (path)  

     - returns: RequestBuilder<ShoppingList> 
     */
    open class func shoppingListControllerFindOneWithRequestBuilder(_id: Int) -> RequestBuilder<ShoppingList> {
        var path = "/api/shopping-list/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ShoppingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func shoppingListControllerGetUserLists(completion: @escaping ((_ data: [ShoppingList]?,_ error: Error?) -> Void)) {
        shoppingListControllerGetUserListsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     - returns: Observable<[ShoppingList]>
     */
    open class func shoppingListControllerGetUserLists() -> Observable<[ShoppingList]> {
        return Observable.create { observer -> Disposable in
            shoppingListControllerGetUserLists() { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     - GET /api/shopping-list
     - 

     - :
       - type: http
       - name: bearer
     - examples: [{contentType=application/json, example=[ {
  "owner" : 6.027456183070403,
  "updated_at" : "2000-01-23T04:56:07.000+00:00",
  "created_at" : "2000-01-23T04:56:07.000+00:00",
  "id" : 0.8008281904610115,
  "requests" : [ {
    "requestId" : 1.4658129805029452
  }, {
    "requestId" : 1.4658129805029452
  } ],
  "status" : "status"
}, {
  "owner" : 6.027456183070403,
  "updated_at" : "2000-01-23T04:56:07.000+00:00",
  "created_at" : "2000-01-23T04:56:07.000+00:00",
  "id" : 0.8008281904610115,
  "requests" : [ {
    "requestId" : 1.4658129805029452
  }, {
    "requestId" : 1.4658129805029452
  } ],
  "status" : "status"
} ]}]

     - returns: RequestBuilder<[ShoppingList]> 
     */
    open class func shoppingListControllerGetUserListsWithRequestBuilder() -> RequestBuilder<[ShoppingList]> {
        let path = "/api/shopping-list"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[ShoppingList]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter body: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func shoppingListControllerInsertNewShoppingList(body: ShoppingListFormDto, completion: @escaping ((_ data: ShoppingList?,_ error: Error?) -> Void)) {
        shoppingListControllerInsertNewShoppingListWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     - parameter body: (body)  
     - returns: Observable<ShoppingList>
     */
    open class func shoppingListControllerInsertNewShoppingList(body: ShoppingListFormDto) -> Observable<ShoppingList> {
        return Observable.create { observer -> Disposable in
            shoppingListControllerInsertNewShoppingList(body: body) { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     - POST /api/shopping-list
     - 

     - :
       - type: http
       - name: bearer
     - examples: [{contentType=application/json, example={
  "owner" : 6.027456183070403,
  "updated_at" : "2000-01-23T04:56:07.000+00:00",
  "created_at" : "2000-01-23T04:56:07.000+00:00",
  "id" : 0.8008281904610115,
  "requests" : [ {
    "requestId" : 1.4658129805029452
  }, {
    "requestId" : 1.4658129805029452
  } ],
  "status" : "status"
}}]
     - parameter body: (body)  

     - returns: RequestBuilder<ShoppingList> 
     */
    open class func shoppingListControllerInsertNewShoppingListWithRequestBuilder(body: ShoppingListFormDto) -> RequestBuilder<ShoppingList> {
        let path = "/api/shopping-list"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ShoppingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter body: (body)  
     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func shoppingListControllerUpdateShoppingList(body: ShoppingListFormDto, _id: Int, completion: @escaping ((_ data: ShoppingList?,_ error: Error?) -> Void)) {
        shoppingListControllerUpdateShoppingListWithRequestBuilder(body: body, _id: _id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     - parameter body: (body)  
     - parameter _id: (path)  
     - returns: Observable<ShoppingList>
     */
    open class func shoppingListControllerUpdateShoppingList(body: ShoppingListFormDto, _id: Int) -> Observable<ShoppingList> {
        return Observable.create { observer -> Disposable in
            shoppingListControllerUpdateShoppingList(body: body, _id: _id) { data, error in
                if let error = error {
                    observer.on(.error(error))
                } else {
                    observer.on(.next(data!))
                }
                observer.on(.completed)
            }
            return Disposables.create()
        }
    }

    /**
     - PUT /api/shopping-list/{id}
     - 

     - :
       - type: http
       - name: bearer
     - examples: [{contentType=application/json, example={
  "owner" : 6.027456183070403,
  "updated_at" : "2000-01-23T04:56:07.000+00:00",
  "created_at" : "2000-01-23T04:56:07.000+00:00",
  "id" : 0.8008281904610115,
  "requests" : [ {
    "requestId" : 1.4658129805029452
  }, {
    "requestId" : 1.4658129805029452
  } ],
  "status" : "status"
}}]
     - parameter body: (body)  
     - parameter _id: (path)  

     - returns: RequestBuilder<ShoppingList> 
     */
    open class func shoppingListControllerUpdateShoppingListWithRequestBuilder(body: ShoppingListFormDto, _id: Int) -> RequestBuilder<ShoppingList> {
        var path = "/api/shopping-list/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ShoppingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
