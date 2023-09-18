//
//  PlaylistViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-14.
//

import UIKit

class PlaylistViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    private let selectedPlaylist : Playlist
    
    private var recommendedSongs = [RecommendedSongPreview]()
    
    private var songQueue = [Track]()
    
    private let playlistCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _  -> NSCollectionLayoutSection? in
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
        
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
        ]
        return section
    }))
    
    init(playlist: Playlist){
        self.selectedPlaylist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedPlaylist.name
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        
        view.addSubview(playlistCollectionView)
        
        playlistCollectionView.delegate = self
        playlistCollectionView.dataSource = self
        
        playlistCollectionView.register(PlaylistHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderReusableView.identifier)
        playlistCollectionView.register(RecommendationCollectionViewCell.self, forCellWithReuseIdentifier: RecommendationCollectionViewCell.identifier)
//        playlistCollectionView.register(FeaturedPlaylistsCollectionViewCell.self,forCellWithReuseIdentifier: FeaturedPlaylistsCollectionViewCell.identifier)
         
        SpotifyAPIManager.api_manager.getPlaylistsDetails(for: selectedPlaylist) { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let playlist):
                    self.songQueue = playlist.tracks.items.compactMap({$0.track})
                    self.recommendedSongs = playlist.tracks.items.compactMap({
                        RecommendedSongPreview(name: $0.track.name, artworkURL: URL(string: $0.track.album?.images.first?.url ?? "-") , artistName: $0.track.artists.first?.name ?? "-")
                    })
                    self.playlistCollectionView.reloadData()
                case .failure(let err):
                    break
                }
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))
    }
    
    @objc private func didTapShareButton(){
        guard let share_url = URL(string: selectedPlaylist.external_urls["spotify"] ?? "")else{
            return
        }
        let viewController = UIActivityViewController(activityItems: [share_url], applicationActivities: [])
        
        viewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(viewController,animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playlistCollectionView.frame = view.bounds
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

extension PlaylistViewController{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedSongs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendationCollectionViewCell.identifier, for: indexPath) as? RecommendationCollectionViewCell  else{
            return UICollectionViewCell()
        }
        cell.generateViewCell(with: recommendedSongs[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = playlistCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderReusableView.identifier, for: indexPath ) as? PlaylistHeaderReusableView, kind == UICollectionView.elementKindSectionHeader else{
            return UICollectionReusableView()
        }
        let playlist = PlaylistScreenPreview(name: selectedPlaylist.name, authorName: selectedPlaylist.owner.display_name, description: selectedPlaylist.description, albumArtwork: URL(string:selectedPlaylist.images.first?.url ?? "-"),authorArtwork: URL(string: selectedPlaylist.owner.uri))
        
        header.configure(with: playlist)
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let selectedTrack = songQueue[index]
        
        MusicPlaybackViewer.shared.startPlayback(from: self, track: selectedTrack)
    }
    
}

extension PlaylistViewController : PlaylistHeaderReusableViewDelegate{
    func playlistHeaderReusableViewPlayAllButton(_ header: PlaylistHeaderReusableView) {
        MusicPlaybackViewer.shared.startPlayback(from: self, tracks: songQueue)
    }
}
