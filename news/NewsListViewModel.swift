//
//  NewsListViewModel.swift
//  news
//
//  Created by Кирилл  on 18.11.2024.
//

import Foundation
import Combine

class NewsListViewModel {
    @Published var newsList: [News] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var sortBy: String = "publishedAt" 

    private var cancellables = Set<AnyCancellable>()
    private let newsService = NewsService()
    private var page = 1
    private var canLoadMore = true

    init() {
        setupSearchListener()
    }
    
    private func setupSearchListener() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { $0.count >= 3 }
            .sink { [weak self] query in
                self?.fetchNews(query: query, reset: true)
            }
            .store(in: &cancellables)
    }
    
    func fetchNews(query: String, reset: Bool = false) {
        
        guard !isLoading, canLoadMore else { return }

        if reset {
            page = 1
            canLoadMore = true
            newsList.removeAll()
        }

        isLoading = true

        newsService.fetchNews(query: query, page: page, sortBy: sortBy)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.canLoadMore = false
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] newArticles in
                guard let self = self else { return }
                if newArticles.count < 20 {
                    self.canLoadMore = false
                }
                self.newsList.append(contentsOf: newArticles)
                self.page += 1
            })
            .store(in: &cancellables)
    }
    
    func loadMoreIfNeeded(currentIndex: Int) {
        if currentIndex == newsList.count - 1 {
            fetchNews(query: searchText)
        }
    }
}
