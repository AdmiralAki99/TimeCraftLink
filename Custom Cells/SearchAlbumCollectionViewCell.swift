//
//  SearchAlbumCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-27.
//

import UIKit

class SearchAlbumCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchAlbumCollectionViewCell"
    
    private let albumNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14,weight: .bold)
        return label
    }()
    
    private let albumArtwork : UIImageView = {
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
        addSubview(albumArtwork)
        addSubview(albumNameLabel)
        addSubview(cellTypeLabel)
        
        backgroundColor = .clear
        
        albumArtwork.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        albumNameLabel.frame = CGRect(x: albumArtwork.right + 10, y: 5, width: contentView.width, height: 30)
        
        cellTypeLabel.frame = CGRect(x: albumArtwork.right + 10, y: albumNameLabel.bottom - 20, width: contentView.width, height: 40)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        albumArtwork.image = nil
    }
    
    func generateViewCell(with album:Album){
        albumNameLabel.text = album.name
        albumArtwork.sd_setImage(with: URL(string: album.images.first?.url ?? "-"))
        cellTypeLabel.text = "Album: "+(album.artists.first?.name ?? "-")
    }
}
