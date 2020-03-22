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

     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func shoppingListControllerFindOne(_id: Int, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        shoppingListControllerFindOneWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }

    /**
     - parameter _id: (path)  
     - returns: Observable<Void>
     */
    open class func shoppingListControllerFindOne(_id: Int) -> Observable<Void> {
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
     - parameter _id: (path)  

     - returns: RequestBuilder<Void> 
     */
    open class func shoppingListControllerFindOneWithRequestBuilder(_id: Int) -> RequestBuilder<Void> {
        var path = "/api/shopping-list/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func shoppingListControllerGetUserLists(completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        shoppingListControllerGetUserListsWithRequestBuilder().execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }

    /**
     - returns: Observable<Void>
     */
    open class func shoppingListControllerGetUserLists() -> Observable<Void> {
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

     - returns: RequestBuilder<Void> 
     */
    open class func shoppingListControllerGetUserListsWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/api/shopping-list"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter body: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func shoppingListControllerInsertNewShoppingList(body: CreateShoppingListDto, completion: @escaping ((_ data: ShoppingList?,_ error: Error?) -> Void)) {
        shoppingListControllerInsertNewShoppingListWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     - parameter body: (body)  
     - returns: Observable<ShoppingList>
     */
    open class func shoppingListControllerInsertNewShoppingList(body: CreateShoppingListDto) -> Observable<ShoppingList> {
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
  "id" : 0.8008281904610115,
  "requests" : [ { }, { } ],
  "status" : "status"
}}]
     - parameter body: (body)  

     - returns: RequestBuilder<ShoppingList> 
     */
    open class func shoppingListControllerInsertNewShoppingListWithRequestBuilder(body: CreateShoppingListDto) -> RequestBuilder<ShoppingList> {
        let path = "/api/shopping-list"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<ShoppingList>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}