//
//  CharactersMarvel.swift
//  Heroes Marvel
//
//  Created by Borja Gil Herrero on 03/12/2018.
//  Copyright © 2018 Alsis GHE. All rights reserved.
//

import Foundation

class RespuestaAPI: NSObject, Codable{
    var code: Int = 0
    var status: String = ""
    var copyright: String = ""
    var attributionText: String = ""
    var attributionHTML: String = ""
    var etag: String = ""
    var data: DataAPI = DataAPI()
}
class DataAPI: NSObject, Codable{
    var offset: Int = 0
    var limit: Int = 0
    var total: Int = 0
    var count: Int = 0
    var results: [CharacterAPI]	 = [CharacterAPI]()
}

class CharacterAPI: NSObject, Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case descriptionString = "description"
        case modified
        case thumbnail
        case resourceURI
        case comics
        case series
        case stories
        case events
        case urls
    }
    var id: Int32 = 0
    var name: String = ""
    var descriptionString: String = ""
    var modified: String = ""
    var thumbnail: ImagenCharacterAPI = ImagenCharacterAPI()
    var resourceURI: String = ""
    var comics: ComicsAPI = ComicsAPI()
    var series: SeriesAPI = SeriesAPI()
    var stories: StoriesAPI = StoriesAPI()
    var events: EventsAPI = EventsAPI()
    var urls: [UrlAPI] = [UrlAPI]()
}

class ImagenCharacterAPI:NSObject, Codable{
    enum CodingKeys: String, CodingKey {
        case path
        case extensionString = "extension"
    }
    var path: String = ""
    var extensionString: String = ""
}

class ComicsAPI: NSObject, Codable{
    var available: Int = 0
    var collectionURI: String = ""
    var items: [ComicAPI] = [ComicAPI]()
    var returned : Int = 0
}
class SeriesAPI: NSObject, Codable{
    var available: Int = 0
    var collectionURI: String = ""
    var items: [SerieAPI] = [SerieAPI]()
    var returned: Int = 0
}
class StoriesAPI: NSObject, Codable{
    var available: Int = 0
    var collectionURI: String = ""
    var items: [StorieAPI] = [StorieAPI]()
    var returned: Int = 0
}
class EventsAPI: NSObject, Codable{
    var available: Int = 0
    var collectionURI: String = ""
    var items: [EventAPI] = [EventAPI]()
    var returned: Int = 0
}

class ComicAPI: NSObject, Codable{
    var resourceURI: String = ""
    var name: String = ""
}

class SerieAPI: NSObject, Codable{
    var resourceURI: String = ""
    var name: String = ""
}

class StorieAPI: NSObject, Codable{
    var resourceURI: String = ""
    var name: String = ""
    var type: String = ""
}
class EventAPI: NSObject, Codable{
    var resourceURI: String = ""
    var name: String = ""
}
class UrlAPI: NSObject, Codable{
    var type: String = ""
    var url: String = ""
}

