//
//  CoreDataManager.swift
//  ArticlesTask
//
//  Created by Sivaji Palla on 25/09/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ArticleResponse")

        // Enable automatic and inferred migration
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    
    // Save context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Fetch articles
    func fetchArticles() -> [Article] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        
        do {
            let savedArticles = try context.fetch(fetchRequest)
            return savedArticles.map { Article(entity: $0)}
        } catch {
            print("Error fetching articles: \(error)")
            return []
        }
    }
    
    // Delete all articles
    func deleteAllArticles() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        
        do {
            let articles = try context.fetch(fetchRequest)
            for article in articles {
                context.delete(article)
            }
            saveContext()
        } catch {
            print("Error deleting articles: \(error)")
        }
    }
    
    //Save articles
    func saveArticles(articles: [Article]) {
        deleteAllArticles() // Clear existing articles before saving new ones
        let context = persistentContainer.viewContext
        
        for article in articles {
            let articleEntity = ArticleEntity(context: context)
            articleEntity.abstract = article.abstract
            articleEntity.id = article.id
            articleEntity.pubDate = article.pubDate
            
            // Handle Headline entity
            if let headline = article.headline {
                let headlineEntity = HeadlineEntity(context: context)
                headlineEntity.main = headline.main
                
                // Set relationship
                articleEntity.headlineEntity = headlineEntity
            }
            
            // Handle Multimedia entities as a set
            if let multimediaItems = article.multimedia {
                let multimediaSet = articleEntity.multimediaEntity?.mutableCopy() as? NSMutableSet ?? NSMutableSet()
                
                multimediaItems.forEach { multimediaItem in
                    let multimediaEntity = MultimediaEntity(context: context)
                    multimediaEntity.url = multimediaItem.url
                    
                    // Add to the multimedia set
                    multimediaSet.add(multimediaEntity)
                }
                
                // Set the multimedia relationship
                articleEntity.multimediaEntity = multimediaSet
            }
        }
        
        saveContext()
    }

}
