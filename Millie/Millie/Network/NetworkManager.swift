//
//  NetworkManager.swift
//  Millie
//
//  Created by JG on 2024/05/22.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()

    // 최신 헤드라인 기사를 가져오는 메서드
    func fetchTopHeadlines(completion: @escaping (Result<[LocalArticle], Error>) -> Void) {
        let url = "https://newsapi.org/v2/top-headlines?country=kr" // API URL
        let parameter: Parameters = ["apiKey": "6e829893efa0446c88daf87322aa5fd4"] // API 키 매개변수

        // Alamofire를 사용하여 네트워크 요청
        AF.request(url, method: .get, parameters: parameter)
            .validate() // 상태 코드와 Content-Type을 자동으로 확인
            .responseDecodable(of: NewsResponse.self) { response in
                switch response.result {
                case .success(let newsResponse):
                    // 성공
                    let localArticles = newsResponse.articles.map { article in
                        return LocalArticle(title: article.title,
                                            url: article.url,
                                            urlToImage: article.urlToImage,
                                            publishedAt: article.publishedAt)
                    }
                    completion(.success(localArticles))
                case .failure(let error):
                    // 실패
                    completion(.failure(error))
                }
            }
    }
}






