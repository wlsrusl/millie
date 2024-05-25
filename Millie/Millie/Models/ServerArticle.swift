//
//  Article.swift
//  Millie
//
//  Created by JG on 2024/05/23.
//

import Foundation

struct ServerArticle: Codable {
    let title: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
}

struct NewsResponse: Codable {
    let articles: [ServerArticle]
    let status: String
    let totalResults: Int
}
