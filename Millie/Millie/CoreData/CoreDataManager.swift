//
//  CoreDataManager.swift
//  Millie
//
//  Created by JG on 2024/05/24.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}

    // 저장소 컨테이너
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Millie")
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true // 자동 마이그레이션 설정
        description?.shouldInferMappingModelAutomatically = true // 매핑 모델 자동 추론 설정

        // 저장소 로드
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // 저장소 로드 실패 시 에러 처리
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // Core Data 작업을 위한 컨텍스트
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // 컨텍스트의 변경 사항 저장
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                // 저장 에러 처리
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // 기사를 Core Data에 저장
    func saveArticles(_ articles: [LocalArticle]) {
        for article in articles {
            let newArticle = ArticleEntity(context: context)
            newArticle.title = article.title
            newArticle.url = article.url
            newArticle.urlToImage = article.urlToImage
            newArticle.publishedAt = article.publishedAt
            newArticle.isRead = article.isRead
        }
        saveContext() // 변경 사항 저장
    }

    // Core Data에서 기사 가져오기
    func fetchArticles() -> [LocalArticle] {
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            // 가져온 ArticleEntity 객체를 LocalArticle로 매핑
            return result.map { LocalArticle(title: $0.title ?? "", url: $0.url ?? "", urlToImage: $0.urlToImage, publishedAt: $0.publishedAt ?? "", isRead: $0.isRead) }
        } catch {
            // 가져오기 에러 처리
            print("Failed to fetch articles: \(error)")
            return []
        }
    }
}


