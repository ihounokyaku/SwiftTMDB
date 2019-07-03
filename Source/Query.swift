//
//  File.swift
//  SwiftTMDB
//
//  Created by Dylan Southard on 2019/06/15.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire



public class Query:NSObject {
    
    weak var delegate:TMDBQueryManager?
    
    var error:String?
    
    var objectType:TMDBObject.ObjectType = .movie
    
    var posterImageSize:TMDBReference.PosterSize
    
    var profileImageSize:TMDBReference.ProfileSize
    
    
    var backdropSize:TMDBReference.BackdropSize = .w300
    
    var request:DataRequest?
    
    var key:String?
    
    var sender:Any?
    
    var object:TMDBObject?
    

    
    
    init(delegate:TMDBQueryManager, objectType:TMDBObject.ObjectType, posterSize:TMDBReference.PosterSize? = nil, profileSize:TMDBReference.ProfileSize? = nil, backdropSize:TMDBReference.BackdropSize? = nil, key:String? = nil, sender:Any?) {
        
        self.objectType = objectType
        
        self.delegate = delegate
        
        self.posterImageSize = posterSize ?? delegate.defaultPosterSize
        
        self.profileImageSize = profileSize ?? delegate.defaultProfileSize
        
        self.backdropSize = backdropSize ?? delegate.defaultBackdropSize
        
        self.key = key
        
        self.sender = sender
        
    }
    
    func execute(){}
    
    func checkForError(inJSON json:JSON) {
        
        if let errorMessage = json["status_message"].string {
            
            self.error = errorMessage
            
        }
    }
    
}
