//
//  TGClient.swift
//  TGClient
//
//  Created by Theodore Strauss on 7/17/17.
//  Copyright © 2017 Theodore Strauss. All rights reserved.
//

import Foundation
import Alamofire

//MARK: DEFINITION OF STRUCTURES

//MARK: -Definition of TGImage
public struct TGImage {
    
    private(set) var url: String? //question mark because the user could use a url OR base64 encoded string
    private(set) var base64: String? //question mark because the user could use a base64 encoded string OR url
    private(set) var crop: CGRect
    
    //two init functions so that the user can use TGImage with a url and crop OR a base64 ecoded string and crop
    public init(url: String, crop: CGRect) {
        self.url = url
        self.crop = crop
    }
    
    public init(base64: String, crop: CGRect) {
        self.base64 = base64
        self.crop = crop
    }
}

//MARK: -Definition of TGCatalog
public struct TGCatalog {
    private(set) var gid: String? //question mark because the user could use a gid OR name
    private(set) var name: String? //question mark because the user could use a gid OR name
    
    //two init functions so that the user can use TGCatalog with a gid OR a name
    public init(gid: String) {
        self.gid = gid
    }
    
    public init(name: String) {
        self.name = name
    }
}

//MARK: -Definition of TGKeywords
public struct TGKeywords {
    private(set) var keywords: [String]
    
    public init(keywords: [String]) {
        self.keywords = keywords
    }
}

public struct TGMetadata {
    private(set) var brand: String
    private(set) var hashtags: [String]
    
    public init(brand: String, hashtags: [String]) {
        self.brand = brand
        self.hashtags = hashtags
    }
}

public struct TGObject {
    private(set) var metadata: TGMetadata
    private(set) var image: TGImage
    
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
        if let url = image.url {
            //search by url
            
            //TODO: pass in the TGImage to the server
            let user = "key_wcjRv0QAVgeO0ZAeq0W83tZHrIH1Y70U"
            let password = ""
            
            var headers: HTTPHeaders = ["Content-Type" : "application/json"]
            
            if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
                headers[authorizationHeader.key] = authorizationHeader.value
            }
            
            Alamofire.request("http://api-dev.threadgenius.co/v1/prediction/tag", headers: headers)
                .responseJSON { response in
                    debugPrint(response)
            }
        } else {
            //search by base64
            
            //TODO: pass in the TGImage to the server
            let user = "key_wcjRv0QAVgeO0ZAeq0W83tZHrIH1Y70U"
            let password = ""
            
            var headers: HTTPHeaders = ["Content-Type" : "application/json"]
            
            if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
                headers[authorizationHeader.key] = authorizationHeader.value
            }
            
            Alamofire.request("http://api-dev.threadgenius.co/v1/prediction/tag", headers: headers)
                .responseJSON { response in
                    debugPrint(response)
            }
        }
        //communicate with their servers
    }
    
    //MARK: -Predict tags via image URLs
    public func tagImages(images: [TGImage]) {
        //communicate with their servers
    }
    
    //MARK: -Predict bounding boxes via image
    public func detectBoxes(image: TGImage) {
        
        //TODO: pass in the TGImage to the server
        let user = "key_wcjRv0QAVgeO0ZAeq0W83tZHrIH1Y70U"
        let password = ""
        
        var headers: HTTPHeaders = ["Content-Type" : "application/json"]
        
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
        }
        
        Alamofire.request("http://api-dev.threadgenius.co/v1/prediction/tag", headers: headers)
            .responseJSON { response in
                debugPrint(response)
        }
        
    }
    
    public func getPredictions() {
        //communicate with their servers
    }
    
    private var key: String
    public init(key: String) {
        self.key = key
    }
}
