//
//  TMDBMovie.swift
//  TMDBQueryManager
//
//  Created by Dylan Southard on 2019/06/15.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import SwiftyJSON


public class TMDBMovie:TMDBObject {
    
    
    public var releaseDate:String { return json.valueFor(.releaseDate).string ?? "2019-04-24" }
    
    public var language:String { return json.valueFor(.originalLanguage).string ?? TMDBReference.Language.english.rawValue }
    
    public var revenue:Int { return json.valueFor(.revenue).int ?? 0 }
    
    public var budget:Int { return json.valueFor(.budget).int ?? 0 }
    
    public var runtime:Int { return json.valueFor(.runtime).int ?? 0 }
    
    public var tagline:String { return json.valueFor(.tagline).string ?? ""}
    
    public var backdropImagePath:String { return json.valueFor(.backdropPath).string ?? ""}
    
    public var overview:String { return json.valueFor(.overview).string ?? "" }
    
    public var backdropImageData:Data?
    
    public var supplimentaryData:[TMDBReference.SupplimentaryMovieData:JSON] = [:]
    
    
    public var trailerPath:String {
        
        let videos = json[TMDBReference.SupplimentaryMovieData.videos.rawValue]["results"].arrayValue.first
        
        return "https://www.youtube.com/embed/" + (videos?["key"].string ?? "")
        
    }
    
    var creditsJSON:JSON? {
        
        var credits:JSON? = nil
        
        if !json[TMDBReference.SupplimentaryMovieData.credits.rawValue].isEmpty {
            
            credits = json[TMDBReference.SupplimentaryMovieData.credits.rawValue]
            
        } else if let castMembers = self.supplimentaryData[TMDBReference.SupplimentaryMovieData.credits] {
            
            credits = castMembers
            
        }
        
        return credits
    }
    
    
    
    public var cast:[TMDBCreditPerson] {
        
        var _cast = [TMDBCreditPerson]()
        
        
        guard let castMembers = self.creditsJSON?[TMDBReference.CreditType.cast.rawValue].array else { return _cast }
        
        for member in castMembers {
            
            guard let creditPerson = member.creditPerson(forMovie: self) else {continue}
            
            _cast.append(creditPerson)
            
        }
        
        return _cast
        
    }
    
    
    
    public var crew:[TMDBCreditPerson] {
    
        guard let crewMembers = self.creditsJSON?[TMDBReference.CreditType.crew.rawValue].array else { return [TMDBCreditPerson]() }
        
        return crewMembers.compactMap { return $0.creditPerson(forMovie: self) }
        
    }
    
    public var credits:[TMDBCreditPerson] {
        
        return self.cast + self.crew
        
    }
    
    public var creditsByJob:[TMDBReference.MajorJob:[TMDBCreditPerson]] {
        
        var cbj:[TMDBReference.MajorJob:[TMDBCreditPerson]] = [:]
        
        for person in self.credits {
            
            let key = TMDBReference.MajorJob(rawValue: person.job) ?? TMDBReference.MajorJob.other
            
            if cbj[key] == nil {
                
                cbj[key] = []
                
            }
            
            cbj[key]?.append(person)
            
        }
        
        return cbj
        
    }
    
    public var directors:[TMDBCreditPerson] { return self.crew.filter({$0.job == TMDBReference.MajorJob.director.rawValue}) }
    
    public var genres:[String] {
        var genreNames = [String]()
        if let genreIDs = json["genre_ids"].arrayObject {
            for genreID in genreIDs {
                
                guard let genre = genreID as? Int, let genreName = TMDBReference.GenresByID[genre] else {continue}
                
                genreNames.append(genreName)
                
            }
        } else if let genres = json["genres"].array {
            for genre in genres {
                if let genreName = genre["name"].string {
                    genreNames.append(genreName)
                }
            }
        }
        
        return genreNames
    }

    
    public var title:String {
        return self.name
    }
    
    
    
    
    
    override func setObjectType() {
        self.internalObjectType = .movie
        self.propertyNames = ["id", "name", "imagePath", "popularity", "imdbID", "type", "objectType", "releaseDate", "lanugage", "revenue", "budget", "runtime", "tagline", "trailerPath", "cast", "directors", "genres", "backdropImageData", "overview", "title"]
        
        self.propertyValues = [id, name, imagePath, popularity, imdbID, type, objectType, releaseDate, language, revenue, budget, runtime, tagline, trailerPath, cast, directors, genres, backdropImageData, overview, title]
    }
    
    
    public func credits(forPersonWithID id:Int, type:TMDBReference.CreditType? = nil)-> [TMDBCreditPerson] {
        
        var filterArray:[TMDBCreditPerson]!
        if let realType = type {
            
            filterArray = realType == .cast ? self.cast : self.crew
            
        } else {
            filterArray = self.credits
        }
        
        
        return filterArray.filter { return $0.id == id }
        
    }
    
}

public extension JSON {
    
    var movie:TMDBMovie? {
        
        let _movie = TMDBMovie(jsonData: self)
        
        guard _movie.id != 0 else { return nil }
        
        return _movie
        
    }
    
    func valueFor(_ movieField:TMDBReference.MovieField)->JSON {
        
        return self[movieField.rawValue]
        
    }
    
    func valueFor(_ supplimentaryMovieField:TMDBReference.SupplimentaryMovieData)->JSON {
        
        return self[supplimentaryMovieField.rawValue]
        
    }
    
    
    
}



