//
//  APIKey.swift
//  news
//
//  Created by Кирилл  on 18.11.2024.
//

import Foundation
import Combine

class NewsService {
    
    func fetchNews(query: String, page: Int, sortBy: String) -> AnyPublisher<[News], Error> {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=apple&from=2024-11-16&to=2024-11-16&sortBy=popularity&apiKey=ec93ee2897d548a999f265a4d339047b") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .map { $0.articles }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
