//
//  AlbumTracksCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-20.
//

import UIKit

class AlbumTracksCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTracksCollectionViewCell"
    
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
        artistName.textColor = .secondaryLabel
        artistName.font = .systemFont(ofSize: 14, weight: .semibold)
        return artistName
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(recommendedSongName)
        contentView.addSubview(artistName)
        backgroundColor = .red
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
        
        artistName.frame = CGRect(x: 5, y: 30, width: width, height: min(80,artistName.height) )
        
        recommendedSongName.frame = CGRect(x: 5, y: 5, width: albumLabel.width, height: min(80,albumLabel.height))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recommendedSongName.text = nil
        artistName.text = nil
    }
    
    func generateViewCell(with viewModel: SongsList){
        recommendedSongName.text = viewModel.name
        if(viewModel.secondArtistName != ""){
            artistName.text = viewModel.artistName + ", \(viewModel.secondArtistName ?? "")"
        }else{
            artistName.text = viewModel.artistName
        }
        
    }
}

