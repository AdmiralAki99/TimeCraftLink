//
//  ProfileScreenViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let profileCellInfo : [(String,String)] = [
        ("person.text.rectangle","User Name"),
        ("at.badge.plus","Email")
        
    ]
    
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
    
    private var collectionView : UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return ProfileViewController.generateCollectionView(with: sectionIndex)
    })
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back_button = UIBarButtonItem(title: "Back",image: UIImage(systemName: "arrow.backward"), target: self, action: #selector(backButtonPressed))
        
        back_button.tintColor = .white
        
        navigationItem.leftBarButtonItem = back_button

        view.backgroundColor = .black
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView.register(ProfileMenuCollectionViewCell.self, forCellWithReuseIdentifier: ProfileMenuCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(profileImageView)
        view.addSubview(profileNameLabel)
        view.addSubview(profileEmail)
        view.addSubview(collectionView)
        
        profileImageView.frame = CGRect(x: view.width/2 - 40, y: 150, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        
        profileNameLabel.frame = CGRect(x: 0, y: profileImageView.bottom, width: view.width - 10, height: 44)
        profileEmail.frame = CGRect(x: 0, y: profileNameLabel.bottom, width: view.width - 10, height: 30)
        
        collectionView.frame = CGRect(x: 10, y: profileEmail.bottom + 20, width: view.width - 10, height: view.height - (profileEmail.bottom + 20))
        
    }
    
    @objc func backButtonPressed(){
        dismiss(animated: true)
    }
    
    static func generateCollectionView(with sectionIndex: Int)-> NSCollectionLayoutSection{
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)

            return section
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

extension ProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileMenuCollectionViewCell.identifier, for: indexPath) as? ProfileMenuCollectionViewCell else{
                return UICollectionViewCell()
            }
        
        cell.generateCell(iconName: profileCellInfo[indexPath.row].0, cellName: profileCellInfo[indexPath.row].1)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileCellInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
