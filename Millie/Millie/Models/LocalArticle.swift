//
//  LocalArticle.swift
//  Millie
//
//  Created by JG on 2024/05/25.
//

import Foundation

struct LocalArticle: Codable {
    let title: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    var isRead: Bool = false
}
