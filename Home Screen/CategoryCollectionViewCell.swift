//
//  CategoryCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-13.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "CategoryCollectionViewCell"
    
    let categoryImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
//        label.font = .preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = true
        label.textAlignment = .left
        label.text = "New Releases"
        label.numberOfLines = 0
        return label
    }()
    
    var categoryViewController : UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(categoryImageView)
        addSubview(categoryLabel)
        
        categoryImageView.frame = bounds
        backgroundColor = .gray
        
        categoryLabel.frame = CGRect(x: 10, y: 10, width: width, height: 20)
        
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func initializeViewController(with viewController : UIViewController){
        self.categoryViewController = viewController
    }
    
    func generateCell(with viewController: UIViewController,image : String,title : String){
        
        initializeViewController(with: viewController)
        categoryLabel.text = title
        
    }
    
    func getViewController() -> UIViewController{
        guard let viewController = categoryViewController else{
            return UIViewController()
        }
        return viewController
    }
    
}
