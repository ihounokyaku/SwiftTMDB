//
//  SearchQuery.swift
//  SwiftTMDB
//
//  Created by Dylan Southard on 2019/06/15.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON


class SearchQuery: JSONQuery {
    
    var searchTerm = ""
    
    
    override func getQueryType() {
        self.queryType = .search
    }
    
   override func execute() {
    
    self.params["query"] = self.searchTerm
    
    self.request = Alamofire.request("https://api.themoviedb.org/3/search/" + self.objectType.rawValue, method:.get, parameters:self.params)
 
        self.getResponse()
    
    }
}
