//
//  SearchResultViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-22.
//

import UIKit

struct SearchResultSectionType{
    let title: String
    let items : [SearchResult]
}

protocol SearchResultViewControllerDelegate : AnyObject{
    func showResult(_ controller : UIViewController)
}

class SearchResultViewController: UIViewController {
    
    private var search_result_sections = [SearchResultSectionType]()
    
    var search : [SearchResultSectionType] = []
    
    weak var delegate : SearchResultViewControllerDelegate?

    
    private var collectionView : UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return SearchResultViewController.generateCollectionView(with: sectionIndex)
    })

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(SearchArtistCollectionViewCell.self, forCellWithReuseIdentifier: SearchArtistCollectionViewCell.identifier)
        collectionView.register(SearchPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: SearchPlaylistCollectionViewCell.identifier)
        collectionView.register(SearchAlbumCollectionViewCell.self, forCellWithReuseIdentifier: SearchAlbumCollectionViewCell.identifier)
        collectionView.register(SearchTrackCollectionViewCell.self, forCellWithReuseIdentifier: SearchTrackCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        
        collectionView.isHidden = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
        
    }
    
    static func generateCollectionView(with sectionIndex : Int)->NSCollectionLayoutSection{
        switch sectionIndex{
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
             
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
             
            return section
            
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
             
            return section
        case 3:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
             
            return section
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(10)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
             
            return section
        }
    }
    
    func updateSearchResults(with searchResult : [SearchResult]){
        
        let artists = searchResult.filter({
            switch $0{
            case .Artist:
                return true
            default:
                return false
            }
        })
        let playlists = searchResult.filter({
            switch $0{
            case .Playlist(let playlist):
                return true
            default:
                return false
            }
        })
        
        let albums = searchResult.filter({
            switch $0{
            case .Album:
                return true
            default:
                return false
            }
        })
        
        let tracks = searchResult.filter({
            switch $0{
            case .Track:
                return true
            default:
                return false
            }
        })
        
        let spotify_playlists = searchResult.filter({
            switch $0{
            case .Playlist(let playlist):
                if playlist.owner.display_name == "Spotify"{
                    return true
                }else{
                    return false
                }
            default:
                return false
            }
        })
        
        if artists.isEmpty{
            print(artists)
            search = [
                SearchResultSectionType(title: "Artist", items: [artists.first!]),
                SearchResultSectionType(title: "Playlists", items: playlists),
                SearchResultSectionType(title: "Albums", items: albums),
                SearchResultSectionType(title: "Tracks", items: tracks)
            ]
        }else{
            search = [
                SearchResultSectionType(title: "Artist", items: []),
                SearchResultSectionType(title: "Playlists", items: playlists),
                SearchResultSectionType(title: "Albums", items: albums),
                SearchResultSectionType(title: "Tracks", items: tracks),

               
            ]
        }
        
        
        
        collectionView.reloadData()
        collectionView.isHidden = search.isEmpty
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

extension SearchResultViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return search[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let searchResult = search[indexPath.section].items[indexPath.row]
        
        switch searchResult{
        case .Artist(let result):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchArtistCollectionViewCell.identifier, for: indexPath) as? SearchArtistCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.generateViewCell(with: result)
            return cell
        case .Playlist(let result):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPlaylistCollectionViewCell.identifier, for: indexPath) as? SearchPlaylistCollectionViewCell else{
                return UICollectionViewCell()
            }
            
            cell.generateViewCell(with: result)
            return cell
        case .Album(let result):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchAlbumCollectionViewCell.identifier, for: indexPath) as? SearchAlbumCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.generateViewCell(with: result)
            return cell
            
        case .Track(let result):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchTrackCollectionViewCell.identifier, for: indexPath) as? SearchTrackCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.generateViewCell(with: result)
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return search.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectionItem = search[indexPath.section].items[indexPath.row]
        
        switch selectionItem{
        case .Album(let album):
            let albumViewController = AlbumViewController(album: album)
            navigationController?.pushViewController(albumViewController, animated: true)
            delegate?.showResult(albumViewController)
        case .Artist:
            break
        case .Playlist(let playlist):
            let playlistViewController = PlaylistViewController(playlist: playlist)
            navigationController?.pushViewController(playlistViewController, animated: true)
            delegate?.showResult(playlistViewController)
        case .Track(let track):
            MusicPlaybackViewer.shared.startPlayback(from: self, track: track)
        }
    }
    
    
}






    
    
    
