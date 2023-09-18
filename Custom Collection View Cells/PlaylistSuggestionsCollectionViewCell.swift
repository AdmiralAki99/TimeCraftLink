//
//  PlaylistSuggestionsCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-20.
//

import UIKit

class PlaylistSuggestionsCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlaylistSuggestionsCollectionViewCell"
    
    private let albumArtwork : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func generateViewCell(with viewModel: Album){
//        recommendedSongName.text = viewModel.name
//        artistName.text = viewModel.artistName
    }
}
