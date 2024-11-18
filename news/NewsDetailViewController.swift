//
//  NewsDetailsViewController.swift
//  news
//
//  Created by Кирилл  on 18.11.2024.
//


import UIKit

class NewsDetailViewController: UIViewController {
    private let news: News

    init(news: News) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .orange

        let titleLabel = UILabel()
        titleLabel.text = news.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0

        let authorLabel = UILabel()
        authorLabel.text = "Автор: \(news.author ?? "Неизвестно")"
        authorLabel.font = UIFont.systemFont(ofSize: 16)
        authorLabel.textColor = .gray

        let dateLabel = UILabel()
        dateLabel.text = news.publishedAt ?? "Неизвестно"
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray

        let contentLabel = UILabel()
        contentLabel.text = news.content ?? "Текст отсутствует"
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.numberOfLines = 0

        let stackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel, dateLabel, contentLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
}
