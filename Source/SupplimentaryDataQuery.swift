//
//  File.swift
//  TMDBQueryManager
//
//  Created by Dylan Southard on 2019/06/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SupplimentaryDataQuery:JSONQuery {
    var movieParam:TMDBReference.SupplimentaryMovieData?
    var personParam:TMDBReference.SupplimentaryPersonData?
    var objectID:Int = 0

    
    
    override func execute() {
        
        let param = movieParam?.rawValue ?? personParam!.rawValue
        
        
        
        self.request = Alamofire.request("https://api.themoviedb.org/3/" + self.objectType.rawValue + "/" + "\(self.objectID)" + "/" + param, method:.get, parameters:["api_key":self.delegate!.apiKey])
         
        self.request?.responseJSON { (response) in
            
            if response.result.isSuccess {
                
                let json:JSON = JSON(response.result.value!)
                
                self.results = json
                
                self.checkForError(inJSON: json)
                
                
            } else {
                
                self.error = response.result.error?.localizedDescription
                
            }
            
            self.delegate?.supplimentaryQueryComplete(query:self)
        }
        
    }
    
}
