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
        
        return imageView
    }()
    
    let profileNameLabel : UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let profileUserNameLabel : UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    let profileEmail : UILabel = {
        let label = UILabel()
        
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
