//
//  ArticlesVC.swift
//  ArticlesTask
//
//  Created by Sivaji Palla on 25/09/24.
//

import UIKit
import Combine

import UIKit
import Combine

class ArticlesVC: UIViewController {

    @IBOutlet weak var articlesTV: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var viewModel = ArticleViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        fetchArticles()
    }

    private func setupTableView() {
        articlesTV.delegate = self
        articlesTV.dataSource = self
        articlesTV.register(UINib(nibName: ArticlesTVCell.identifier, bundle: nil), forCellReuseIdentifier: ArticlesTVCell.identifier)
    }

    private func bindViewModel() {
        viewModel.$articles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.articlesTV.reloadData()
                self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)

        // Bind isLoading to update activity indicator
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }

    private func fetchArticles() {
        viewModel.fetchArticles() // Fetch articles will handle loading state
    }
}

extension ArticlesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticlesTVCell.identifier, for: indexPath) as! ArticlesTVCell
        cell.article = viewModel.articles[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
