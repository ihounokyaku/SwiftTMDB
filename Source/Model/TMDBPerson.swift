//
//  Person.swift
//  TMDBQueryManager
//
//  Created by Dylan Southard on 2019/06/16.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TMDBPerson:TMDBObject {
    

    public var knownForDepartment:String { return json.valueFor(.knownForDept).string ?? ""}
    
    public var biography:String { return json.valueFor(.biography).string ?? "" }
    
    public var supplimentaryData:[TMDBReference.SupplimentaryPersonData:JSON] = [:]
    
    
    //MARK: - === Credits ===
    var creditsJSON:JSON? {
        var credits:JSON?
        
        if !json[TMDBReference.SupplimentaryPersonData.movieCredits.rawValue].isEmpty {
            
            credits = json[TMDBReference.SupplimentaryPersonData.movieCredits.rawValue]
            
        } else if let supCred = self.supplimentaryData[TMDBReference.SupplimentaryPersonData.movieCredits] {
            
            credits = supCred
            
        }
        
        return credits
    }
    
    public var knownFor:[TMDBCreditMovie] {
        
        guard let knownForArray = json["known_for"].array else {return Array(self.moviesInKnownForRoleByPopularity.prefix(3))}
        
        let objectArray = knownForArray.compactMap {return $0.creditMovie(forPerson: self)}
 
        guard objectArray.count > 0 else {return Array(self.moviesInKnownForRoleByPopularity.prefix(3))}
        
        return objectArray
        
    }
    
    public var moviesInKnownForRoleByPopularity:[TMDBCreditMovie] {
        
        var castOrCrew = [JSON]()
        
        if (self.knownForDepartment == "Acting" || self.knownForDepartment == ""), let cast = self.creditsJSON?[TMDBReference.CreditType.cast.rawValue].array {
            
            castOrCrew = cast
            
        } else {
            
            if let crew = self.creditsJSON?[TMDBReference.CreditType.crew.rawValue].array {
                
                castOrCrew = crew.filter {$0["department"].string == self.knownForDepartment}
                
            }
            
        }
        
        let sortedArray = castOrCrew.sorted(by: { $0["popularity"].double ?? 0 > $1["popularity"].double ?? 0 })
        return sortedArray.compactMap {return $0.creditMovie(forPerson:self)}
        
    }
    
    public var allMovieCredits:[TMDBCreditMovie] {
        var credits = [TMDBCreditMovie]()
        
        if let castCredits = self.creditsJSON?[TMDBReference.CreditType.cast.rawValue].array {
            credits.append(contentsOf:castCredits.compactMap {return $0.creditMovie(forPerson: self)})
        }
        
        if let crewCredits = self.creditsJSON?[TMDBReference.CreditType.crew.rawValue].array {
            credits.append(contentsOf: crewCredits.compactMap {return $0.creditMovie(forPerson: self)})
        }

        return credits
    }

    
    public var creditsByJob:[TMDBReference.MajorJob:[TMDBCreditMovie]] {
        
        var cbj:[TMDBReference.MajorJob:[TMDBCreditMovie]] = [:]
        
        for movie in self.allMovieCredits {
            
            let key = TMDBReference.MajorJob(rawValue: movie.job) ?? TMDBReference.MajorJob.other
            
            if cbj[key] == nil {
                
                cbj[key] = []
                
            }
            
            cbj[key]?.append(movie)
            
        }
        
        return cbj
        
    }
    
    override func setObjectType() {
        self.internalObjectType = .person
        self.propertyNames = ["id", "name", "imagePath", "popularity", "imdbID", "type", "objectType", "knownFor", "biography"]
        self.propertyValues = [id, name, imagePath, popularity, imdbID, type, objectType, knownFor, biography]
    }
    
    
    public func creditsIn(movieWithID id:Int)->[TMDBCreditMovie] {
        
       return self.allMovieCredits.filter { return $0.id == id }
        
    }
    
    
    
    
}


public extension JSON {
    
    var person:TMDBPerson? {
        
        let _person = TMDBPerson(jsonData: self)
        
        guard _person.id != 0 else { return nil }
        
        return _person
        
    }
    
    func valueFor(_ personField:TMDBReference.PersonField)->JSON {
        
        return self[personField.rawValue]
        
    }
    
    func valueFor(_ supplimentaryPersonField:TMDBReference.SupplimentaryPersonData)->JSON {
        
        return self[supplimentaryPersonField.rawValue]
        
    }
    
}


