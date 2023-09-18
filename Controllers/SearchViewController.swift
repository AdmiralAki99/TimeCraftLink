//
//  SearchViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import UIKit

class SearchViewController: UIViewController {
    
    var categories = [CategoryInfo]()
    
    let searchController : UISearchController = {

        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "What do you want to listen to?"
        controller.searchBar.searchBarStyle = .minimal

        controller.definesPresentationContext = true
        return controller
        
    }()
    
    private let categoryCollectionView : UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(120)),subitem: item , count: 2)
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 1.0, leading: 1.0, bottom: 1.0, trailing: 1.0)
        
        return NSCollectionLayoutSection(group: group)
    }))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        view.addSubview(categoryCollectionView)
        
        categoryCollectionView.register(AudioGenresCollectionViewCell.self, forCellWithReuseIdentifier: AudioGenresCollectionViewCell.identifier)
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
//        SpotifyAPIManager.api_manager.getLikedSongs(with: 0) { result in
//            switch result{
//            case .success(let model):
//                break
//            case .failure(let error):
//                break
//            }
//        }
        
        SpotifyAPIManager.api_manager.getCategories { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self.categories = categories
                    self.categoryCollectionView.reloadData()
                    case .failure(let error):
                    break
                }
            }
            
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        categoryCollectionView.frame = view.bounds
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
//        resultSearchController.update(with results)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AudioGenresCollectionViewCell.identifier, for: indexPath) as? AudioGenresCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        let categoryInfo = categories[indexPath.row]
        
        cell.generateGenreViewCell(with: categoryInfo)
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryCollectionView.deselectItem(at: indexPath, animated: true)
        let categoryViewController = CategoryPlaylistViewController(categoryInfo: categories[indexPath.row])
        categoryViewController.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(categoryViewController, animated: true )
    }
    
    
}

extension SearchViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let resultSearchController = searchController.searchResultsController as? SearchResultViewController,
            let searchQuery = searchBar.text, !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        
        resultSearchController.delegate = self
        
        SpotifyAPIManager.api_manager.searchSpotify(with: searchQuery) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let searchResult):
                    resultSearchController.updateSearchResults(with: searchResult)
                case .failure(let error):
                    print(error.localizedDescription )
                    break
                }
            }
        }
    }
}

extension SearchViewController : SearchResultViewControllerDelegate{
    func showResult(_ controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }
}
