//
//  SearchViewController.swift
//  NTFXReplica
//
//  Created by Maziar Layeghkar on 09.06.24.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    //TODO: add title section here as a func like configureNavigationTitle
    
    //TODO4: How to have a searchBarController
    private let searchBarController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or a TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier) //TitleTableViewCell is a generic TVC
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        //TODO3: How to have large title in each view
        title = "Top Searches"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = searchBarController
        
        view.addSubview(searchTable)
        
        navigationController?.navigationBar.tintColor = .label
    
        searchTable.delegate = self
        searchTable.dataSource = self
        
        fetchSearchMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
    
    private func fetchSearchMovies() {
        APICaller.shared.getSearchMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.searchTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        let title = titles[indexPath.row]
        let model = TitleViewModel(posterURL: title.poster_path ?? "", titleName: title.original_name ?? title.original_title ?? "Unknown")
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
