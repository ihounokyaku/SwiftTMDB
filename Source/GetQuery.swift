//
//  GetQuery.swift
//  TMDBQueryManager
//
//  Created by Dylan Southard on 2019/06/17.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetQuery:JSONQuery {
    
    var objectID = 0
    
    var personAddons:[TMDBReference.SupplimentaryPersonData]?
    var movieAddons:[TMDBReference.SupplimentaryMovieData]?
    
    init(delegate: TMDBQueryManager, objectID:Int, objectType: TMDBObject.ObjectType, object:TMDBObject?, getPoster:Bool? = nil, getProfile:Bool? = nil, includeBackdrop: Bool? = nil, posterSize: TMDBReference.PosterSize? = nil, profileSize: TMDBReference.ProfileSize? = nil, backdropSize: TMDBReference.BackdropSize? = nil, language:TMDBReference.Language? = nil, key:String?, sender:Any?) {
        
        super.init(delegate: delegate, objectType: objectType,  page:1, getPoster:getPoster, getProfile:getProfile, includeBackdrop: includeBackdrop, posterSize: posterSize, profileSize: profileSize, backdropSize: backdropSize, language:language, key:key, sender:sender)
        self.object = object
        self.objectID = objectID
    }
    
    override func getQueryType() {
        self.queryType = .get
    }
    
   override func execute() {
        
        
        var appendString = ""
        
        if let realAddons = movieAddons {
            
            let stringAddons = realAddons.map{ return $0.rawValue }
            appendString = stringAddons.joined(separator: ",")
            
        } else if let realAddons = personAddons {
            
            let stringAddons = realAddons.map{ return $0.rawValue }
            appendString = stringAddons.joined(separator: ",")
        }
        
        var parameters:[String:Any] = [:]
        
        if appendString != "" {
            parameters["append_to_response"] = appendString
        }
        
        parameters["language"] = self.params["language"]
        parameters["api_key"] = self.params["api_key"]
    
    
    self.request = Alamofire.request("https://api.themoviedb.org/3/" + self.objectType.rawValue + "/\(self.objectID)", method:.get, parameters:parameters)
    
    self.request?.responseJSON { (response) in
        
            
            if response.result.isSuccess {
                
                let json:JSON =  JSON(response.result.value!)
                
                self.results = [json]
                self.checkForError(inJSON: json)
                
            } else {
                
                self.error = response.result.error?.localizedDescription
                
            }
            
        self.delegate?.jsonQueryComplete(query: self)
        
        }
        
    }
    
    
    
}
