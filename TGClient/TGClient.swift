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
    
    public init(base64: String, crop: CGRect) {
        self.base64 = base64
        self.crop = crop.toCropArray()
    }
}

//MARK: -Definition of TGCatalog
public struct TGCatalog: Codable {
    var gid: String? //question mark because the user could use a gid OR name
    var name: String? //question mark because the user could use a gid OR name
    
    //two init functions so that the user can use TGCatalog with a gid OR a name
    public init(gid: String) {
        self.gid = gid
    }
    
    public init(name: String) {
        self.name = name
    }
}

//MARK: -Definition of TGKeywords
public struct TGKeywords: Codable {
    var keywords: [String]
    
    public init(keywords: [String]) {
        self.keywords = keywords
    }
}

public struct TGMetadata: Codable {
    var brand: String
    var hashtags: [String]
    
    public init(brand: String, hashtags: [String]) {
        self.brand = brand
        self.hashtags = hashtags
    }
}

public struct TGObject: Codable {
    var metadata: TGMetadata
    var image: TGImage
    
    public init(image: TGImage, metadata: TGMetadata) {
        self.image = image
        self.metadata = metadata
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
    public func searchBy(keywords: TGKeywords) {
        //communicate with their servers
    }
    
    //MARK: CATALOGS
    
    //MARK: -Create a new empty catalog
    public func createCatalog(name: TGCatalog) {
        //communicate with their servers
    }
    
    //MARK: -List all catalogs
    public func listAllCatalogs() {
        //communicate with their servers
    }
    
    //MARK: -Delete a catalog
    public func deleteCatalog(gid: String) {
        //communicate with their servers
    }
    
    //MARK: -Clear a catalog
    public func clearCatalog(gid: String) {
        //communicate with their servers
    }
    
    //MARK: -Add an object to a catalog
    public func addObject(object: TGObject, in catalog: TGCatalog) {
        //communicate with their servers
    }
    
    //MARK: -Delete an object from a catalog
    public func delete(object: TGObject, from catalog: TGCatalog) {
        //communicate with their servers
    }
    
    //MARK: PREDICTION
    
    //MARK: -Predict tags via image
    public func tagImage(image: TGImage) {
        
        let user = "key_wcjRv0QAVgeO0ZAeq0W83tZHrIH1Y70U"
        let password = ""
        
        var headers: HTTPHeaders = ["Content-Type" : "application/json"]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        } else {
            //indicate credentials are somehow wrong
            return
        }
        
        let encoder = JSONEncoder()
        if let encodedImage = try? encoder.encode(image), let jsonImageString = String(data: encodedImage, encoding: .utf8) {
            let validJSONImageString = "{\"image\": "+jsonImageString+"}"
            print("hello: \(validJSONImageString)")
            let validEncodedImage = validJSONImageString.data(using: .utf8)!
            // use `jsonImage` somewhere
            var request = URLRequest(url: URL(string: "http://api-dev.threadgenius.co/v1/prediction/tag")!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headers
            request.httpBody = validEncodedImage
            
            print("hi: \(request)")
            
            Alamofire.request(request).responseJSON { response in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("JSON: \(json)")
                    
                        let tagsJSON: JSON = json[0]["response"]["prediction"]["data"]["features"]["tags"]
                        let tags = tagsJSON.array
                        
                        var tagConfidence: JSON = json[0]["response"]["prediction"]["data"]["features"]["tags"]["confidence"]
                        var tagName: JSON = json[0]["response"]["prediction"]["data"]["features"]["tags"]["name"]
                        var tagType: JSON = json[0]["response"]["prediction"]["data"]["features"]["tags"]["type"]
                        let confidence = tagConfidence.string
                        let name = tagName.string
                        let type = tagType.string
                    
                        let confidenceArray = [confidence]
                        let nameArray = [name]
                        let typeArray = [type]
                    
                        print("here it is confidence \(confidenceArray)")
                        print("here it is name \(nameArray)")
                        print("here it is type \(typeArray)")
                    
                    case .failure(let error):
                        print(error)
                }
            }
        } else {
            //tgimage object is not serializable
        }
    }
    
    //MARK: -Predict tags via image URLs
    public func tagImages(images: [TGImage]) {
        //communicate with their servers
    }
    
    //MARK: -Predict bounding boxes via image
    public func detectBoxes(image: TGImage) {
        //communicate with their servers
    }
    
    public func getPredictions() {
        //communicate with their servers
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
