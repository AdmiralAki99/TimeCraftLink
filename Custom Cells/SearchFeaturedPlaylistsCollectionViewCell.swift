//
//  SearchFeaturedPlaylistsCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-27.
//

import UIKit

class SearchFeaturedPlaylistsCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchFeaturedPlaylistsCollectionViewCell"
    
    private let playlistNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14,weight: .bold)
        return label
    }()
    
    private let playlistArtwork : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let cellTypeLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(playlistArtwork)
//        addSubview(playlistNameLabel)
//        addSubview(cellTypeLabel)
        
        playlistArtwork.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        playlistNameLabel.frame = CGRect(x: playlistArtwork.right + 10, y: 5, width: contentView.width, height: 30)
        
        cellTypeLabel.frame = CGRect(x: playlistArtwork.right + 10, y: playlistNameLabel.bottom - 20, width: contentView.width, height: 40)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        playlistArtwork.image = nil
    }
    
    func generateViewCell(with playlist:Playlist){
        playlistNameLabel.text = playlist.name
        playlistArtwork.sd_setImage(with: URL(string:playlist.images.first?.url ?? "-"))
        cellTypeLabel.text = "Playlist"
    }
}
