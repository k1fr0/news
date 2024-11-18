//
//  NewsResponse.swift
//  news
//
//  Created by Кирилл  on 18.11.2024.
//

import Foundation

struct NewsResponse: Codable{
    let articles: [News]
}

struct News: Codable{
    let title: String
    let description: String
    let author: String?
    let publishedAt: String?
    let content: String
}
