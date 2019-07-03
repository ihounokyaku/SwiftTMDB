//
//  Reference.swift
//  TMDBQueryManager
//
//  Created by Dylan Southard on 2019/06/16.
//  Copyright © 2019 Dylan Southard. All rights reserved.
//

import Foundation

public struct TMDBReference {
    
    public static let Genres = ["Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western"]

    
    public static let GenreIDs =  ["Horror": 27, "Drama": 18, "Adventure": 12, "Thriller": 53, "Fantasy": 14, "Crime": 80, "Action": 28, "Animation": 16, "Family": 10751, "Western": 37, "History": 36, "War": 10752, "Mystery": 9648, "Comedy": 35, "Science Fiction": 878, "Documentary": 99, "Music": 10402, "TV Movie": 10770, "Romance": 10749]
    
    public static let GenresByID = [10770: "TV Movie", 14: "Fantasy", 35: "Comedy", 10751: "Family", 53: "Thriller", 10749: "Romance", 27: "Horror", 10402: "Music", 37: "Western", 36: "History", 12: "Adventure", 18: "Drama", 10752: "War", 99: "Documentary", 80: "Crime", 16: "Animation", 9648: "Mystery", 878: "Science Fiction", 28: "Action"]
    
    public enum PosterSize:String, CaseIterable {
        case w92 = "w92"
        case w154 = "w154"
        case w185 = "w185"
        case w342 = "w342"
        case w500 = "w500"
        case w780 = "w780"
    }
    
    public enum ProfileSize:String, CaseIterable {
        case w45 = "w45"
        case w185 = "w185"
        case h632 = "h632"
        case original = "original"
    }
    
    public enum BackdropSize:String, CaseIterable {
        case w300 = "w300"
        case w780 = "w780"
        case w1280 = "w1280"
        case original = "original"
    }
    
    public enum SupplimentaryMovieData:String, CaseIterable {
        case videos = "videos"
        case credits = "credits"
        case alternativeTitles = "alternative_titles"
        case changes = "changes"
        case externalIDs = "external_ids"
        case images = "images"
        case keywords = "keywords"
        case releaseDates = "release_dates"
        case translations = "translations"
        case recommendations = "recommendations"
        case similar = "similar"
        case reviews = "reviews"
        case lists = "lists"
    }
    
    public enum SupplimentaryPersonData:String, CaseIterable {
        case changes = "changes"
        case movieCredits = "movie_credits"
        case tvCredits = "tv_credits"
        case combinedCredits = "combined_credits"
        case externalIDs = "external_ids"
        case images = "images"
        case taggedImages = "tagged_images"
        case translations = "translations"
        
    }
    
    public enum SortByOption:String, CaseIterable {
        case popularity = "popularity"
        case releaseDate = "release_date"
        case revenue = "revenue"
        case primaryReleaseDate = "primary_release_date"
        case originalTitle = "original_title"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    public enum SortByOperator:String, CaseIterable {
        case ascending = ".asc"
        case descending = ".desc"
    }
    
    public enum GenreOption:Int {
        case horror = 27
        case drama = 18
        case adventure = 12
        case thriller = 53
        case fantasy = 14
        case crime = 80
        case action = 28
        case animation = 16
        case family = 10751
        case western = 37
        case history = 36
        case war = 10752
        case mystery = 9648
        case comedy = 35
        case scienceFiction = 878
        case documentary = 99
        case music = 10402
        case tvMovie = 10770
        case romance = 10749
    }
    
    public enum ComparisonOperator:String, CaseIterable {
        case greaterThanOrEqualTo = ".gte"
        case lessThanOrEqualTo = ".lte"
    }
    
    public enum DiscoveryParams:String, CaseIterable {
        
        case language = "language"
        case region = "region"
        case sortBy = "sort_by"
        case certificationCountry = "certification_country"
        case certification = "certification"
        case includeAdult = "include_adult"
        case include_video = "include_video"
        case page = "page"
        case primaryReleaseYear = "primary_release_year"
        case primaryReleaseDate = "primary_release_date"
        case releaseDate = "release_date"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case withCast = "with_cast"
        case withCrew = "with_crew"
        case withCompanies = "with_companies"
        case withGenres = "with_genres"
        case withKeywords = "with_keywords"
        case withPeople = "with_people"
        case year = "year"
        case withoutGenres = "without_genres"
        case withRuntime = "with_runtime"
        case withReleaseType = "with_release_type"
        case withOriginalLanguage = "with_original_language"
        case withoutKeywords = "without_keywords"
        
    }
    
    public enum RecommendationType:String, CaseIterable {
        case recommended = "recommendations"
        case similar = "similar"
    }
    
    public enum Language:String, CaseIterable {
        case afar = "aa"
        case abkhazian = "ab"
        case avestan = "ae"
        case afrikaans = "af"
        case akan = "ak"
        case amharic = "am"
        case aragonese = "an"
        case arabic = "ar"
        case assamese = "as"
        case avaric = "av"
        case aymara = "ay"
        case azerbaijani = "az"
        case bashkir = "ba"
        case belarusian = "be"
        case bulgarian = "bg"
        case bihari = "bh"
        case bislama = "bi"
        case bambara = "bm"
        case bengali = "bn"
        case tibetan = "bo"
        case breton = "br"
        case bosnian = "bs"
        case catalan = "ca"
        case chechen = "ce"
        case chamorro = "ch"
        case corsican = "co"
        case cree = "cr"
        case czech = "cs"
        case churchslavic = "cu"
        case chuvash = "cv"
        case welsh = "cy"
        case danish = "da"
        case german = "de"
        case divehi = "dv"
        case dzongkha = "dz"
        case ewe = "ee"
        case moderngreek = "el"
        case english = "en"
        case esperanto = "eo"
        case spanishcastilian = "es"
        case estonian = "et"
        case basque = "eu"
        case persian = "fa"
        case fulah = "ff"
        case finnish = "fi"
        case fijian = "fj"
        case faroese = "fo"
        case french = "fr"
        case westernfrisian = "fy"
        case irish = "ga"
        case gaelicscottish = "gd"
        case galician = "gl"
        case guaraní = "gn"
        case gujarati = "gu"
        case manx = "gv"
        case hausa = "ha"
        case modernhebrew = "he"
        case hindi = "hi"
        case hirimotu = "ho"
        case croatian = "hr"
        case haitianhaitiancreole = "ht"
        case hungarian = "hu"
        case armenian = "hy"
        case herero = "hz"
        case interlingua = "ia"
        case indonesian = "id"
        case interlingueoccidental = "ie"
        case igbo = "ig"
        case sichuanyinuosu = "ii"
        case inupiaq = "ik"
        case ido = "io"
        case icelandic = "is"
        case italian = "it"
        case inuktitut = "iu"
        case japanese = "ja"
        case javanese = "jv"
        case georgian = "ka"
        case kongo = "kg"
        case kikuyugikuyu = "ki"
        case kwanyamakuanyama = "kj"
        case kazakh = "kk"
        case kalaallisutgreenlandic = "kl"
        case centralkhmer = "km"
        case kannada = "kn"
        case korean = "ko"
        case kanuri = "kr"
        case kashmiri = "ks"
        case kurdish = "ku"
        case komi = "kv"
        case cornish = "kw"
        case kirghizkyrgyz = "ky"
        case latin = "la"
        case luxembourgish = "lb"
        case ganda = "lg"
        case limburgish = "li"
        case lingala = "ln"
        case lao = "lo"
        case lithuanian = "lt"
        case lubakatanga = "lu"
        case latvian = "lv"
        case malagasy = "mg"
        case marshallese = "mh"
        case māori = "mi"
        case macedonian = "mk/sl"
        case malayalam = "ml"
        case mongolian = "mn"
        case moldavian = "mo"
        case marathi = "mr"
        case malay = "ms"
        case maltese = "mt"
        case burmese = "my"
        case nauru = "na"
        case norwegianbokmål = "nb"
        case northndebele = "nd"
        case nepali = "ne"
        case ndonga = "ng"
        case dutchflemish = "nl"
        case norwegiannynorsk = "nn"
        case norwegian = "no"
        case southndebele = "nr"
        case navajonavaho = "nv"
        case chichewa = "ny"
        case occitan = "oc"
        case ojibwa = "oj"
        case oromo = "om"
        case oriya = "or"
        case ossetianossetic = "os"
        case panjabipunjabi = "pa"
        case pāli = "pi"
        case polish = "pl"
        case pashtopushto = "ps"
        case portuguese = "pt"
        case quechua = "qu"
        case romansh = "rm"
        case rundi = "rn"
        case romanian = "ro"
        case russian = "ru"
        case kinyarwanda = "rw"
        case sanskrit = "sa"
        case sardinian = "sc"
        case sindhi = "sd"
        case northernsami = "se"
        case sango = "sg"
        case serbocroatian = "sh"
        case sinhalasinhalese = "si"
        case slovak = "sk"
        case slovene = "sl"
        case samoan = "sm"
        case shona = "sn"
        case somali = "so"
        case albanian = "sq"
        case serbian = "sr"
        case swati = "ss"
        case southernsotho = "st"
        case sundanese = "su"
        case swedish = "sv"
        case swahili = "sw"
        case tamil = "ta"
        case telugu = "te"
        case tajik = "tg"
        case thai = "th"
        case tigrinya = "ti"
        case turkmen = "tk"
        case tagalog = "tl"
        case tswana = "tn"
        case tonga = "to"
        case turkish = "tr"
        case tsonga = "ts"
        case tatar = "tt"
        case twi = "tw"
        case tahitian = "ty"
        case uighuruyghur = "ug"
        case ukrainian = "uk"
        case urdu = "ur"
        case uzbek = "uz"
        case venda = "ve"
        case vietnamese = "vi"
        case volapük = "vo"
        case walloon = "wa"
        case wolof = "wo"
        case xhosa = "xh"
        case yiddish = "yi"
        case yoruba = "yo"
        case zhuangchuang = "za"
        case chinese = "zh"
        case zulu = "zu"
    }
    
    public enum MajorJob:String, CaseIterable {
        
        case producer = "Producer"
        case dop = "Director of Photography"
        case director = "Director"
        case actor = "Actor"
        case wcreenplay = "Screenplay"
        case other = "Other"
        
    }
    
    public enum MovieField:String, CaseIterable {
        
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget = "budget"
        case genres = "genres"
        case homePage = "homepage"
        case id = "id"
        case imdbID = "imdb_id"
        case originalLanguage =  "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue = "revenue"
        case runtime = "runtime"
        case spokenLanguages = "spoken_languages"
        case status = "status"
        case tagline = "tagline"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        
    }
    
    public enum PersonField:String, CaseIterable {
        
        case birthday = "birthday"
        case knownForDept = "known_for_department"
        case deathDay = "deathday"
        case id = "id"
        case name = "name"
        case AlsoKnownAs = "also_known_as"
        case gender = "gender"
        case biography = "biography"
        case popularity = "popularity"
        case PlaceOfBirth = "place_of_birth"
        case ProfilePath = "profile_path"
        case adult = "adult"
        case imdbID = "imdb_id"
        case homepage = "homepage"
        
    }
    
    public enum CreditType:String, CaseIterable {
        
        case cast = "cast"
        case crew = "crew"
        
    }
    
    
}
