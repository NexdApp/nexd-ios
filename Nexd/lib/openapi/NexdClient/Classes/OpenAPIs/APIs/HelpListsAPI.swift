//
// HelpListsAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import RxSwift



open class HelpListsAPI {
    /**
     Add a help request to a help list
     
     - parameter helpListId: (path) Id of the help list 
     - parameter helpRequestId: (path) Id of the help request 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<HelpList>
     */
    open class func helpListsControllerAddHelpRequestToList(helpListId: Int, helpRequestId: Int, apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<HelpList> {
        return Observable.create { observer -> Disposable in
            helpListsControllerAddHelpRequestToListWithRequestBuilder(helpListId: helpListId, helpRequestId: helpRequestId).execute(apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    observer.onNext(response.body!)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    /**
     Add a help request to a help list
     - PUT /help-lists/{helpListId}/help-request/{helpRequestId}
     - BASIC:
       - type: http
       - name: bearer
     - parameter helpListId: (path) Id of the help list 
     - parameter helpRequestId: (path) Id of the help request 
     - returns: RequestBuilder<HelpList> 
     */
    open class func helpListsControllerAddHelpRequestToListWithRequestBuilder(helpListId: Int, helpRequestId: Int) -> RequestBuilder<HelpList> {
        var path = "/help-lists/{helpListId}/help-request/{helpRequestId}"
        let helpListIdPreEscape = "\(APIHelper.mapValueToPathItem(helpListId))"
        let helpListIdPostEscape = helpListIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{helpListId}", with: helpListIdPostEscape, options: .literal, range: nil)
        let helpRequestIdPreEscape = "\(APIHelper.mapValueToPathItem(helpRequestId))"
        let helpRequestIdPostEscape = helpRequestIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{helpRequestId}", with: helpRequestIdPostEscape, options: .literal, range: nil)
        let URLString = NexdClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<HelpList>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Delete a help request from help list
     
     - parameter helpListId: (path) Id of the help list 
     - parameter helpRequestId: (path) Id of the help request 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<HelpList>
     */
    open class func helpListsControllerDeleteHelpRequestFromHelpList(helpListId: Int, helpRequestId: Int, apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<HelpList> {
        return Observable.create { observer -> Disposable in
            helpListsControllerDeleteHelpRequestFromHelpListWithRequestBuilder(helpListId: helpListId, helpRequestId: helpRequestId).execute(apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    observer.onNext(response.body!)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    /**
     Delete a help request from help list
     - DELETE /help-lists/{helpListId}/help-request/{helpRequestId}
     - BASIC:
       - type: http
       - name: bearer
     - parameter helpListId: (path) Id of the help list 
     - parameter helpRequestId: (path) Id of the help request 
     - returns: RequestBuilder<HelpList> 
     */
    open class func helpListsControllerDeleteHelpRequestFromHelpListWithRequestBuilder(helpListId: Int, helpRequestId: Int) -> RequestBuilder<HelpList> {
        var path = "/help-lists/{helpListId}/help-request/{helpRequestId}"
        let helpListIdPreEscape = "\(APIHelper.mapValueToPathItem(helpListId))"
        let helpListIdPostEscape = helpListIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{helpListId}", with: helpListIdPostEscape, options: .literal, range: nil)
        let helpRequestIdPreEscape = "\(APIHelper.mapValueToPathItem(helpRequestId))"
        let helpRequestIdPostEscape = helpRequestIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{helpRequestId}", with: helpRequestIdPostEscape, options: .literal, range: nil)
        let URLString = NexdClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<HelpList>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get a specific help list
     
     - parameter helpListId: (path) Id of the help list 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<HelpList>
     */
    open class func helpListsControllerFindOne(helpListId: Int64, apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<HelpList> {
        return Observable.create { observer -> Disposable in
            helpListsControllerFindOneWithRequestBuilder(helpListId: helpListId).execute(apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    observer.onNext(response.body!)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    /**
     Get a specific help list
     - GET /help-lists/{helpListId}
     - BASIC:
       - type: http
       - name: bearer
     - parameter helpListId: (path) Id of the help list 
     - returns: RequestBuilder<HelpList> 
     */
    open class func helpListsControllerFindOneWithRequestBuilder(helpListId: Int64) -> RequestBuilder<HelpList> {
        var path = "/help-lists/{helpListId}"
        let helpListIdPreEscape = "\(APIHelper.mapValueToPathItem(helpListId))"
        let helpListIdPostEscape = helpListIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{helpListId}", with: helpListIdPostEscape, options: .literal, range: nil)
        let URLString = NexdClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<HelpList>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get help lists of the requesting user
     
     - parameter userId: (query) If included, filter by userId, otherwise by requesting user. (optional)
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<[HelpList]>
     */
    open class func helpListsControllerGetUserLists(userId: String? = nil, apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<[HelpList]> {
        return Observable.create { observer -> Disposable in
            helpListsControllerGetUserListsWithRequestBuilder(userId: userId).execute(apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    observer.onNext(response.body!)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    /**
     Get help lists of the requesting user
     - GET /help-lists
     - BASIC:
       - type: http
       - name: bearer
     - parameter userId: (query) If included, filter by userId, otherwise by requesting user. (optional)
     - returns: RequestBuilder<[HelpList]> 
     */
    open class func helpListsControllerGetUserListsWithRequestBuilder(userId: String? = nil) -> RequestBuilder<[HelpList]> {
        let path = "/help-lists"
        let URLString = NexdClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "userId": userId?.encodeToJSON()
        ])

        let requestBuilder: RequestBuilder<[HelpList]>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Add a new help list for the current user
     
     - parameter helpListCreateDto: (body)  
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<HelpList>
     */
    open class func helpListsControllerInsertNewHelpList(helpListCreateDto: HelpListCreateDto, apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<HelpList> {
        return Observable.create { observer -> Disposable in
            helpListsControllerInsertNewHelpListWithRequestBuilder(helpListCreateDto: helpListCreateDto).execute(apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    observer.onNext(response.body!)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    /**
     Add a new help list for the current user
     - POST /help-lists
     - BASIC:
       - type: http
       - name: bearer
     - parameter helpListCreateDto: (body)  
     - returns: RequestBuilder<HelpList> 
     */
    open class func helpListsControllerInsertNewHelpListWithRequestBuilder(helpListCreateDto: HelpListCreateDto) -> RequestBuilder<HelpList> {
        let path = "/help-lists"
        let URLString = NexdClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: helpListCreateDto)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<HelpList>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Set/unset article done in all help requests
     
     - parameter articleDone: (query) true to set the article as \&quot;bought\&quot; 
     - parameter helpListId: (path) Id of the help list 
     - parameter articleId: (path) Id of the article 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<HelpList>
     */
    open class func helpListsControllerModifyArticleInAllHelpRequests(articleDone: Bool, helpListId: Int, articleId: Int64, apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<HelpList> {
        return Observable.create { observer -> Disposable in
            helpListsControllerModifyArticleInAllHelpRequestsWithRequestBuilder(articleDone: articleDone, helpListId: helpListId, articleId: articleId).execute(apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    observer.onNext(response.body!)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    /**
     Set/unset article done in all help requests
     - PUT /help-lists/{helpListId}/article/{articleId}
     - BASIC:
       - type: http
       - name: bearer
     - parameter articleDone: (query) true to set the article as \&quot;bought\&quot; 
     - parameter helpListId: (path) Id of the help list 
     - parameter articleId: (path) Id of the article 
     - returns: RequestBuilder<HelpList> 
     */
    open class func helpListsControllerModifyArticleInAllHelpRequestsWithRequestBuilder(articleDone: Bool, helpListId: Int, articleId: Int64) -> RequestBuilder<HelpList> {
        var path = "/help-lists/{helpListId}/article/{articleId}"
        let helpListIdPreEscape = "\(APIHelper.mapValueToPathItem(helpListId))"
        let helpListIdPostEscape = helpListIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{helpListId}", with: helpListIdPostEscape, options: .literal, range: nil)
        let articleIdPreEscape = "\(APIHelper.mapValueToPathItem(articleId))"
        let articleIdPostEscape = articleIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{articleId}", with: articleIdPostEscape, options: .literal, range: nil)
        let URLString = NexdClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "articleDone": articleDone.encodeToJSON()
        ])

        let requestBuilder: RequestBuilder<HelpList>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Set/unset articleDone of an article in a specific help request
     
     - parameter articleDone: (query) true to set the article as \&quot;bought\&quot; 
     - parameter helpListId: (path) Id of the help list 
     - parameter helpRequestId: (path) Id of the help request 
     - parameter articleId: (path) Id of the article 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<HelpList>
     */
    open class func helpListsControllerModifyArticleInHelpRequest(articleDone: Bool, helpListId: Int, helpRequestId: Int, articleId: Int, apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<HelpList> {
        return Observable.create { observer -> Disposable in
            helpListsControllerModifyArticleInHelpRequestWithRequestBuilder(articleDone: articleDone, helpListId: helpListId, helpRequestId: helpRequestId, articleId: articleId).execute(apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    observer.onNext(response.body!)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    /**
     Set/unset articleDone of an article in a specific help request
     - PUT /help-lists/{helpListId}/help-request/{helpRequestId}/article/{articleId}
     - BASIC:
       - type: http
       - name: bearer
     - parameter articleDone: (query) true to set the article as \&quot;bought\&quot; 
     - parameter helpListId: (path) Id of the help list 
     - parameter helpRequestId: (path) Id of the help request 
     - parameter articleId: (path) Id of the article 
     - returns: RequestBuilder<HelpList> 
     */
    open class func helpListsControllerModifyArticleInHelpRequestWithRequestBuilder(articleDone: Bool, helpListId: Int, helpRequestId: Int, articleId: Int) -> RequestBuilder<HelpList> {
        var path = "/help-lists/{helpListId}/help-request/{helpRequestId}/article/{articleId}"
        let helpListIdPreEscape = "\(APIHelper.mapValueToPathItem(helpListId))"
        let helpListIdPostEscape = helpListIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{helpListId}", with: helpListIdPostEscape, options: .literal, range: nil)
        let helpRequestIdPreEscape = "\(APIHelper.mapValueToPathItem(helpRequestId))"
        let helpRequestIdPostEscape = helpRequestIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{helpRequestId}", with: helpRequestIdPostEscape, options: .literal, range: nil)
        let articleIdPreEscape = "\(APIHelper.mapValueToPathItem(articleId))"
        let articleIdPostEscape = articleIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{articleId}", with: articleIdPostEscape, options: .literal, range: nil)
        let URLString = NexdClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "articleDone": articleDone.encodeToJSON()
        ])

        let requestBuilder: RequestBuilder<HelpList>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Modify a help list
     
     - parameter helpListId: (path) Id of the help list 
     - parameter helpListCreateDto: (body)  
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<HelpList>
     */
    open class func helpListsControllerUpdateHelpLists(helpListId: Int, helpListCreateDto: HelpListCreateDto, apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<HelpList> {
        return Observable.create { observer -> Disposable in
            helpListsControllerUpdateHelpListsWithRequestBuilder(helpListId: helpListId, helpListCreateDto: helpListCreateDto).execute(apiResponseQueue) { result -> Void in
                switch result {
                case let .success(response):
                    observer.onNext(response.body!)
                case let .failure(error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

    /**
     Modify a help list
     - PUT /help-lists/{helpListId}
     - BASIC:
       - type: http
       - name: bearer
     - parameter helpListId: (path) Id of the help list 
     - parameter helpListCreateDto: (body)  
     - returns: RequestBuilder<HelpList> 
     */
    open class func helpListsControllerUpdateHelpListsWithRequestBuilder(helpListId: Int, helpListCreateDto: HelpListCreateDto) -> RequestBuilder<HelpList> {
        var path = "/help-lists/{helpListId}"
        let helpListIdPreEscape = "\(APIHelper.mapValueToPathItem(helpListId))"
        let helpListIdPostEscape = helpListIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{helpListId}", with: helpListIdPostEscape, options: .literal, range: nil)
        let URLString = NexdClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: helpListCreateDto)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<HelpList>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
