//
//  AlbumCollectionReusableView.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-20.
//
import SDWebImage
import UIKit

protocol AlbumHeaderReusableViewDelegate : AnyObject {
    func albumHeaderReusableViewPlayAllButton(_ header: AlbumCollectionReusableView)
}

final class AlbumCollectionReusableView: UICollectionReusableView {
    static let identifier = "PlaylistHeaderReusableView"
    
    weak var delegate: AlbumHeaderReusableViewDelegate?
    
    private let playlistNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 0
//        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ownerLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let ownerImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let albumArtwork : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemRed
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private let playAllButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(albumArtwork)
        addSubview(playlistNameLabel)
        addSubview(descriptionLabel)
        addSubview(ownerLabel)
        addSubview(ownerImage)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = height/1.4
        
        albumArtwork.frame = CGRect(x: 85, y: 0, width: imageSize, height: imageSize)
//        playlistNameLabel.frame = CGRect(x: 10, y: albumArtwork.bottom, width: width - 20, height: 24)
        descriptionLabel.frame = CGRect(x: 10, y: albumArtwork.bottom, width: width, height: 28)
        ownerImage.frame = CGRect(x: 10, y: descriptionLabel.bottom, width: 30, height: 30)
        ownerLabel.frame = CGRect(x: ownerImage.right + 10, y: descriptionLabel.bottom-5, width: width, height: 44)
        
        playAllButton.frame = CGRect(x: width-80, y: height - 60, width: 50, height: 50)
        
    }
    
    func configure(with playlistModel : PlaylistScreenPreview){
        playlistNameLabel.text = playlistModel.name
        descriptionLabel.text = playlistModel.description
        albumArtwork.sd_setImage(with: playlistModel.albumArtwork,completed: nil)
        ownerLabel.text = playlistModel.authorName
//        ownerImage.sd_setImage(with: playlistModel.authorArtwork,completed: nil)
    }
    
    @objc private func didTapPlayButton(){
        delegate?.albumHeaderReusableViewPlayAllButton(self)
    }
    
}

