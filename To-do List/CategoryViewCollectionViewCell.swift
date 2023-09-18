//
//  CategoryViewCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-17.
//

import UIKit

class CategoryViewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryViewCollectionViewCell"
    
    var categoryColour : UIColor?
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    var iconImage : UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override func layoutSubviews() {
        addSubview(categoryLabel)
        addSubview(iconImage)
        
        backgroundColor = .clear
        
        iconImage.frame = CGRect(x: 80, y: 30, width: 25, height: 25)

        categoryLabel.frame = CGRect(x: 0, y: iconImage.bottom + 10, width: width, height: 20)
        
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    func generateViewCell(category : ToDoListCategory){
        categoryLabel.text = category.categoryName
        iconImage = category.icon
        iconImage.tintColor = .white
//        iconImage.layer.borderColor = category.colour.cgColor
//        iconImage.layer.borderWidth = 1
        
        
    }
    
}
