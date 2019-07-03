//
//  TMDBObject.swift
//  TMDBQueryManager
//
//  Created by Dylan Southard on 2019/06/16.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TMDBObject:NSObject {
    
    public enum ObjectType:String, CaseIterable {
        case movie = "movie"
        case person = "person"
    }
    
    public var json:JSON {
        return self.internalJSON
    }
    
    var internalJSON:JSON!
    
    
    
    public var id:Int { return json["id"].int ?? 0 }
    
    public var name:String {
        return json["title"].string ?? json["name"].string ?? "[No Data Available]"
    }
    
    public var imagePath:String { return json["poster_path"].string ?? json["profile_path"].string ?? "" }
    
    public var popularity:Double { return json["popularity"].double ?? 0 }
    
    public var imdbID:String { return json["imdb_id"].string ?? ""}
    
    
    public var type:ObjectType {
        get {
           return self.objectType
        }
    }
    
    var objectType:ObjectType {
        
        return self.internalObjectType
        
    }
    
    var internalObjectType:ObjectType = .movie
    
    public var imageData:Data? = nil
    
    public init(jsonData:JSON) {
        super.init()
        self.internalJSON = jsonData
        self.setObjectType()
    }
    
    func setObjectType() {}
    
    var propertyNames = [String]()
    var propertyValues = [Any?]()
    
    public var detailedDescription:String {
        if let movie = self as? TMDBMovie {
            
            return movie.overview
            
        } else if let person = self as? TMDBPerson {
            
            return person.biography
            
        }
        
        return ""
    }

}

public extension Array where Element == JSON {
    
    func movieTitles()-> [String] {
        
        var movieList = [String]()
        for movie in self {
            
            guard let movieTitle = movie["title"].string else {continue}
            movieList.append(movieTitle)
            
        }
        return movieList
    }
    
}
