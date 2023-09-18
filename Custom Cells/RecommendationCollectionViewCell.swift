//
//  RecommendationCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-12.
//

import UIKit

class RecommendationCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendationCollectionViewCell"
    
    private let recommendedSongArtwork : UIImageView = {
        let albumArtwork = UIImageView()
        albumArtwork.image = UIImage(systemName: "photo")
        albumArtwork.contentMode = .scaleAspectFill
        return albumArtwork
    }()
    
    private let recommendedSongName : UILabel = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(recommendedSongArtwork)
        contentView.addSubview(recommendedSongName)
        contentView.addSubview(artistName)
//        contentView.addSubview(albumType)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recommendedSongName.sizeToFit()
        artistName.sizeToFit()
        
        let image_size : CGFloat = contentView.height - 10
        
        let albumLabel = self.recommendedSongName.sizeThatFits(CGSize(width: contentView.width - image_size - 10, height: contentView.height - 10))
        
        let artwork_specs : CGFloat = contentView.height - 10
        recommendedSongArtwork.frame = CGRect(x: 5, y: 5, width: artwork_specs, height: artwork_specs)
        
        artistName.frame = CGRect(x: recommendedSongArtwork.right + 10, y: contentView.height/2, width: contentView.width - recommendedSongArtwork.right - 5, height: min(80,artistName.height) )
        
        recommendedSongName.frame = CGRect(x: recommendedSongArtwork.right + 10, y: 5, width: albumLabel.width, height: min(80,albumLabel.height))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recommendedSongName.text = nil
        artistName.text = nil
        recommendedSongArtwork.image = nil
    }
    
    func generateViewCell(with viewModel: RecommendedSongPreview){
        recommendedSongName.text = viewModel.name
        artistName.text = viewModel.artistName
        recommendedSongArtwork.sd_setImage(with: viewModel.artworkURL,completed: nil)
    }
    
}
