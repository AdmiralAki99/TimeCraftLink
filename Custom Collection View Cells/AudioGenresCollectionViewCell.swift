//
//  AudioGenresCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-22.
//
import SDWebImage
import UIKit

class AudioGenresCollectionViewCell: UICollectionViewCell {
    static let identifier = "AudioGenreCollectionViewCell"
    
    private let genreImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let genreLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGreen
        addSubview(genreImageView)
        addSubview(genreLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        genreLabel.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width-20, height: contentView.height/2)
        
        genreImageView.frame = CGRect(x: contentView.width/2, y: 0, width: contentView.width/2, height: contentView.height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genreLabel.text = nil
        genreImageView.image = UIImage(systemName: "photo",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))
        
    }
    
    func generateGenreViewCell(with category : CategoryInfo){
        genreLabel.text = category.name
        genreImageView.sd_setImage(with: URL(string: category.icons.first?.url ?? "-"))
    }
    
}
