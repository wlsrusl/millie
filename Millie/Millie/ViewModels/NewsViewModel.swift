//
//  NewsViewModel.swift
//  Millie
//
//  Created by JG on 2024/05/23.
//

import Foundation

class NewsViewModel {
    var articles: [LocalArticle] = []
    private var networkManager = NetworkManager.shared
    private var coreDataManager = CoreDataManager.shared

    // 네트워크에서 기사를 가져와서 Core Data에 저장, 실패 시 Core Data에서 가져옴
    func fetchArticles(completion: @escaping () -> Void) {
        networkManager.fetchTopHeadlines { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.coreDataManager.saveArticles(articles) // 가져온 기사들을 Core Data에 저장
            case .failure(_):
                self?.articles = self?.coreDataManager.fetchArticles() ?? [] // 네트워크 실패 시 Core Data에서 기사 가져옴
            }
            completion() // 완료 핸들러 호출
        }
    }
    
    // 기사를 읽은 것으로 표시하고 Core Data에 저장
    func markArticleAsRead(_ article: LocalArticle) {
        if let index = articles.firstIndex(where: { $0.url == article.url }) {
            articles[index].isRead = true // 기사를 읽은 것으로 표시
            coreDataManager.saveArticles(articles) // 변경 사항을 Core Data에 저장
        }
    }
}






