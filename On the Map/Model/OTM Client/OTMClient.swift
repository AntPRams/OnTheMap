//
//  OTMClient.swift
//  On the Map
//
//  Created by António Ramos on 23/06/2019.
//  Copyright © 2019 António Ramos. All rights reserved.
//

import Foundation
import UIKit

class OTMClient {
    
    //MARK: Task Methods
    
    
    class func taskForGETrequest<ResponseType: Decodable> (udacityAPI: Bool, url: URL, response: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?)-> Void) {
        
        let task = URLSession.shared.dataTask(with: url) {
            
            (data, response, error) in
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            let newData = data
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: handleData(data: newData, ifIs: udacityAPI))
                DispatchQueue.main.async {
                    completionHandler(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: handleData(data: newData, ifIs: udacityAPI)) as Error
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForPOSTorPUTrequest<RequestType: Encodable, ResponseType: Decodable> (udacityAPI: Bool, httpMethod: String, url: URL, response: ResponseType.Type, body: RequestType, completionHandler: @escaping (ResponseType?, Error?) -> Void){
        
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            let newData = data
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: handleData(data: newData, ifIs: udacityAPI))
                DispatchQueue.main.async {
                    completionHandler(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: handleData(data: newData, ifIs: udacityAPI)) as Error
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForDELETERequest(completionHandler: @escaping() -> Void) {
        
        guard let sessionId = Credentials.sessionId, let expiration = Credentials.expirationDate else {return}
        var request = URLRequest(url: EndPoints.login.url)
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        let body = DeleteRequest(
            session: LogoutSession(
                sessionId:  sessionId,
                expiration: expiration)
        )
        
        request.httpMethod = "DELETE"
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {return}
            Credentials.expirationDate = nil
            Credentials.sessionId =      nil
            Credentials.accountId =      nil
            
            let decoder = JSONDecoder()
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let _ = try? decoder.decode(DeleteRequest.self, from: newData)
            completionHandler()
        }
        task.resume()
    }
    
    //MARK: Methods to comunicate with the API
    
    class func login(username: String, password: String, completionHandler: @escaping(Bool, Error?) -> Void) {
        
        let body = LoginRequest(
            credentials: LoginCredentials(
                username: username,
                password: password
            )
        )
        
        taskForPOSTorPUTrequest(udacityAPI: true,
                                httpMethod:   "POST",
                                url:          EndPoints.login.url,
                                response:     LoginResponse.self,
                                body:         body
            
        ) { response, error in
            
            if let response = response {
                Credentials.accountId =      response.account.accountId
                Credentials.sessionId =      response.session.sessionId
                Credentials.expirationDate = response.session.expiration
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
            }
        }
    }
    
    class func getStudentLocations(completionHandler: @escaping([StudentLocation], Error?) -> Void){
        
        taskForGETrequest(
            udacityAPI: false,
            url:          EndPoints.getStudentLocations.url,
            response:     StudentLocationsRequest.self
            
        ) { (response, error) in
            
            if let response = response {
                Locations.shared.list = response.results
                DispatchQueue.main.async {
                    completionHandler(response.results, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler([], error)
                }
            }
        }
    }
    
    class func getUserDetails(completionHandler: @escaping (Error?)-> Void) {
        
        if let accountID = Credentials.accountId {
            
            taskForGETrequest(
                udacityAPI: true,
                url:          EndPoints.getUserDummyInfo(accountID).url,
                response:     UserInfo.self
                
            ) { (response, error) in
                
                if let response = response {
                    
                    guard let firstName = response.firstName, let lastName = response.lastName else {return}
                    
                    DummyInfo.firstName = firstName
                    DummyInfo.lastName = lastName
                    DispatchQueue.main.async {
                        completionHandler(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completionHandler(error)
                    }
                }
            }
        }
    }
    
    class func postLocation(completionHandler: @escaping (Bool, Error?) ->Void) {
        
        taskForPOSTorPUTrequest(
            udacityAPI: false,
            httpMethod: "POST",
            url:        EndPoints.postStudentLocation.url,
            response:   PostLocationResponse.self,
            body:       bodyForPostLocation()
            
        ) { (response, error) in
            
            if let response = response {
                Credentials.objectId = response.objectId
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
            }
        }
    }
    
    class func putLocation(completionHandler: @escaping (Bool, Error?) ->Void) {
        
        taskForPOSTorPUTrequest(
            
            udacityAPI: false,
            httpMethod: "PUT",
            url:        EndPoints.putUserLocation.url,
            response:   PutRequestResponse.self,
            body:       bodyForPostLocation()
            
        ) { (response, error) in
            
            if let _ = response {
                DispatchQueue.main.async {
                    completionHandler(true, nil)
                }
            } else {
                DispatchQueue.main.async {
                   completionHandler(false, error)
                }
            }
        }
    }
    
    //Set body to post/put my location
    class func bodyForPostLocation() -> StudentLocation {
        return StudentLocation(
            
            objectId:  Credentials.objectId,
            uniqueKey: Credentials.accountId,
            firstName: DummyInfo.firstName,
            lastName:  DummyInfo.lastName,
            mapString: DummyInfo.mapString,
            mediaURL:  DummyInfo.mediaUrl,
            latitude:  DummyInfo.latitude,
            longitude: DummyInfo.longitude)
    }
    
    //This method was created to avoid repetitions in both methods on which is used
    
    class func handleData(data: Data, ifIs: Bool) -> Data {
        var newData = data
        
        switch ifIs {
        case true:
            let range = 5..<data.count
            newData = data.subdata(in: range)
        case false:
            newData = data
        }
        
        return newData
    }
}
