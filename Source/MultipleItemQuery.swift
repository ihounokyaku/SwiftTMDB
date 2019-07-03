//
//  MultipleItemQuery.swift
//  SwiftTMDB
//
//  Created by Dylan Southard on 2019/06/15.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire



class JSONQuery:Query {

    var results:JSON?
    var queryType: TMDBQueryManager.QueryType!
    var resultsCount:Int = 0
    var pageCount:Int = 0
    var includeBackdrop:Bool = false
    var getPoster:Bool = true
    var getProfile:Bool = true
    
    
    var getImage:Bool {
        
        
        return self.objectType == .movie ? self.getPoster : self.getProfile
        
    }

    var params:[String:Any] = [:]
    
    
    init(delegate:TMDBQueryManager, objectType:TMDBObject.ObjectType, page:Int, getPoster:Bool? = nil, getProfile:Bool? = nil, includeBackdrop:Bool? = nil, posterSize:TMDBReference.PosterSize? = nil, profileSize:TMDBReference.ProfileSize? = nil, backdropSize:TMDBReference.BackdropSize? = nil, language:TMDBReference.Language? = nil, key:String?, sender:Any?) {
        
        super.init(delegate: delegate, objectType: objectType, posterSize: posterSize, profileSize: profileSize, backdropSize: backdropSize, key:key, sender:sender)
        
        self.includeBackdrop = includeBackdrop ?? delegate.getBackDropByDefault
        self.getPoster = getPoster ?? delegate.getPosterByDefault
        self.getProfile = getProfile ?? delegate.getProfileImageByDefault
        self.params["language"] = language?.rawValue ?? delegate.defaultLanguage.rawValue
        self.params["page"] = page
        self.params["api_key"] = delegate.apiKey
        self.getQueryType()
        
    }
    
    func getQueryType() {}
    
    func getResponse() {
        
        self.request?.responseJSON { (response) in
            if response.result.isSuccess {
                
                self.checkForResults(response: response)

                
            } else {
                
                self.error = response.result.error?.localizedDescription
                
                
            }
            
            
            self.delegate?.jsonQueryComplete(query: self)
        }
        
    }
    
    
    func checkForResults(response:DataResponse<Any>) {
        let json =  JSON(response.result.value!)
        
        self.results = json["results"]
        
        self.checkForError(inJSON: json)
        
        if let pageCount = json["total_pages"].int, let resultsCount = json["total_results"].int {
            
            self.resultsCount = resultsCount
            
            self.pageCount = pageCount
            
        }
        
        
    }
    
    
    
}
