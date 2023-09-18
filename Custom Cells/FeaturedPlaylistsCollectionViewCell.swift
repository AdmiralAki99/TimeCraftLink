//
//  FeaturedPlaylistsCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-12.
//

import UIKit

class FeaturedPlaylistsCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistsCollectionViewCell"

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
        contentView.addSubview(playlistName)
        contentView.addSubview(artistName)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playlistName.sizeToFit()
        artistName.sizeToFit()

        let image_size : CGFloat = contentView.height - 10

        let albumLabel = self.playlistName.sizeThatFits(CGSize(width: contentView.width - image_size - 10, height: contentView.height - 10))

        let artwork_specs : CGFloat = contentView.height - 10
        playlistArtwork.frame = CGRect(x: 5, y: 5, width: artwork_specs, height: artwork_specs)

        artistName.frame = CGRect(x: playlistArtwork.right + 10, y: playlistName.height + 5, width: contentView.width - playlistArtwork.right - 5, height: min(80,artistName.height) )

        playlistName.frame = CGRect(x: playlistArtwork.right + 10, y: 5, width: albumLabel.width, height: min(80,albumLabel.height))
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
