//
// UsersAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
import RxSwift



open class UsersAPI {
    /**
     Get user profile of the requesting user
     
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<User>
     */
    open class func userControllerFindMe(apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<User> {
        return Observable.create { observer -> Disposable in
            userControllerFindMeWithRequestBuilder().execute(apiResponseQueue) { result -> Void in
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
     Get user profile of the requesting user
     - GET /users/me
     - BASIC:
       - type: http
       - name: bearer
     - returns: RequestBuilder<User> 
     */
    open class func userControllerFindMeWithRequestBuilder() -> RequestBuilder<User> {
        let path = "/users/me"
        let URLString = NexdClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<User>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get user profile of a specific user
     
     - parameter userId: (path) user id 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<User>
     */
    open class func userControllerFindOne(userId: String, apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<User> {
        return Observable.create { observer -> Disposable in
            userControllerFindOneWithRequestBuilder(userId: userId).execute(apiResponseQueue) { result -> Void in
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
     Get user profile of a specific user
     - GET /users/{userId}
     - BASIC:
       - type: http
       - name: bearer
     - parameter userId: (path) user id 
     - returns: RequestBuilder<User> 
     */
    open class func userControllerFindOneWithRequestBuilder(userId: String) -> RequestBuilder<User> {
        var path = "/users/{userId}"
        let userIdPreEscape = "\(APIHelper.mapValueToPathItem(userId))"
        let userIdPostEscape = userIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{userId}", with: userIdPostEscape, options: .literal, range: nil)
        let URLString = NexdClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<User>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**
     Get all users
     
     - parameter xAdminSecret: (header) Secret to access the admin functions. 
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<[User]>
     */
    open class func userControllerGetAll(xAdminSecret: String, apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<[User]> {
        return Observable.create { observer -> Disposable in
            userControllerGetAllWithRequestBuilder(xAdminSecret: xAdminSecret).execute(apiResponseQueue) { result -> Void in
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
     Get all users
     - GET /users
     - BASIC:
       - type: http
       - name: bearer
     - parameter xAdminSecret: (header) Secret to access the admin functions. 
     - returns: RequestBuilder<[User]> 
     */
    open class func userControllerGetAllWithRequestBuilder(xAdminSecret: String) -> RequestBuilder<[User]> {
        let path = "/users"
        let URLString = NexdClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "x-admin-secret": xAdminSecret.encodeToJSON()
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<[User]>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     Update profile of a specific user
     
     - parameter userId: (path) user id 
     - parameter updateUserDto: (body)  
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<User>
     */
    open class func userControllerUpdate(userId: String, updateUserDto: UpdateUserDto, apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<User> {
        return Observable.create { observer -> Disposable in
            userControllerUpdateWithRequestBuilder(userId: userId, updateUserDto: updateUserDto).execute(apiResponseQueue) { result -> Void in
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
     Update profile of a specific user
     - PUT /users/{userId}
     - BASIC:
       - type: http
       - name: bearer
     - parameter userId: (path) user id 
     - parameter updateUserDto: (body)  
     - returns: RequestBuilder<User> 
     */
    open class func userControllerUpdateWithRequestBuilder(userId: String, updateUserDto: UpdateUserDto) -> RequestBuilder<User> {
        var path = "/users/{userId}"
        let userIdPreEscape = "\(APIHelper.mapValueToPathItem(userId))"
        let userIdPostEscape = userIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{userId}", with: userIdPostEscape, options: .literal, range: nil)
        let URLString = NexdClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: updateUserDto)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<User>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**
     Update profile of the requesting user
     
     - parameter updateUserDto: (body)  
     - parameter apiResponseQueue: The queue on which api response is dispatched.
     - returns: Observable<User>
     */
    open class func userControllerUpdateMyself(updateUserDto: UpdateUserDto, apiResponseQueue: DispatchQueue = NexdClientAPI.apiResponseQueue) -> Observable<User> {
        return Observable.create { observer -> Disposable in
            userControllerUpdateMyselfWithRequestBuilder(updateUserDto: updateUserDto).execute(apiResponseQueue) { result -> Void in
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
     Update profile of the requesting user
     - PUT /users/me
     - BASIC:
       - type: http
       - name: bearer
     - parameter updateUserDto: (body)  
     - returns: RequestBuilder<User> 
     */
    open class func userControllerUpdateMyselfWithRequestBuilder(updateUserDto: UpdateUserDto) -> RequestBuilder<User> {
        let path = "/users/me"
        let URLString = NexdClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: updateUserDto)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<User>.Type = NexdClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
