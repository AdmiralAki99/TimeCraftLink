//
//  DrawerMenuCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-21.
//

import UIKit

class DrawerMenuCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DrawerMenuCollectionViewCell"
    
    let menuLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Menu Label"
        return label
    }()
    
    let menuIcon : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .white
        return imageView
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(menuLabel)
        addSubview(menuIcon)
        
        menuIcon.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuLabel.frame = CGRect(x: 40, y: 5, width: (width-70), height: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func generateViewCell(menuName : String, icon : String){
        menuLabel.text = menuName
        menuIcon.image = UIImage(systemName: icon)
    }
    
}
