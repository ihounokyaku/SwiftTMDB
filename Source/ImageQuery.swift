//
//  ImageQuery.swift
//  TMDBQueryManager
//
//  Created by Dylan Southard on 2019/06/16.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import Alamofire

class ImageQuery:Query {

    var backdrop:Bool!
    var objectID:Int!
    var path:String!
    var imageData:Data?
    
    init(delegate:TMDBQueryManager, objectID:Int, objectType:TMDBObject.ObjectType, path:String, posterSize:TMDBReference.PosterSize? = nil, profileSize:TMDBReference.ProfileSize? = nil, backdropSize:TMDBReference.BackdropSize? = nil, backdrop:Bool = false, key:String?, sender:Any?) {
        super.init(delegate: delegate, objectType: objectType, posterSize:posterSize, profileSize:profileSize, backdropSize:backdropSize, key:key, sender:sender)
        
        self.objectID = objectID
        self.path = path
        self.backdrop = backdrop
        
    }
    
    
    override func execute() {
        
        var size = ""
        
        if self.objectType == .person {
            
            size = self.posterImageSize.rawValue
            
        } else {
            
            size = self.backdrop ? self.backdropSize.rawValue : self.profileImageSize.rawValue
            
        }
        
       
        
        self.request = Alamofire.request("https://image.tmdb.org/t/p/\(size)" + self.path)
        
        
            self.request?.responseData { (response) in
                
            
                if response.result.isSuccess {
                    self.imageData = response.data
                    
                } else {
                    
                    self.error = response.result.error?.localizedDescription
                    
                }
                
                self.delegate?.imageQueryFinished(self)
                
            }
        
    }
    
    
}
