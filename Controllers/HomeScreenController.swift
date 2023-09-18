//
//  ViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-08.
//

//todo: Implement Basic Background

import UIKit

enum sectionType{
    case newReleases(viewModels : [NewReleasesPreview])
    case featuredPlaylists(viewModels : [FeaturedPlaylistsPreview])
    case recommmenedTracks(viewModels : [RecommendedSongPreview])
    
    var title : String{
        switch self{
        case .newReleases:
            return "New Releases"
            break;
        case .featuredPlaylists:
            return "Featured Playlists"
            break
        case .recommmenedTracks:
            return "Recommended Tracks"
            break
        }
    }
}

class HomeScreenController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate{
    
    private var albums : [Album] = []
    private var playlist : [Playlist] = []
    private var recommended_songs : [Track] = []
    
    private var collectionView : UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return HomeScreenController.createSectionLayout(section: sectionIndex)
    })
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    private var home_sections = [sectionType]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        
       
        configureCollectionView()
        view.addSubview(spinner)
        // Do any additional setup after loading the view.
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureCollectionView(){
        view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        
        collectionView.register(FeaturedPlaylistsCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier)
        
        collectionView.register(RecommendationCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationCollectionViewCell.identifier)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        
        collectionView.dataSource = self
        
        collectionView.delegate = self
    }
    
    private func fetchData(){
        
        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases : NewReleases?
        
        var featuredPlaylists : FeaturedPlaylists?
        
        var recommendation: Recommendations?
        
        SpotifyAPIManager.api_manager.getNewReleases { result in
            defer{
                group.leave()
            }
            switch result{
            case .success(let response):
                newReleases = response
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        SpotifyAPIManager.api_manager.getFeaturedPlaylists { result in
            defer{
                group.leave()
            }
            switch result {
            case .success(let playlist):
                featuredPlaylists = playlist
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        SpotifyAPIManager.api_manager.getRecommendationGenres { result in
            switch result{
            case .success(let model):
                var seeds = Set<String>()
                while seeds.count < 5{
                    if let random = model.genres.randomElement(){
                        seeds.insert(random)
                    }
                }
                
                SpotifyAPIManager.api_manager.getRecommendations(genres: seeds) { recommendations in
                    defer{
                        group.leave()
                    }
                    switch recommendations{
                    case .success(let response):
                        recommendation = response
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    }
                    
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
        group.notify(queue: .main){
            guard let albums = newReleases?.albums.items,
                  let playlists = featuredPlaylists?.playlists.items,
                  let recommended_songs = recommendation?.tracks else{
                return
            }
            self.populateSections(albums: albums, playlists: playlists, recommended_songs: recommended_songs)
        }
        
    }
    
    private func populateSections(albums:[Album],playlists:[Playlist],recommended_songs:[Track]){
        
        self.albums = albums
        self.playlist = playlists
        self.recommended_songs = recommended_songs
        
        home_sections.append(.newReleases(viewModels: albums.compactMap({
            return NewReleasesPreview(name: $0.name, image: URL(string:$0.images.first?.url ?? ""), artistName: $0.artists.first?.name ?? "-", album_type: $0.album_type)
        })))
        home_sections.append(
            .featuredPlaylists(viewModels: playlists.compactMap({
                return FeaturedPlaylistsPreview(name: $0.name, playlistURL: URL(string:$0.images.first?.url ?? "-"), author: $0.owner.display_name,description: $0.description)
        })))
        home_sections.append(.recommmenedTracks(viewModels: recommended_songs.compactMap({
            return RecommendedSongPreview(name: $0.name, artworkURL: URL(string:$0.album?.images.first?.url ?? "-"), artistName: $0.artists.first?.name ?? "-" )
        })))
        
        collectionView.reloadData()
    }
    
    @objc func didTapSettings(){
        let settingsViewController = SettingsViewController()
        settingsViewController.navigationItem.largeTitleDisplayMode = .never
        settingsViewController.title = "Settings"
        navigationController?.pushViewController(settingsViewController, animated: true)
        
    }
    

}

extension HomeScreenController{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            let section = home_sections[section]
            switch section{

            case .newReleases(let viewModels):
                return viewModels.count
            case .featuredPlaylists(let viewModels):
                return viewModels.count
            case .recommmenedTracks(let viewModels):
                return viewModels.count
            }
        }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return home_sections.count
    }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let section = home_sections[indexPath.section]
            
            switch section{

            case .newReleases(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else{
                    return UICollectionViewCell()
                }
                let model = viewModels[indexPath.row]
                cell.generateViewCell(with: model)
               return cell
            case .featuredPlaylists(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistsCollectionViewCell else{
                    return UICollectionViewCell()
                }
                
                cell.generateViewCell(with: viewModels[indexPath.row])
               return cell
            case .recommmenedTracks(let viewModels):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCollectionViewCell.identifier, for: indexPath) as? RecommendationCollectionViewCell else{
                    return UICollectionViewCell()
                }
                cell.generateViewCell(with: viewModels[indexPath.row])
               return cell
            }
        }
    
    static func createSectionLayout(section : Int) -> NSCollectionLayoutSection {
        let sectionHeaders = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let vertical_group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(250), heightDimension: .absolute(250)), subitem: item, count: 3 )
            
            let horizontal_group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(250), heightDimension: .absolute(250)), subitem: vertical_group, count: 1)
            let section = NSCollectionLayoutSection(group: horizontal_group)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = sectionHeaders
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let vertical_group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200)), subitem: item, count: 1)
            
            let horizontal_group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)), subitem: vertical_group, count: 1)
            let section = NSCollectionLayoutSection(group: horizontal_group)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = sectionHeaders
            return section
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = sectionHeaders
            return section
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), subitem: item, count:  1)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let section = home_sections[indexPath.section]
        
        switch section{
            case .featuredPlaylists:
                let featuredPlaylist = playlist[indexPath.row]
                let playlistViewController = PlaylistViewController(playlist: featuredPlaylist)
                playlistViewController.title = featuredPlaylist.name
                navigationController?.pushViewController(playlistViewController, animated: true)
            break
            case .newReleases:
                let newAlbum = albums[indexPath.row]
                let albumViewController = AlbumViewController(album: newAlbum)
                navigationController?.pushViewController(albumViewController, animated: true  )
            break
            case.recommmenedTracks:
                let recommended_song = recommended_songs[indexPath.row]
            MusicPlaybackViewer.shared.startPlayback(from: self, track: recommended_song)
                
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as? SectionHeader, kind == UICollectionView.elementKindSectionHeader else{
            return UICollectionReusableView()
        }
        
        let section = indexPath.section
        let model = home_sections[section]
        
        header.configure(with: model.title)
        
        return header
    }
    
    
}

