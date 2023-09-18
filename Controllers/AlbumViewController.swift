//
//  AlbumViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-14.
//

import UIKit

class AlbumViewController: UIViewController {

    private let selectedAlbum : Album
    
    private var songQueue = [AlbumDetailsTrack]()
    
    private var songList = [SongsList]()
    
    private var recommendedPlaylists = [FeaturedPlaylistsPreview]()
    
    private let albumCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _  -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)))
    
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
    
    
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(70)), subitem: item, count: 1)

            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
            ]
            return section
        }))

    init(album: Album){
        self.selectedAlbum = album
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedAlbum.name
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view.
        
        view.addSubview(albumCollectionView)
        
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        
        albumCollectionView.register(PlaylistHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderReusableView.identifier)
        albumCollectionView.register(AlbumTracksCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTracksCollectionViewCell.identifier)
        albumCollectionView.register(FeaturedPlaylistsCollectionViewCell.self,forCellWithReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier)
        
        fetchData()
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))
    }
    
    func fetchData(){
        
        let group = DispatchGroup()
        
        var playlist = [FeaturedPlaylistsPreview]()
        
        group.enter()
        group.enter()
        group.enter()
        
        SpotifyAPIManager.api_manager.getAlbumDetails(for: selectedAlbum) { result in
            DispatchQueue.main.async {
                defer{
                    group.leave()
                }
                switch result{
                case .success(let albumDetails):
                    self.songQueue = albumDetails.tracks.items
                    self.songList = albumDetails.tracks.items.compactMap({
                        if($0.artists.count > 1){
                            return SongsList(name: $0.name, artworkURL: nil , artistName: $0.artists.first?.name ?? "-",secondArtistName: $0.artists[1].name)
                        }else{
                           return SongsList(name: $0.name, artworkURL: nil , artistName: $0.artists.first?.name ?? "-",secondArtistName: "")
                        }
                        })
                self.albumCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        SpotifyAPIManager.api_manager.getFeaturedPlaylistsFromAlbum(with: selectedAlbum) { result in
            DispatchQueue.main.async {
                defer{
                    group.leave()
                }
                switch result{
                case .success(let result):
                    self.recommendedPlaylists = result.items.compactMap({
                        FeaturedPlaylistsPreview(name: $0.name, playlistURL: URL(string: $0.album?.images.first?.url ?? "-"), author: $0.artists.first?.name ?? "-", description: "-")
                    })
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        albumCollectionView.frame = view.bounds
    }
    
//    @objc private func didTapShareButton(){
//        guard let share_url = URL(string: selectedAlbum.external_urls["spotify"] ?? "")else{
//                return
//            }
//        let viewController = UIActivityViewController(activityItems: [share_url], applicationActivities: [])
//
//        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
//
//        present(viewController,animated: true)
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



}

extension AlbumViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return songList.count
       }
   
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTracksCollectionViewCell.identifier, for: indexPath) as? AlbumTracksCollectionViewCell  else{
               return UICollectionViewCell()
           }
           cell.generateViewCell(with: songList[indexPath.row])
           return cell
       }
   
       func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           guard let header = albumCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderReusableView.identifier, for: indexPath ) as? PlaylistHeaderReusableView, kind == UICollectionView.elementKindSectionHeader else{
               return UICollectionReusableView()
           }
           let playlist = PlaylistScreenPreview(name: selectedAlbum.name, authorName: selectedAlbum.artists.first?.name, description: "Release Date: \(String.formattedDate(string: selectedAlbum.release_date))", albumArtwork: URL(string:selectedAlbum.images.first?.url ?? "-"), authorArtwork: URL(string: selectedAlbum.artists.first?.uri ?? "-"))
   
           header.configure(with: playlist)
//           header.delegate = self
           return header
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let selectedTrack = songQueue[index]
        
        MusicPlaybackViewer.shared.startPlayback(from: self, track: selectedTrack)
    }
    
}


//

//
//
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//extension AlbumViewController{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return recommendedSongs.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCollectionViewCell.identifier, for: indexPath) as? RecommendationCollectionViewCell  else{
//            return UICollectionViewCell()
//        }
//        cell.generateViewCell(with: recommendedSongs[indexPath.row])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let header = playlistCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderReusableView.identifier, for: indexPath ) as? PlaylistHeaderReusableView, kind == UICollectionView.elementKindSectionHeader else{
//            return UICollectionReusableView()
//        }
//        let playlist = PlaylistScreenPreview(name: selectedPlaylist.name, authorName: selectedPlaylist.owner.display_name, description: selectedPlaylist.description, albumArtwork: URL(string:selectedPlaylist.images.first?.url ?? "-"),authorArtwork: URL(string: selectedPlaylist.owner.uri))
//
//        header.configure(with: playlist)
//        header.delegate = self
//        return header
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scroll = 2
//    }
//
//}
//
//}
//

extension AlbumViewController : AlbumHeaderReusableViewDelegate{
    func albumHeaderReusableViewPlayAllButton(_ header: AlbumCollectionReusableView) {
        
    }
}
