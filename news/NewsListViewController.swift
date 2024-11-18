//
//  NewsListViewController.swift
//  news
//
//  Created by Кирилл  on 18.11.2024.
//

import UIKit
import Combine

class NewsListViewController: UIViewController {
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let segmentControl = UISegmentedControl(items: ["Дата", "Популярность"])
    private let viewModel = NewsListViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        title = "Новости"
        view.backgroundColor = .red
        
        // Search Bar
        searchBar.placeholder = "Поиск новостей"
        searchBar.delegate = self
        navigationItem.titleView = searchBar

        // Segment Control
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(sortChanged), for: .valueChanged)
        view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        // TableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.$newsList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingIndicator()
                } else {
                    self?.hideLoadingIndicator()
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func sortChanged() {
        viewModel.sortBy = segmentControl.selectedSegmentIndex == 0 ? "publishedAt" : "popularity"
        viewModel.fetchNews(query: viewModel.searchText, reset: true)
    }

    private func showLoadingIndicator() {
        let footerView = UIActivityIndicatorView(style: .medium)
        footerView.startAnimating()
        tableView.tableFooterView = footerView
    }

    private func hideLoadingIndicator() {
        tableView.tableFooterView = nil
    }
}

extension NewsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
}

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.newsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let news = viewModel.newsList[indexPath.row]
        cell.textLabel?.text = news.title
        cell.detailTextLabel?.text = news.publishedAt
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = viewModel.newsList[indexPath.row]
        let detailVC = NewsDetailViewController(news: news)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.height * 2 {
            viewModel.loadMoreIfNeeded(currentIndex: viewModel.newsList.count - 1)
        }
    }
    
}


