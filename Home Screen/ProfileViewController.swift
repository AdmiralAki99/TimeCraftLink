//
//  ProfileScreenViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    let profileNameLabel : UILabel = {
        let label = UILabel()
        label.text = "Akhilesh Warty"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
    let profileEmail : UILabel = {
        let label = UILabel()
        label.text = "akhileshwarty@gmail.com"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back_button = UIBarButtonItem(title: "Back",image: UIImage(systemName: "arrow.backward"), target: self, action: #selector(backButtonPressed))
        
        back_button.tintColor = .white
        
        navigationItem.leftBarButtonItem = back_button

        view.backgroundColor = .black
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(profileImageView)
        view.addSubview(profileNameLabel)
        view.addSubview(profileEmail)
        
        profileImageView.frame = CGRect(x: view.width/2 - 40, y: 150, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        
        profileNameLabel.frame = CGRect(x: 0, y: profileImageView.bottom, width: view.width - 10, height: 44)
        profileEmail.frame = CGRect(x: 0, y: profileNameLabel.bottom, width: view.width - 10, height: 30)
        
    }
    
    @objc func backButtonPressed(){
        dismiss(animated: true)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
