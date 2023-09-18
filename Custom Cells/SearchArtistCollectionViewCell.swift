//
//  SearchArtistCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-26.
//
import SDWebImage
import UIKit

class SearchArtistCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchArtistCollectionViewCell"
    
    private let artistImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let artistNameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14,weight: .bold)
        return label
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
        addSubview(artistImage)
        addSubview(artistNameLabel)
        addSubview(cellTypeLabel)
        
        artistImage.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        artistImage.layer.cornerRadius = 20
        
        artistNameLabel.frame = CGRect(x: artistImage.right + 10, y: 5, width: contentView.width, height: 30)
        
        cellTypeLabel.frame = CGRect(x: artistImage.right + 10, y: artistNameLabel.bottom - 20, width: contentView.width, height: 40)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artistNameLabel.text = nil
        artistImage.image = nil
        cellTypeLabel.text = nil
    }
    
    func generateViewCell(with artist: Artist){
        artistNameLabel.text = artist.name
        cellTypeLabel.text = artist.type
    }
}
