//
//  TMDBCreditPerson.swift
//  TMDBQueryManager
//
//  Created by Dylan Southard on 2019/06/22.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TMDBCreditPerson: TMDBPerson {
    
    public var movie:TMDBMovie {
        return movieInternal
    }
    
    var movieInternal:TMDBMovie!
    
    public var character:String? { return json["character"].string }
    
    public var creditID:String { return json["credit_id"].string ?? ""}
    
    public var job:String { return json["job"].string ?? TMDBReference.MajorJob.actor.rawValue}
    
    public init(jsonData: JSON, forMovie movie:TMDBMovie) {
        super.init(jsonData: jsonData)
        self.movieInternal = movie
    }
    
    
    
}

public extension JSON {
    func creditPerson(forMovie movie:TMDBMovie)->TMDBCreditPerson? {
        
        let person = TMDBCreditPerson(jsonData: self, forMovie: movie)
        
        guard person.id != 0 else { return nil }
    
        return person
        
    }
}
