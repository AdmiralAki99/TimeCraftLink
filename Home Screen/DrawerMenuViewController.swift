//
//  DrawerMenuViewController.swift
//  Drawer Menu App
//
//  Created by Artem Korzh on 26.09.2020.
//

import UIKit

class DrawerMenuViewController: UIViewController {

    let transitionManager = DrawerTransitionManager()
    
    let profilePhoto : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    let profileNameLabel : UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title2)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Profile Name"
        return label
    }()
    
    let profileSubtitle : UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Profile Subtitle"
        return label
    }()
    
    let divider : UIView = UIView()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = transitionManager
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPurple
        
        initializeProfileBackground()
        

        // Do any additional setup after loading the view.
    }
    
    func initializeProfileBackground(){
        view.addSubview(profilePhoto)
        view.addSubview(profileNameLabel)
        view.addSubview(profileSubtitle)
        view.addSubview(divider)
        
        profilePhoto.frame = CGRect(x: 20, y: 80, width: 60, height: 60)
        profilePhoto.backgroundColor = .white
        profilePhoto.layer.cornerRadius = 30
        profilePhoto.layer.masksToBounds = true
        
        profileNameLabel.frame = CGRect(x: profilePhoto.right + 20, y: 80, width: view.width - (profilePhoto.right + 20), height: 30)
        
        profileSubtitle.frame = CGRect(x: profilePhoto.right + 20, y: profileNameLabel.bottom, width: view.width - (profilePhoto.right + 20), height: 20)
        
        divider.frame = CGRect(x: 0, y: profileSubtitle.bottom + 30, width: view.width * 0.72, height: 1.0)
        
        divider.layer.borderWidth = 1.0
        divider.layer.borderColor = UIColor.black.cgColor
    }
    
    func initializeMenu(){
        
    }

}
