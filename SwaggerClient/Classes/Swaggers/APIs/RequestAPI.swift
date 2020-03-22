//
// RequestAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire
import RxSwift


open class RequestAPI {
    /**

     - parameter onlyMine: (query) if \&quot;true\&quot;, only the requesting user requests will be replied. (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func requestControllerGetAll(onlyMine: String? = nil, completion: @escaping ((_ data: [RequestEntity]?,_ error: Error?) -> Void)) {
        requestControllerGetAllWithRequestBuilder(onlyMine: onlyMine).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     - parameter onlyMine: (query) if \&quot;true\&quot;, only the requesting user requests will be replied. (optional)
     - returns: Observable<[RequestEntity]>
     */
    open class func requestControllerGetAll(onlyMine: String? = nil) -> Observable<[RequestEntity]> {
        return Observable.create { observer -> Disposable in
            requestControllerGetAll(onlyMine: onlyMine) { data, error in
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
     - GET /api/request
     - 

     - :
       - type: http
       - name: bearer
     - examples: [{contentType=application/json, example=[ {
  "requester" : {
    "number" : "number",
    "zipCode" : "zipCode",
    "firstName" : "firstName",
    "lastName" : "lastName",
    "role" : "role",
    "city" : "city",
    "street" : "street",
    "telephone" : "telephone",
    "email" : "email"
  },
  "zipCode" : "zipCode",
  "requesterId" : 6,
  "city" : "city",
  "additionalRequest" : "additionalRequest",
  "deliveryComment" : "deliveryComment",
  "created_at" : "2000-01-23T04:56:07.000+00:00",
  "priority" : "priority",
  "number" : "number",
  "phoneNumber" : "phoneNumber",
  "street" : "street",
  "id" : 0,
  "articles" : [ {
    "articleDone" : true,
    "articleId" : 1.4658129805029452,
    "articleCount" : 5.962133916683182
  }, {
    "articleDone" : true,
    "articleId" : 1.4658129805029452,
    "articleCount" : 5.962133916683182
  } ],
  "status" : "status"
}, {
  "requester" : {
    "number" : "number",
    "zipCode" : "zipCode",
    "firstName" : "firstName",
    "lastName" : "lastName",
    "role" : "role",
    "city" : "city",
    "street" : "street",
    "telephone" : "telephone",
    "email" : "email"
  },
  "zipCode" : "zipCode",
  "requesterId" : 6,
  "city" : "city",
  "additionalRequest" : "additionalRequest",
  "deliveryComment" : "deliveryComment",
  "created_at" : "2000-01-23T04:56:07.000+00:00",
  "priority" : "priority",
  "number" : "number",
  "phoneNumber" : "phoneNumber",
  "street" : "street",
  "id" : 0,
  "articles" : [ {
    "articleDone" : true,
    "articleId" : 1.4658129805029452,
    "articleCount" : 5.962133916683182
  }, {
    "articleDone" : true,
    "articleId" : 1.4658129805029452,
    "articleCount" : 5.962133916683182
  } ],
  "status" : "status"
} ]}]
     - parameter onlyMine: (query) if \&quot;true\&quot;, only the requesting user requests will be replied. (optional)

     - returns: RequestBuilder<[RequestEntity]> 
     */
    open class func requestControllerGetAllWithRequestBuilder(onlyMine: String? = nil) -> RequestBuilder<[RequestEntity]> {
        let path = "/api/request"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
                        "onlyMine": onlyMine
        ])

        let requestBuilder: RequestBuilder<[RequestEntity]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter requestId: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func requestControllerGetSingleRequest(requestId: Int, completion: @escaping ((_ data: RequestEntity?,_ error: Error?) -> Void)) {
        requestControllerGetSingleRequestWithRequestBuilder(requestId: requestId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     - parameter requestId: (path)  
     - returns: Observable<RequestEntity>
     */
    open class func requestControllerGetSingleRequest(requestId: Int) -> Observable<RequestEntity> {
        return Observable.create { observer -> Disposable in
            requestControllerGetSingleRequest(requestId: requestId) { data, error in
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
     - GET /api/request/{requestId}
     - 

     - :
       - type: http
       - name: bearer
     - examples: [{contentType=application/json, example={
  "requester" : {
    "number" : "number",
    "zipCode" : "zipCode",
    "firstName" : "firstName",
    "lastName" : "lastName",
    "role" : "role",
    "city" : "city",
    "street" : "street",
    "telephone" : "telephone",
    "email" : "email"
  },
  "zipCode" : "zipCode",
  "requesterId" : 6,
  "city" : "city",
  "additionalRequest" : "additionalRequest",
  "deliveryComment" : "deliveryComment",
  "created_at" : "2000-01-23T04:56:07.000+00:00",
  "priority" : "priority",
  "number" : "number",
  "phoneNumber" : "phoneNumber",
  "street" : "street",
  "id" : 0,
  "articles" : [ {
    "articleDone" : true,
    "articleId" : 1.4658129805029452,
    "articleCount" : 5.962133916683182
  }, {
    "articleDone" : true,
    "articleId" : 1.4658129805029452,
    "articleCount" : 5.962133916683182
  } ],
  "status" : "status"
}}]
     - parameter requestId: (path)  

     - returns: RequestBuilder<RequestEntity> 
     */
    open class func requestControllerGetSingleRequestWithRequestBuilder(requestId: Int) -> RequestBuilder<RequestEntity> {
        var path = "/api/request/{requestId}"
        let requestIdPreEscape = "\(requestId)"
        let requestIdPostEscape = requestIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{requestId}", with: requestIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<RequestEntity>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter body: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func requestControllerInsertRequestWithArticles(body: RequestFormDto, completion: @escaping ((_ data: RequestEntity?,_ error: Error?) -> Void)) {
        requestControllerInsertRequestWithArticlesWithRequestBuilder(body: body).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     - parameter body: (body)  
     - returns: Observable<RequestEntity>
     */
    open class func requestControllerInsertRequestWithArticles(body: RequestFormDto) -> Observable<RequestEntity> {
        return Observable.create { observer -> Disposable in
            requestControllerInsertRequestWithArticles(body: body) { data, error in
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
     - POST /api/request
     - 

     - :
       - type: http
       - name: bearer
     - examples: [{contentType=application/json, example={
  "requester" : {
    "number" : "number",
    "zipCode" : "zipCode",
    "firstName" : "firstName",
    "lastName" : "lastName",
    "role" : "role",
    "city" : "city",
    "street" : "street",
    "telephone" : "telephone",
    "email" : "email"
  },
  "zipCode" : "zipCode",
  "requesterId" : 6,
  "city" : "city",
  "additionalRequest" : "additionalRequest",
  "deliveryComment" : "deliveryComment",
  "created_at" : "2000-01-23T04:56:07.000+00:00",
  "priority" : "priority",
  "number" : "number",
  "phoneNumber" : "phoneNumber",
  "street" : "street",
  "id" : 0,
  "articles" : [ {
    "articleDone" : true,
    "articleId" : 1.4658129805029452,
    "articleCount" : 5.962133916683182
  }, {
    "articleDone" : true,
    "articleId" : 1.4658129805029452,
    "articleCount" : 5.962133916683182
  } ],
  "status" : "status"
}}]
     - parameter body: (body)  

     - returns: RequestBuilder<RequestEntity> 
     */
    open class func requestControllerInsertRequestWithArticlesWithRequestBuilder(body: RequestFormDto) -> RequestBuilder<RequestEntity> {
        let path = "/api/request"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<RequestEntity>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter body: (body)  
     - parameter requestId: (path)  
     - parameter articleId: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func requestControllerMarkArticleAsDone(body: RequestArticleStatusDto, requestId: Int, articleId: Int, completion: @escaping ((_ data: RequestEntity?,_ error: Error?) -> Void)) {
        requestControllerMarkArticleAsDoneWithRequestBuilder(body: body, requestId: requestId, articleId: articleId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     - parameter body: (body)  
     - parameter requestId: (path)  
     - parameter articleId: (path)  
     - returns: Observable<RequestEntity>
     */
    open class func requestControllerMarkArticleAsDone(body: RequestArticleStatusDto, requestId: Int, articleId: Int) -> Observable<RequestEntity> {
        return Observable.create { observer -> Disposable in
            requestControllerMarkArticleAsDone(body: body, requestId: requestId, articleId: articleId) { data, error in
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
     - PUT /api/request/{requestId}/{articleId}
     - 

     - :
       - type: http
       - name: bearer
     - examples: [{contentType=application/json, example={
  "requester" : {
    "number" : "number",
    "zipCode" : "zipCode",
    "firstName" : "firstName",
    "lastName" : "lastName",
    "role" : "role",
    "city" : "city",
    "street" : "street",
    "telephone" : "telephone",
    "email" : "email"
  },
  "zipCode" : "zipCode",
  "requesterId" : 6,
  "city" : "city",
  "additionalRequest" : "additionalRequest",
  "deliveryComment" : "deliveryComment",
  "created_at" : "2000-01-23T04:56:07.000+00:00",
  "priority" : "priority",
  "number" : "number",
  "phoneNumber" : "phoneNumber",
  "street" : "street",
  "id" : 0,
  "articles" : [ {
    "articleDone" : true,
    "articleId" : 1.4658129805029452,
    "articleCount" : 5.962133916683182
  }, {
    "articleDone" : true,
    "articleId" : 1.4658129805029452,
    "articleCount" : 5.962133916683182
  } ],
  "status" : "status"
}}]
     - parameter body: (body)  
     - parameter requestId: (path)  
     - parameter articleId: (path)  

     - returns: RequestBuilder<RequestEntity> 
     */
    open class func requestControllerMarkArticleAsDoneWithRequestBuilder(body: RequestArticleStatusDto, requestId: Int, articleId: Int) -> RequestBuilder<RequestEntity> {
        var path = "/api/request/{requestId}/{articleId}"
        let requestIdPreEscape = "\(requestId)"
        let requestIdPostEscape = requestIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{requestId}", with: requestIdPostEscape, options: .literal, range: nil)
        let articleIdPreEscape = "\(articleId)"
        let articleIdPostEscape = articleIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{articleId}", with: articleIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<RequestEntity>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter body: (body)  
     - parameter requestId: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func requestControllerUpdateRequest(body: RequestFormDto, requestId: Int, completion: @escaping ((_ data: RequestEntity?,_ error: Error?) -> Void)) {
        requestControllerUpdateRequestWithRequestBuilder(body: body, requestId: requestId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }

    /**
     - parameter body: (body)  
     - parameter requestId: (path)  
     - returns: Observable<RequestEntity>
     */
    open class func requestControllerUpdateRequest(body: RequestFormDto, requestId: Int) -> Observable<RequestEntity> {
        return Observable.create { observer -> Disposable in
            requestControllerUpdateRequest(body: body, requestId: requestId) { data, error in
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
     - PUT /api/request/{requestId}
     - 

     - :
       - type: http
       - name: bearer
     - examples: [{contentType=application/json, example={
  "requester" : {
    "number" : "number",
    "zipCode" : "zipCode",
    "firstName" : "firstName",
    "lastName" : "lastName",
    "role" : "role",
    "city" : "city",
    "street" : "street",
    "telephone" : "telephone",
    "email" : "email"
  },
  "zipCode" : "zipCode",
  "requesterId" : 6,
  "city" : "city",
  "additionalRequest" : "additionalRequest",
  "deliveryComment" : "deliveryComment",
  "created_at" : "2000-01-23T04:56:07.000+00:00",
  "priority" : "priority",
  "number" : "number",
  "phoneNumber" : "phoneNumber",
  "street" : "street",
  "id" : 0,
  "articles" : [ {
    "articleDone" : true,
    "articleId" : 1.4658129805029452,
    "articleCount" : 5.962133916683182
  }, {
    "articleDone" : true,
    "articleId" : 1.4658129805029452,
    "articleCount" : 5.962133916683182
  } ],
  "status" : "status"
}}]
     - parameter body: (body)  
     - parameter requestId: (path)  

     - returns: RequestBuilder<RequestEntity> 
     */
    open class func requestControllerUpdateRequestWithRequestBuilder(body: RequestFormDto, requestId: Int) -> RequestBuilder<RequestEntity> {
        var path = "/api/request/{requestId}"
        let requestIdPreEscape = "\(requestId)"
        let requestIdPostEscape = requestIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{requestId}", with: requestIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: body)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<RequestEntity>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
