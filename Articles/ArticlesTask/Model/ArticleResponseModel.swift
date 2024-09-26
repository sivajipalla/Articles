//
//  ArticleResponseModel.swift
//  ArticlesTask
//
//  Created by Sivaji Palla on 25/09/24.
//

import Foundation

struct ArticleResponseModel: Codable {
    let response: Response
}

struct Response: Codable {
    let docs: [Article]
}

struct Article: Codable {
    let abstract: String?
    let multimedia: [Multimedia]?
    let headline: Headline?
    let pubDate: String?
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case abstract
        case multimedia, headline
        case pubDate = "pub_date"
        case id = "_id"
    }
    
    var publishedDate:Date? {
        return DateFormatterHelper.formattedDate(from: pubDate ?? "")
    }
    
    var mediumPublishedDate:String? {
        guard let date = publishedDate else { return nil }
        return DateFormatterHelper.string(from: date)
    }
    
    
    // Add an initializer for mapping from ArticleEntity
    init(entity: ArticleEntity) {
        self.abstract = entity.abstract
        self.pubDate = entity.pubDate
        self.id = entity.id ?? ""
        
        // Fetch multimedia items
        if let multimediaSet = entity.multimediaEntity as? Set<MultimediaEntity> {
            self.multimedia = multimediaSet.compactMap({ multimediaEntity in
                return Multimedia(url: multimediaEntity.url)
            })
        }else {
            self.multimedia = []
        }
        
        // Fetch headline item
        if let headlineEntity = entity.headlineEntity {
            self.headline = Headline(main: headlineEntity.main)
        } else {
            self.headline = nil
        }
    }
}


// MARK: - Headline
struct Headline: Codable {
    let main: String?
}

// MARK: - Multimedia
struct Multimedia: Codable {
    let url: String?
}
