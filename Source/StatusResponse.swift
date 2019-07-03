//
//  StatusResponse.swift
//  TMDBQueryManager
//
//  Created by Dylan Southard on 2019/06/19.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation

public class TMDBError:NSObject {
    
    public var statusCode:Int { return self.internalStatusCode }
    public var statusMessage:String { return self.internalStatusMessage }
    
    var internalStatusCode:Int
    var internalStatusMessage:String
    
   public init(statusCode:Int, statusMessage:String) {
    
        self.internalStatusCode = statusCode
        self.internalStatusMessage = statusMessage
        
    }
    
    
}
