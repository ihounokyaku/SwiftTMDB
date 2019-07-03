//
//  RecommendedQuery.swift
//  TMDBQueryManager
//
//  Created by Dylan Southard on 2019/06/18.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RecommendedQuery:JSONQuery {
    
    var recommendationType:TMDBReference.RecommendationType!
    var id:Int = 0
    
    override func getQueryType() {
         self.queryType = .recommend
    }
    
    override func execute() {
        
        self.request = Alamofire.request("https://api.themoviedb.org/3/movie/\(self.id)/" + recommendationType.rawValue, parameters: self.params)
        
        self.getResponse()
        
    }
    
    
    
}
