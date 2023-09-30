//
//  ProfileMenuCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-30.
//

import UIKit

class ProfileMenuCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProfileMenuCollectionViewCell"
    
    let cellImage : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        imageView.tintColor = .white
        return imageView
    }()
    
    let cellLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Cell Name"
        return label
    }()
    
    let arrowImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .white
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(cellImage)
        addSubview(cellLabel)
        addSubview(arrowImage)
        
        cellImage.frame = CGRect(x: 10, y: 3, width: 30, height: 30)
        cellLabel.frame = CGRect(x: cellImage.right + 5, y: 5, width: width - (cellImage.right - 30), height: 30)
        arrowImage.frame = CGRect(x: cellLabel.right - 60, y: 12.5, width: 10, height: 10)
        
//        layer.borderColor = UIColor.white.cgColor
//        layer.borderWidth = 1.0
//        layer.cornerRadius = 12
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func generateCell(iconName: String, cellName : String){
        cellImage.image = UIImage(systemName: iconName)
        cellLabel.text = cellName
    }
    
}
