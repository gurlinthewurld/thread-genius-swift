//
//  TGClient.swift
//  TGClient
//
//  Created by Theodore Strauss on 7/17/17.
//  Copyright © 2017 Theodore Strauss. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//MARK: DEFINITION OF STRUCTURES

//MARK: -Definition of TGImage
public struct TGImage: Codable {
    var url: String? //question mark because the user could use a url OR base64 encoded string
    var base64: String? //question mark because the user could use a base64 encoded string OR url
    var crop: [CGFloat]
    
    //two init functions so that the user can use TGImage with a url and crop OR a base64 ecoded string and crop
    public init(url: String, crop: CGRect) {
        self.url = url
        self.crop = crop.toCropArray()
    }
    
    public init(image: UIImage, crop: CGRect) {
        let imageData: Data = UIImageJPEGRepresentation(image, 0.1)!
        let dataString = imageData.base64EncodedString()
        print(dataString.characters.count)
        self.base64 = dataString
        self.crop = crop.toCropArray()
    }
}

//MARK: -Definition of TGCatalog
public struct TGCatalog: Codable {
    var gid: String?
    var name: String?
    
    public init(name: String) {
        self.name = name
    }
    
    internal init(name: String, gid: String) {
        self.name = name
        self.gid = gid
    }
}

//MARK: -Definition of TGKeywords
public struct TGKeywords: Codable {
    var keywords: [String]
    
    public init(keywords: [String]) {
        self.keywords = keywords
    }
}

public struct TGObject: Codable {
    var metadata: [String : String]
    var image: TGImage
    
    public init(image: TGImage, metadata: [String : String]) {
        self.image = image
        self.metadata = metadata
    }
}

public struct TGTag {
    public var name: String
    public var confidence: Float
    
    public init(name: String, confidence: Float) {
        self.name = name
        self.confidence = confidence
    }
}

public struct TGBox {
    public var boxRect: CGRect
    
    init(boxRect: CGRect) {
        self.boxRect = boxRect
    }
}

public class ThreadGenius {
    
    //MARK: SEARCH
    
    //MARK: -Search a catalog by image URL
    public func searchFor(image: TGImage, in catalog: TGCatalog) {
        //communicate with their servers
        if let url = image.url {
            //search by url
        } else {
            //search by base64
        }
    }
    
    //MARK: -Search a catalog by keywords
    public func searchFor(keywords: TGKeywords) {
        //communicate with their servers
    }
    
    //MARK: CATALOGS
    
    //MARK: -Create a new empty catalog
    
    public func createCatalog(catalog: TGCatalog, completionHandler: @escaping (_ catalogsCreated: [TGCatalog], _ error: Error?) -> ()) {
        
        let user = "key_wcjRv0QAVgeO0ZAeq0W83tZHrIH1Y70U"
        let password = ""
        
        var headers: HTTPHeaders = ["Content-Type" : "application/json"]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        } else {
            fatalError()
        }
        
        let encoder = JSONEncoder()
        if let encodedCatalog = try? encoder.encode(catalog), let jsonCatalogString = String(data: encodedCatalog, encoding: .utf8) {
            
            let validJSONCatalogString = "{\"catalog\": "+jsonCatalogString+"}"
            print("hello", validJSONCatalogString)
            
            let validEncodedCatalog = validJSONCatalogString.data(using: .utf8)!
            var request = URLRequest(url: URL(string: "http://api-dev.threadgenius.co/v1/catalog")!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = validEncodedCatalog
            
            Alamofire.request(request).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    let someRequest = Alamofire.request(request).responseJSON
                    debugPrint("debug print:", someRequest, "end")
                    print(json)
                    print(json["status"]["description"].string ?? "")
                    if json["status"]["description"].string ?? "" == "Invalid API key." {
                        completionHandler([], TGRequestError.invalidCredentials)
                        return
                    }
                    
                    var catalogsArray = [TGCatalog]()
                    
                    if json["status"]["description"].string ?? "" == "OK" && json["response"]["catalog"]["status"]["description"].string ?? "" == "OK"{
                        var catalogStruct = TGCatalog(name: json["response"]["catalog"]["name"].string ?? "", gid: json["response"]["catalog"]["gid"].string ?? "")
                        catalogsArray.append(catalogStruct)
                    }
                    
                    completionHandler(catalogsArray, nil)
                    return
                case .failure(let error):
                    completionHandler([], error)
                    return
                }
            }
        } else {
            //tgcatalog object is not serializable
            completionHandler([], TGRequestError.invalidDataInput)
            print("TGClient: ERROR - TGCatalog is not serializable. Your TGCatalog was not able to be handled by the server. Please check your TGCatalog initialization to see if the syntax or string provided is correct.")
        }
    }

    //MARK: -List all catalogs
    public func listAllCatalogs() {
        
        let user = "key_wcjRv0QAVgeO0ZAeq0W83tZHrIH1Y70U"
        let password = ""
        
        var headers: HTTPHeaders = ["Content-Type" : "application/json"]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        } else {
            fatalError()
        }
        
        var request = URLRequest(url: URL(string: "http://api-dev.threadgenius.co/v1/catalog")!)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        Alamofire.request(request).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let catalogsJSON = json["response"]["catalogs"]
                let catalogs = catalogsJSON.array ?? [] //?? = if its nil, do this -> []
                var catalogArray = [TGCatalog]()
                var catalogCount = 0
                
                for catalog in catalogs {
                    let catalogStruct = TGCatalog(name: catalog["name"].string!)
                    catalogArray.append(catalogStruct)
                    catalogCount += 1
                }
                
                print(json)
                print("TGClient: You have \(catalogCount) catalogs associated under your user key.")
                print("TGClient: Your catalogs are \(catalogArray).")
                
                return
            case .failure(let error):
                return
            }
        }
    }
    
    //MARK: -Delete a catalog
    public func deleteCatalog(catalog: TGCatalog) {
        
        let user = "key_wcjRv0QAVgeO0ZAeq0W83tZHrIH1Y70U"
        let password = ""
        
        var headers: HTTPHeaders = ["Content-Type" : "application/json"]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        } else {
            fatalError()
        }
        
        let endpoint: String = "http://api-dev.threadgenius.co/v1/catalog/\(catalog.gid)"
        
        Alamofire.request(endpoint, method: .delete)
            .responseJSON { response in
                if let error = response.result.error {
                    print("TGClient: ERROR - TGCatalog was not able to be deleted. Please check your TGCatalog initialization to see if the syntax or string provided is correct and then try again.")
                    print(error)
                } else {
                    print("TGClient: TGCatalog was deleted successfully.")
                }
        }
    }
    
    //MARK: -Add an object to a catalog
    public func add(object: TGObject, to catalog: TGCatalog) {
                let user = "key_wcjRv0QAVgeO0ZAeq0W83tZHrIH1Y70U"
                let password = ""
        
                var headers: HTTPHeaders = ["Content-Type" : "application/json"]
        
                if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
                    headers[authorizationHeader.key] = authorizationHeader.value
                } else {
                    fatalError()
                }
        
                let encoder = JSONEncoder()
                //issue: this only encodes the contents of the struct, not the name. how will we know the name before they create it so we can wrap the encodedString in the name to make it legit
                if let encodedCatalog = try? encoder.encode(object), let jsonCatalogString = String(data: encodedCatalog, encoding: .utf8) {
                    
                    let validJSONCatalogString = "{\"objects\": "+jsonCatalogString+"}"
                    print("hello", validJSONCatalogString)
                    
                    let validEncodedCatalog = validJSONCatalogString.data(using: .utf8)!
                    var request = URLRequest(url: URL(string: "http://api-dev.threadgenius.co/v1/catalog/\(catalog.gid)/object")!)
                    request.httpMethod = "POST"
                    request.allHTTPHeaderFields = headers
                    request.httpBody = validEncodedCatalog
                    
                    Alamofire.request(request).responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            
                            let someRequest = Alamofire.request(request).responseJSON
                            debugPrint("debug print:", someRequest, "end")
                            print(json)
                            print(json["status"]["description"].string ?? "")
                            if json["status"]["description"].string ?? "" == "Invalid API key." {
                                return
                            }
                            
                            
                            return
                        case .failure(let error):
                            return
                        }
                    }
                } else {
                    //tgcatalog object is not serializable
                    print("TGClient: ERROR - TGCatalog is not serializable. Your TGCatalog was not able to be handled by the server. Please check your TGCatalog initialization to see if the syntax or string provided is correct.")
                }
    }
    
    //MARK: -Delete an object from a catalog
    public func delete(object: TGObject, from catalog: TGCatalog) {
        //communicate with their servers
    }
    
    //MARK: PREDICTION
    
    //MARK: -Predict tags via image
    public enum TGRequestError: Error {
        case invalidCredentials
        case invalidDataInput
    }
    
    //                         i pass in completionHandler and that handles what happens after the stuff runs
    public func tagImage(image: TGImage, completionHandler: @escaping (_ tags: [TGTag], _ error: Error?) -> ()) {
        
        let user = "key_wcjRv0QAVgeO0ZAeq0W83tZHrIH1Y70U"
        let password = ""
        
        var headers: HTTPHeaders = ["Content-Type" : "application/json"]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        } else {
            fatalError()
        }
        
        let encoder = JSONEncoder()
        if let encodedImage = try? encoder.encode(image), let jsonImageString = String(data: encodedImage, encoding: .utf8) {
            
            let validJSONImageString = "{\"image\": "+jsonImageString+"}"
            print("hello", validJSONImageString)
            
            
            let validEncodedImage = validJSONImageString.data(using: .utf8)!
            var request = URLRequest(url: URL(string: "http://api-dev.threadgenius.co/v1/prediction/tag")!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = validEncodedImage
            
            //they have their own completionHandler (response), so we use that instead
            Alamofire.request(request).responseJSON { response in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        
                        let someRequest = Alamofire.request(request).responseJSON
                        debugPrint("debug print:", someRequest, "end")
                        print(json)
                        print(json["status"]["description"].string ?? "")
                        if json["status"]["description"].string ?? "" == "Invalid API key." {
                            completionHandler([], TGRequestError.invalidCredentials)
                            return
                        }
                        
                        let tagsJSON = json["response"]["prediction"]["data"]["tags"]
                        let tags = tagsJSON.array ?? [] //?? = if its nil, do this -> []
                        var tagsArray = [TGTag]()
                        
                        for tag in tags {
                            var tagStruct = TGTag(name: tag["name"].string!, confidence: tag["confidence"].float!)
                            tagsArray.append(tagStruct)
                        }
                        completionHandler(tagsArray, nil)
                        return
                    case .failure(let error):
                        completionHandler([], error)
                        return
                }
            }
        } else {
            //tgimage object is not serializable
            completionHandler([], TGRequestError.invalidDataInput)
            print("TGClient: ERROR - TGImage is not serializable. Your TGImage was not able to be handled by the server. Please check your TGImage initialization to see if the URL provided or the Base64 string provided is correct.")
        }
    }
    
    //MARK: -Predict bounding boxes via image
    public func detectBoxes(view: CGSize, image: TGImage, completionHandler: @escaping (_ boxes: [TGBox], _ error: Error?) -> ()) {
        
        let user = "key_wcjRv0QAVgeO0ZAeq0W83tZHrIH1Y70U"
        let password = ""
        
        var headers: HTTPHeaders = ["Content-Type" : "application/json"]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        } else {
            fatalError()
        }
        
        let encoder = JSONEncoder()
        if let encodedImage = try? encoder.encode(image), let jsonImageString = String(data: encodedImage, encoding: .utf8) {
            let validJSONImageString = "{\"image\": " + jsonImageString + "}"
            print("hello", validJSONImageString)
            
            let validEncodedImage = validJSONImageString.data(using: .utf8)!
            var request = URLRequest(url: URL(string: "http://184.72.118.73/v1/prediction/detect")!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = validEncodedImage
            print("hi im here")
            //they have their own completionHandler (response), so we use that instead
            Alamofire.request(request).responseJSON { response in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("request", request)
                        print(json)
                        print(json["status"]["description"].string ?? "")
                        if json["status"]["description"].string ?? "" == "Invalid API key." {
                        completionHandler([], TGRequestError.invalidCredentials)
                        return
                        }
                        
                        let detections = json["response"]["prediction"]["data"]["detections"].array ?? []
                        var boxesArray = [TGBox]()
                        
                        for detection in detections {
                            let boxesJSON = detection["bbox"]
                            
                            let boxes = boxesJSON.array ?? [] //?? = if its nil, do this -> []
                            
                            let one = boxes[0]
                            let two = boxes[1]
                            let three = boxes[2]
                            let four = boxes[3]
                            
                            //TODO: change this to imageWidth and imageHeight of original for real
                            let x1 = (CGFloat(one.floatValue)) * (view.width)
                            let y1 = (CGFloat(two.floatValue)) * (view.height)
                            let x2 = (CGFloat(three.floatValue)) * (view.width)
                            let y2 = (CGFloat(four.floatValue)) * (view.height)
                            
                            let width = (x2 - x1)
                            let height = (y2 - y1)
                            
                            let rect = CGRect(x: x1, y: y1, width: width, height: height)
                            var boxesStruct = TGBox(boxRect: rect)
                            boxesArray.append(boxesStruct)
                            
                        }
                        
                        completionHandler(boxesArray, nil)
                        return
                    case .failure(let error):
                        completionHandler([], error)
                    return
                }
            }
        } else {
            //tgimage object is not serializable
            print("uh oh")
            completionHandler([], TGRequestError.invalidDataInput)
            print("TGClient: ERROR - TGImage is not serializable. Your TGImage was not able to be handled by the server. Please check your TGImage initialization to see if the URL provided or the Base64 string provided is correct.")
        }
    }
    
    private var key: String
    public init(key: String) {
        self.key = key
    }
}


//MARK: MAKE CGRECT CODABLE

extension CGRect {
    func toCropArray() -> [CGFloat] {
        return [self.origin.x/self.size.width, self.origin.y/self.size.height, (self.origin.x + self.size.width)/self.size.width, (self.origin.y + self.size.height)/self.size.height]
    }
}
