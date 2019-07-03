//
//  DiscoverQuery.swift
//  TMDBQueryManager
//
//  Created by Dylan Southard on 2019/06/17.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class DiscoverQuery:JSONQuery {
    
    var parameters:[TMDBReference.DiscoveryParams:Any]?
    
    override func getQueryType() {
        self.queryType = .discover
    }
    
    override func execute() {
        
        if let realParameters = parameters {
            
            for (key, value) in realParameters {
                
                self.params[key.rawValue] = value
                
            }
        }
        
        self.request =  Alamofire.request("https://api.themoviedb.org/3/discover/movie", method:.get, parameters:self.params)
        
        self.getResponse()
        
    }
    
    
    
}
