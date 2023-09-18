//
//  MapResultCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-06.
//

import UIKit

class FriendInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "FriendInfoCollectionViewCell"
    
    let userImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    let userName : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "User Name"
        label.textAlignment = .center
        label.layer.cornerRadius = 25
        label.layer.masksToBounds = true
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        addSubview(userImage)
        addSubview(userName)
//        backgroundColor = .green
        
        userImage.frame = CGRect(x: 25, y: 20, width: 55, height: 55)
        
        userName.frame = CGRect(x: 0, y: userImage.bottom + 10, width: 100, height: 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func generateCell(with friendInfo: FriendInfo){
        userName.text = friendInfo.name
    }
    
}
