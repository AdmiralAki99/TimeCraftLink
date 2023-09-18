//
//  SearchTrackCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-27.
//

import UIKit

class SearchTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchTrackCollectionViewCell"
    
    private let albumArtwork : UIImageView = {
        let albumArtwork = UIImageView()
        albumArtwork.image = UIImage(systemName: "photo")
        albumArtwork.contentMode = .scaleAspectFill
        return albumArtwork
    }()
    
    private let albumName : UILabel = {
        let albumName = UILabel()
        albumName.numberOfLines = 0
        albumName.font = .systemFont(ofSize: 16, weight: .semibold)
        albumName.textColor = .label
        return albumName
    }()
    
    private let artistName : UILabel = {
        let artistName = UILabel()
        artistName.numberOfLines = 0
        artistName.font = .systemFont(ofSize: 14, weight: .semibold)
        return artistName
    }()
    
    private let albumType : UILabel = {
        let albumType = UILabel()
        albumType.numberOfLines = 0
        albumType.font = .systemFont(ofSize: 14 , weight: .semibold)
        return albumType
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        contentView.addSubview(albumArtwork)
        contentView.addSubview(albumName)
        contentView.addSubview(artistName)
//        contentView.addSubview(albumType)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumName.sizeToFit()
        artistName.sizeToFit()
        albumType.sizeToFit()
        
        let image_size : CGFloat = contentView.height - 10
        
        let albumLabel = self.albumName.sizeThatFits(CGSize(width: contentView.width - image_size - 10, height: contentView.height - 10))
        
        let artwork_specs : CGFloat = contentView.height - 10
        albumArtwork.frame = CGRect(x: 5, y: 5, width: artwork_specs, height: artwork_specs)
        
        artistName.frame = CGRect(x: albumArtwork.right + 10, y: albumName.height + 5, width: contentView.width - albumArtwork.right - 5, height: min(80,artistName.height) )
        
        albumType.frame = CGRect(x: albumArtwork.right + 10, y: albumArtwork.bottom - 30, width: albumType.width + 30, height: 50)
        
        albumName.frame = CGRect(x: albumArtwork.right + 10, y: 5, width: albumLabel.width, height: min(80,albumLabel.height))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumName.text = nil
        artistName.text = nil
        albumType.text = nil
        albumArtwork.image = nil
    }
    
    func generateViewCell(with viewModel: Track){
        albumName.text = viewModel.album?.name
        albumArtwork.sd_setImage(with: URL(string: viewModel.album?.images.first?.url ?? "-"))
        artistName.text = viewModel.artists.first?.name
    }
}
