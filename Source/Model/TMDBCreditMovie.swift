//
//  TMDBCreditMovie.swift
//  TMDBQueryManager
//
//  Created by Dylan Southard on 2019/06/22.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TMDBCreditMovie: TMDBMovie {
    
    public var person:TMDBPerson {
        return personInternal
    }
    
    var personInternal:TMDBPerson!
    
    public var character:String? { return json["character"].string }
    
    public var creditID:String { return json["credit_id"].string ?? "" }
    
    public var job:String { return json["job"].string ?? TMDBReference.MajorJob.actor.rawValue}
    
    public init(jsonData: JSON, forPerson person:TMDBPerson) {
        super.init(jsonData: jsonData)
        self.personInternal = person
    }
    
}

public extension JSON {
    
    func creditMovie(forPerson person:TMDBPerson)->TMDBCreditMovie? {
        
        let movie = TMDBCreditMovie(jsonData: self, forPerson: person)
        
        guard movie.id != 0 else {return nil}
        
        return movie
        
    }
}


