//
//  CategoryPlaylistViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-24.
//

import UIKit

class CategoryPlaylistViewController: UIViewController {
    
    let categoryInfo : CategoryInfo
    
    private var categoryPlaylists = [Playlist]()
    
    private let categoryPlaylistCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.0, leading: 5.0, bottom: 2.0, trailing: 5.0)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(180)),subitem: item , count: 2)
        
//        group.contentInsets = NSDirectionalEdgeInsets(top: 2.0, leading: 2.0, bottom: 2.0, trailing: 2.0)
        
        return NSCollectionLayoutSection(group: group)
        
    }))
    
    init(categoryInfo: CategoryInfo) {
        self.categoryInfo = categoryInfo
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryInfo.name
        
        view.addSubview(categoryPlaylistCollectionView)
        view.backgroundColor = .systemBackground
        categoryPlaylistCollectionView.backgroundColor = .systemBackground
        
        categoryPlaylistCollectionView.register(CategoryPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: CategoryPlaylistCollectionViewCell.identifier)
        
        categoryPlaylistCollectionView.delegate = self
        categoryPlaylistCollectionView.dataSource = self
        
        SpotifyAPIManager.api_manager.getCategoryPlaylists(with: categoryInfo) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let playlist):
                    self.categoryPlaylists = playlist
                    self.categoryPlaylistCollectionView.reloadData()
                case .failure(let error):
                    break
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryPlaylistCollectionView.frame = view.bounds
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

extension CategoryPlaylistViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryPlaylists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoryPlaylistCollectionView.dequeueReusableCell(withReuseIdentifier: CategoryPlaylistCollectionViewCell.identifier, for: indexPath) as?  CategoryPlaylistCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        let playlist = categoryPlaylists[indexPath.row]
        
        cell.generateViewCell(with: FeaturedPlaylistsPreview(name: playlist.name, playlistURL:URL(string: playlist.images.first?.url ?? "-"), author: playlist.owner.display_name, description: playlist.description))
        
        cell.layer.cornerRadius = 2
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playlistViewController = PlaylistViewController(playlist: categoryPlaylists[indexPath.row])
        navigationController?.pushViewController(playlistViewController, animated: true)
    }
    
}
