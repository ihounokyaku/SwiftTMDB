//
//  File.swift
//  SwiftTMDB
//
//  Created by Dylan Southard on 2019/06/15.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation
import SwiftyJSON




public protocol TMDBQueryManagerDelegate:class {
    
    func objectQueryComplete(TMDBQueryManager:TMDBQueryManager, queryType:TMDBQueryManager.QueryType, results:[TMDBObject]?, error:String?, key:String?, sender:Any?)
    
    func imageQueryComplete(TMDBQueryManager:TMDBQueryManager, data:Data?, forObject object:TMDBObject?, objectID:Int, objectType:TMDBObject.ObjectType, backdrop:Bool, error:String?, key:String?, sender:Any?)
    
    func supplimentalDataQueryComplete(TMDBQueryManager:TMDBQueryManager, object:TMDBObject?, objectType:TMDBObject.ObjectType, id:Int, results:JSON?, dataTypeRawValue:String, error:String?, key:String?, sender:Any?)
    
}

public extension TMDBQueryManagerDelegate {
    
    func objectQueryComplete(TMDBQueryManager:TMDBQueryManager, queryType:TMDBQueryManager.QueryType, results:[TMDBObject]?, error:String?, key:String?, sender:Any?){}
    
    func imageQueryComplete(TMDBQueryManager:TMDBQueryManager, data:Data?, forObject object:TMDBObject?, objectID:Int, objectType:TMDBObject.ObjectType, backdrop:Bool, error:String?, key:String?, sender:Any?){}
    
    func supplimentalDataQueryComplete(TMDBQueryManager:TMDBQueryManager, object:TMDBObject?, objectType:TMDBObject.ObjectType, id:Int, results:JSON?, dataTypeRawValue:String, error:String?, key:String?, sender:Any?){}
    
}

public class TMDBQueryManager : NSObject {
    var page = 1
    
    public enum QueryType:String, CaseIterable {
        case search = "search"
        case get = "get"
        case discover = "discover"
        case recommend = "recommend"
    }
    
    
    
    
    //MARK: - =============== VARS ===============
    
    //MARK: - === default query values ===
    
    public var defaultPosterSize:TMDBReference.PosterSize = .w185
    public var defaultProfileSize:TMDBReference.ProfileSize = .w185
    public var defaultBackdropSize:TMDBReference.BackdropSize = .w300
    public var defaultLanguage:TMDBReference.Language = .english
    public var getPosterByDefault:Bool = true
    public var getProfileImageByDefault:Bool = true
    public var getBackDropByDefault:Bool = false
    
    
    
    //MARK: - === Init Vars ===
    weak var delegate:TMDBQueryManagerDelegate?
    public var apiKey:String = ""
    
    //MARK: - === QUERIES ===
    
    static var CurrentJSONQueries = [JSONQuery]()
    
    var currentQueries = [Query]()
    
    var queuedQueries = [JSONQuery]()
    
    var pausedQueries = [Query]()
    
    public var numberOfCurrentQueries:Int { return self.currentQueries.count }
    public var numberOfAllCurrentQueries:Int { return TMDBQueryManager.CurrentJSONQueries.count }
    public var numberOfQueuedQueries:Int { return self.pausedQueries.count }
    public var numberOfPausedQueries:Int{ return self.pausedQueries.count }
    
    //MARK: - =============== INIT ===============
    public init(delegate:TMDBQueryManagerDelegate, apiKey:String){
        self.delegate = delegate
        self.apiKey = apiKey
    }
    
    //MARK: - =============== QUERY FUNCTIONS ===============
    
    //MARK: - === SEARCH QUERIES ===
    
    public func search(for object:TMDBObject.ObjectType, searchTerm:String, page:Int = 1, key:String? = nil, sender:Any? = nil) {
        
        if object == .person {
            
            self.searchForPerson(name: searchTerm, page:page, key:key, sender:sender)
            
        } else {
            
            self.searchForMovie(title: searchTerm, page:page, key:key, sender:sender)
            
        }
    }
    
    public func searchForMovie(title:String, page:Int = 1, key:String? = nil, sender:Any? = nil, getPoster:Bool? = nil, getBackdrop:Bool? = nil, posterSize:TMDBReference.PosterSize? = nil, backdropSize:TMDBReference.BackdropSize? = nil, language:TMDBReference.Language? = nil) {
        
        let query = SearchQuery(delegate: self,
                                objectType: .movie, page:page, getPoster:getPoster, includeBackdrop: getBackdrop, posterSize: posterSize, backdropSize: backdropSize, language: language, key:key, sender:sender)
        
        query.searchTerm = title
        
        self.executeOrQueue(query: query)
    }
    
    public func searchForPerson(name:String,  page:Int = 1, getProfileImage:Bool? = nil, profileImageSize:TMDBReference.ProfileSize? = nil, language:TMDBReference.Language? = nil, key:String? = nil, sender:Any? = nil) {
        
        let query = SearchQuery(delegate: self, objectType: .person, page: page, getProfile: getProfileImage, profileSize: profileImageSize, language: language, key:key, sender:sender)
        
        query.searchTerm = name

        self.executeOrQueue(query: query)
    }
    
    
    //MARK: - === DISCOVERY QUERY ===
    
    public func performDiscoverQuery(params:[TMDBReference.DiscoveryParams:Any]?, key:String? = nil, sender:Any? = nil, page:Int = 1, getPoster:Bool? = nil, getBackdrop:Bool? = nil, posterSize:TMDBReference.PosterSize? = nil, backdropSize:TMDBReference.BackdropSize? = nil, language:TMDBReference.Language? = nil) {
        
        let query = DiscoverQuery(delegate: self, objectType: .movie, page: page, getPoster: getPoster, includeBackdrop: getBackdrop, posterSize: posterSize, backdropSize: backdropSize, language: language, key:key, sender:sender)
            
        query.parameters = params
        
        self.executeOrQueue(query: query)
        
    }
    
    //MARK: - === RECOMMENDATION QUERY ===
    
    public func getRecommendationsBasedOnMovie(withID id:Int, recommendationType:TMDBReference.RecommendationType, key:String? = nil, sender:Any? = nil, page:Int = 1, getPoster:Bool? = nil, getBackdrop:Bool? = nil, posterSize:TMDBReference.PosterSize? = nil, backdropSize:TMDBReference.BackdropSize? = nil, language:TMDBReference.Language? = nil) {
        
        let query = RecommendedQuery(delegate: self, objectType: .movie, page: page, getPoster: getPoster, includeBackdrop: getBackdrop, posterSize: posterSize, backdropSize: backdropSize, language: language, key:key, sender:sender)
        
        query.id = id
        query.recommendationType = recommendationType
        
        self.executeOrQueue(query: query)
        
    }
    
    
    //MARK: - === IndividualQuery ===
    
    public func queryMovieDetails(movie:TMDBMovie, includeOptions:[TMDBReference.SupplimentaryMovieData]?, getPoster:Bool? = nil, getBackdrop:Bool? = nil, posterSize:TMDBReference.PosterSize? = nil, backdropSize:TMDBReference.BackdropSize? = nil, language:TMDBReference.Language? = nil, key:String? = nil, sender:Any? = nil) {
        
        let query = GetQuery(delegate: self, objectID: movie.id, objectType: .movie, object: movie, getPoster: getPoster, includeBackdrop: getBackdrop, posterSize: posterSize, backdropSize: backdropSize, language: language, key:key, sender:sender)
        
        query.movieAddons = includeOptions
        
        self.executeOrQueue(query: query)
        
    }
   
    
    public func queryMovie(byID id:Int, includeOptions:[TMDBReference.SupplimentaryMovieData]?, getPoster:Bool? = nil, getBackdrop:Bool? = nil, posterSize:TMDBReference.PosterSize? = nil, profileSize:TMDBReference.ProfileSize? = nil, backdropSize:TMDBReference.BackdropSize? = nil, language:TMDBReference.Language? = nil, key:String? = nil, sender:Any? = nil) {
       
        
        
        let query = GetQuery(delegate: self, objectID: id, objectType: .movie, object: nil, getPoster:getPoster, includeBackdrop: getBackdrop, posterSize: posterSize, backdropSize: backdropSize, language: language, key:key, sender:sender)
        
        query.movieAddons = includeOptions
        
        self.executeOrQueue(query: query)
        
    }
    
    public func queryPersonDetails(person:TMDBPerson, includeOptions:[TMDBReference.SupplimentaryPersonData]?, getProfileImage:Bool? = nil, profileImageSize:TMDBReference.ProfileSize? = nil, language:TMDBReference.Language? = nil, key:String? = nil, sender:Any? = nil) {
        
        let query = GetQuery(delegate: self, objectID: person.id, objectType: .person, object: person, getProfile: getProfileImage, profileSize: profileImageSize, language: language, key:key, sender:sender)
        
        query.personAddons = includeOptions
        
        self.executeOrQueue(query: query)
        
    }
    
    public func queryPerson(byID id:Int, includeOptions:[TMDBReference.SupplimentaryPersonData]?, getProfileImage:Bool? = nil, profileImageSize:TMDBReference.ProfileSize? = nil, language:TMDBReference.Language? = nil, key:String? = nil, sender:Any? = nil) {
        
        let query = GetQuery(delegate: self, objectID: id, objectType: .person, object: nil, getProfile:getProfileImage, profileSize: profileImageSize, language: language, key:key, sender:sender)
        
        query.personAddons = includeOptions
        
        self.executeOrQueue(query: query)
        
    }

    
    
    //MARK: - === IMAGE QUERIES ===
    
    public func getPoster(forMovie movie:TMDBMovie, size:TMDBReference.PosterSize? = nil, key:String? = nil, sender:Any? = nil) {
        
        let query = ImageQuery(delegate: self, objectID: movie.id, objectType: .movie, path: movie.imagePath, posterSize:size, key: key, sender: sender)
        
        self.appendAndExecuteImageQuery(query: query, object: movie)
        
    }
    
    public func getPoster(forMovieWithID id:Int, posterPath:String, size:TMDBReference.PosterSize? = nil, key:String? = nil, sender:Any? = nil) {
        
        let query = ImageQuery(delegate: self, objectID: id, objectType: .movie, path: posterPath, posterSize:size, key: key, sender: sender)
        
        self.appendAndExecuteImageQuery(query: query, object: nil)

    }
    
    public func getProfileImage(forPerson person:TMDBPerson, size:TMDBReference.ProfileSize? = nil, key:String? = nil, sender:Any? = nil) {
        
        let query = ImageQuery(delegate: self, objectID: person.id, objectType: .person, path: person.imagePath, profileSize:size, key: key, sender: sender)
        
        self.appendAndExecuteImageQuery(query: query, object: person)
        
    }
    
    public func getProfileImage(forPersonWithID id:Int, imagePath:String, size:TMDBReference.ProfileSize? = nil, key:String? = nil, sender:Any? = nil) {
        
        let query = ImageQuery(delegate: self, objectID: id, objectType: .person, path: imagePath, profileSize:size, key: key, sender: sender)
        
        self.appendAndExecuteImageQuery(query: query, object: nil)
        
    }
    
    public func getBackdrop(forMovie movie:TMDBMovie, size:TMDBReference.BackdropSize, key:String? = nil, sender:Any? = nil) {
        
        let query = ImageQuery(delegate: self, objectID: movie.id, objectType: .movie, path: movie.backdropImagePath, backdrop:true, key: key, sender: sender)
        
        self.appendAndExecuteImageQuery(query: query, object: movie)
        
    }
    
    public func getBackdrop(forMovieWithID id:Int, posterPath:String, size:TMDBReference.PosterSize? = nil, key:String? = nil, sender:Any? = nil) {
        
        let query = ImageQuery(delegate: self, objectID: id, objectType: .movie, path: posterPath, posterSize:size, backdrop:true, key: key, sender: sender)
        
        self.appendAndExecuteImageQuery(query: query, object: nil)
        
    }
    
    func appendAndExecuteImageQuery(query:ImageQuery, object:TMDBObject?) {
        
        query.object = object
        
        self.addQueryToCurrent(query)
        
        query.execute()
        
    }
    
    func imageQueryFinished(_ query:ImageQuery) {
        
        self.removeQueryFromCurrent(query)
        
        if let object = query.object {
            if let movie = object as? TMDBMovie, query.backdrop {
                
                movie.backdropImageData = query.imageData
                
            } else {
                
                object.imageData = query.imageData
                
            }
            
        }
        
        self.delegate?.imageQueryComplete(TMDBQueryManager: self, data:query.imageData, forObject: query.object, objectID: query.objectID, objectType: query.objectType, backdrop:query.backdrop, error: query.error, key: query.key, sender: query.sender)
        
    }
    
    //MARK: - === SUPPLIMENTARY DATA QUERIES===
    
    public func querySupplimentalData(forMovieWithID id:Int, dataType:TMDBReference.SupplimentaryMovieData, key:String? = nil, sender:Any? = nil) {
        
        self.querySupplimentalData(forObject: nil, objectID: id, ofType: .movie, personDataType: nil, movieDataType: dataType, key: key, sender: sender)
        
    }
    
    public func querySupplimentalData(forMovie movie:TMDBMovie, dataType:TMDBReference.SupplimentaryMovieData, key:String? = nil, sender:Any? = nil) {
        
        
        self.querySupplimentalData(forObject: movie, objectID: movie.id, ofType: .movie, personDataType: nil, movieDataType: dataType, key: key, sender: sender)
        
    }
    
    public func querySupplimentalData(forPersonWithID id:Int, dataType:TMDBReference.SupplimentaryPersonData, key:String? = nil, sender:Any? = nil) {
        
        self.querySupplimentalData(forObject: nil, objectID: id, ofType: .person, personDataType: dataType, movieDataType: nil, key: key, sender: sender)
        
    }
    
    public func querySupplimentalData(forPerson person:TMDBPerson, dataType:TMDBReference.SupplimentaryPersonData, key:String? = nil, sender:Any? = nil) {
        
        
        self.querySupplimentalData(forObject: person, objectID: person.id, ofType: .person, personDataType: dataType, movieDataType: nil, key: key, sender: sender)
        
    }
    
    func querySupplimentalData(forObject object:TMDBObject?, objectID id:Int, ofType type:TMDBObject.ObjectType, personDataType:TMDBReference.SupplimentaryPersonData?, movieDataType:TMDBReference.SupplimentaryMovieData?, key:String?, sender:Any?) {
        
        let query = SupplimentaryDataQuery(delegate: self, objectType: type, page: 1, key:key, sender:sender)
        query.objectID = id
        query.personParam = personDataType
        query.movieParam = movieDataType
        query.object = object
        self.executeOrQueue(query: query)
    }
    
    
    
    
    
    //MARK: - === EXECUTE OR QUEUE ===
    
    func executeOrQueue(query:JSONQuery) {
        
        if TMDBQueryManager.CurrentJSONQueries.count > 35 {
            
            self.queuedQueries.append(query)
            
            
        } else {
            
            self.addQueryToCurrent(query)
            
            query.execute()
            
        }
        
    }

    
    //MARK: - === COMPLETE QUERY ===
    
    func jsonQueryComplete(query:JSONQuery) {
        
        self.removeQueryFromCurrent(query)
        
        if let query = self.queuedQueries.first {
            
            self.executeOrQueue(query: query)
            
            self.queuedQueries.remove(at: 0)
            
        }
        
        
        guard let realResults = query.results else {
            
            self.delegate?.objectQueryComplete(TMDBQueryManager: self, queryType:query.queryType, results: nil, error: query.error, key:query.key, sender:query.sender)
            return
            
        }
        
        var resultObjects = [TMDBObject]()
        
        for result in realResults.arrayValue {
            
            
            
            var object:TMDBObject?
            
                if let movie = query.object as? TMDBMovie {
                    
                    movie.internalJSON = result
                    
                    object = movie
                    
                } else if let person = query.object as? TMDBPerson{
                    
                    person.internalJSON = result
                    
                    object = person
                    
                } else {
                    
                    object = query.objectType == .movie ? TMDBMovie(jsonData: result) : TMDBPerson(jsonData: result)
                    
                }
            
            if let realObject = object {
                
                resultObjects.append(realObject)
              
            } 
        }
        
        self.delegate?.objectQueryComplete(TMDBQueryManager: self, queryType:query.queryType, results: resultObjects, error: query.error, key:query.key, sender:query.sender)
        
        for object in resultObjects {
            
            self.getImagesIfNecessary(forObject: object, query: query)
            
        }
        
    }
    
    //MARK: - === SUPPLIMENTARY QUERY COMPLETE ===
    
    func supplimentaryQueryComplete(query:SupplimentaryDataQuery) {
        
        
        
        if let movie = query.object as? TMDBMovie {
            
            movie.supplimentaryData[query.movieParam!] = query.results
            
        } else if let person = query.object as? TMDBPerson {
            
            person.supplimentaryData[query.personParam!] = query.results
            
        }
        
        delegate?.supplimentalDataQueryComplete(TMDBQueryManager: self, object:query.object, objectType: query.objectType, id: query.objectID, results: query.results, dataTypeRawValue: query.movieParam?.rawValue ?? query.personParam!.rawValue, error: query.error, key:query.key, sender:query.sender)
        
    }
    
    
    
    
    
    //MARK: - === STOP/PAUSE ===
    
    public func cancelAllQueries(){
        
        for query in self.currentQueries {
            
            self.cancel(query: query)
            
        }
        
    }
    
    
    public func cancel(queriesWithKey key:String) {
        
        let queries = self.queries(gromArray: self.currentQueries, withKey: key)
        
        for query in queries {
            
            self.cancel(query: query)
            
        }
        
    }
    
    
    
    func cancel(query:Query) {
        
        query.request?.cancel()
        
        self.removeQueryFromCurrent(query)
        
    }
    
    public func pauseAllQueries(){
        
        for query in self.currentQueries {
            
            self.pause(query: query)
            
        }
    }
    
    public func pause(queriesWithKey key:String) {
        
        let queries = self.queries(gromArray: self.currentQueries, withKey: key)
        
        for query in queries {
            
            self.pause(query: query)
            
        }
        
    }
    
    func pause(query:Query) {
        
        query.request?.suspend()
        
        self.removeQueryFromCurrent(query)
        
        self.pausedQueries = self.pausedQueries.appending(query: query)
        
    }
    
    
    public func resumeAllQueries() {
        
        for query in self.pausedQueries {
            
            self.resume(query: query)
            
        }
        
    }
    
    public func resume(queriesWithKey key:String) {
        
        let queries = self.queries(gromArray: self.pausedQueries, withKey: key)
        
        for query in queries {
            
            self.resume(query: query)
            
        }
        
    }
    
    func resume(query:Query) {
        
        if let jsonQuery = query as? JSONQuery, TMDBQueryManager.CurrentJSONQueries.count > 35 {
            jsonQuery.request?.cancel()
            self.queuedQueries.append(jsonQuery)
            
        } else {
            
            query.request?.resume()
            
            self.addQueryToCurrent(query)
            
        }
        
        self.pausedQueries = self.pausedQueries.removing(query:query)
        
        
    }
    
    
    
    
    func queries(gromArray array: [Query], withKey key:String)-> [Query] {
        
        let optionalKey:String? = key
        
        return array.filter { return $0.key == optionalKey }
        
    }
    
    func removeQueryFromCurrent(_ query:Query) {
        
        self.currentQueries = self.currentQueries.removing(query: query)
        
        if let jQuery = query as? JSONQuery {
            
            TMDBQueryManager.CurrentJSONQueries = TMDBQueryManager.CurrentJSONQueries.removing(query: jQuery)
            
        }
        
    }
    
    func addQueryToCurrent(_ query:Query) {
        
        self.currentQueries = self.currentQueries.appending(query: query)
        
        if let jQuery = query as? JSONQuery {
            
            TMDBQueryManager.CurrentJSONQueries = TMDBQueryManager.CurrentJSONQueries.appending(query: jQuery)
            
        }
        
    }
    
    
    
    //MARK: - === CONVENIENCES ===
    
    
    func getImagesIfNecessary(forObject object:TMDBObject, query:JSONQuery){
        
        if query.getImage, object.imageData == nil {
            
            if let movie = object as? TMDBMovie {
                
                
                self.getPoster(forMovie: movie, size: query.posterImageSize)
                
                
            } else {
                
                self.getProfileImage(forPerson: object as! TMDBPerson, size: query.profileImageSize)
                
            }
            
        }
        
        if let movie = object as? TMDBMovie, query.includeBackdrop, movie.backdropImageData == nil {
            
            self.getBackdrop(forMovie: movie, size: query.backdropSize)
            
        }
    }
    
    
    deinit { self.cancelAllQueries() }
    
    
}


extension Array where Element:Query {
    
    func removing(query:Element)->Array {
        var array = self
        
        if let index = self.firstIndex(of: query) {
            
            array.remove(at: index)
            
        }
        return array
    }
    
    func appending(query:Element)-> Array {
        var array = self
        
        if array.contains(query) {
            return self
        } else {
            array.append(query)
            return array
        }
        
    }
    
    
}


