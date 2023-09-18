//
//  CategoryPlaylistCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-25.
//

import UIKit

class CategoryPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryPlaylistCollectionViewCell"

    private let playlistArtwork : UIImageView = {
        let albumArtwork = UIImageView()
        albumArtwork.image = UIImage(systemName: "photo")
        albumArtwork.contentMode = .scaleAspectFill
        return albumArtwork
    }()

    private let playlistName : UILabel = {
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
        contentView.addSubview(playlistArtwork)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let artwork_specs : CGFloat = contentView.height - 10
        playlistArtwork.frame = CGRect(x: 0, y: 0, width: 178, height: 180)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        playlistName.text = nil
        artistName.text = nil
        playlistArtwork.image = nil
    }

    func generateViewCell(with viewModel: FeaturedPlaylistsPreview){
        playlistName.text = viewModel.name
        artistName.text = viewModel.author
        playlistArtwork.sd_setImage(with: viewModel.playlistURL,completed: nil)
    }

}
