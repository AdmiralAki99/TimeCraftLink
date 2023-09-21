//
//  DrawerMenuViewController.swift
//  Drawer Menu App
//
//  Created by Artem Korzh on 26.09.2020.
//

import UIKit
import FirebaseAuth

class DrawerMenuViewController: UIViewController {
    
    let transitionManager = DrawerTransitionManager()
    
    var authHandle : AuthStateDidChangeListenerHandle?
    
    var menuItems : [(String,String)] = [
        ("Profile","person.circle"),
        ("Settings","gearshape.fill"),
        ("Log Out","rectangle.portrait.and.arrow.forward")
    ]
    
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
    
    let welcomeMessage : UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Welcome"
        return label
    }()
    
    let userNameLabel : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.textColor = .label
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    let emailLabel : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email Address"
        textField.textColor = .label
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        return textField
    }()
    
    let passwordLabel : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.textColor = .label
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let signInButton : UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.textColor = .label
        button.autoresizesSubviews = true
        button.backgroundColor = .cyan
        return button
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.textColor = .label
        button.autoresizesSubviews = true
        button.backgroundColor = .cyan
        return button
    }()

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
        
        view.backgroundColor = .black

        initializeMenu()
        

        // Do any additional setup after loading the view.
    }
    
    private var collectionView : UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return DrawerMenuViewController.generateCollectionView(with: sectionIndex)
    })
    
    func initializeProfileBackground(){
        view.addSubview(welcomeMessage)
        view.addSubview(profilePhoto)
        view.addSubview(profileNameLabel)
        view.addSubview(profileSubtitle)
        view.addSubview(divider)
        view.addSubview(collectionView)
        
        welcomeMessage.frame = CGRect(x: 10, y: 60, width: view.width, height: 30)
        
        profilePhoto.frame = CGRect(x: 10, y: welcomeMessage.bottom + 30, width: 60, height: 60)
        profilePhoto.backgroundColor = .white
        profilePhoto.layer.cornerRadius = 30
        profilePhoto.layer.masksToBounds = true
        
        profileNameLabel.text = TimeCraftUser.user.userName
        
        profileNameLabel.frame = CGRect(x: profilePhoto.right + 20, y: welcomeMessage.bottom + 30, width: view.width - (profilePhoto.right + 20), height: 30)
        
        profileSubtitle.text = TimeCraftUser.user.email
        
        profileSubtitle.frame = CGRect(x: profilePhoto.right + 20, y: profileNameLabel.bottom, width: view.width - (profilePhoto.right + 20), height: 20)
        
        divider.frame = CGRect(x: 0, y: profileSubtitle.bottom + 30, width: view.width * 0.72, height: 1.0)
        
        divider.layer.borderWidth = 1.0
        divider.layer.borderColor = UIColor.white.cgColor
        
        collectionView.frame = CGRect(x: 10, y: divider.bottom + 20, width: (view.width * 0.7) - 10, height: view.height - (divider.bottom + 20))
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(DrawerMenuCollectionViewCell.self, forCellWithReuseIdentifier: DrawerMenuCollectionViewCell.identifier)
    }
    
    func initializeMenu(){
        if TimeCraftUser.user.userRef == nil{
            createLoginMenu()
        }else{
            initializeProfileBackground()
        }
    }
    
    func createLoginMenu(){
        view.addSubview(welcomeMessage)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(userNameLabel)
        view.addSubview(emailLabel)
        view.addSubview(passwordLabel)
        
        welcomeMessage.frame = CGRect(x: 10, y: 60, width: view.width, height: 30)
        
        userNameLabel.frame = CGRect(x: 10, y: welcomeMessage.bottom + 60, width: 150, height: 30)
        
        emailLabel.frame = CGRect(x: 10, y: userNameLabel.bottom + 30, width: 150, height: 30)
        
        passwordLabel.frame = CGRect(x: 10, y: emailLabel.bottom, width: 150, height: 30)
        
        signInButton.frame = CGRect(x: 10, y: passwordLabel.bottom + 30, width: 150, height: 30)
        
        signUpButton.frame = CGRect(x: 10, y: signInButton.bottom, width: 150, height: 30)
        
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
    }
    
    @objc func signUpButtonPressed(){
        let userName = userNameLabel.text
        let email = emailLabel.text
        let password = passwordLabel.text
        
        if userName != nil && email != nil && password != nil{
            FirebaseManager.firebase_manager.createFirebaseUser(with: email!, passoword: password!) { result in
                switch result{
                case .success(let user):
                    TimeCraftUser.user = TimeCraftUser(user: user, userName: userName!)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.welcomeMessage.text = "Welcome \(TimeCraftUser.user.userName)"
                self.removeSignUpSheet()
                self.initializeMenu()
            }
        }else{
            
        }
    }
    
    func removeSignUpSheet(){
        welcomeMessage.removeFromSuperview()
        signInButton.removeFromSuperview()
        signUpButton.removeFromSuperview()
        userNameLabel.removeFromSuperview()
        emailLabel.removeFromSuperview()
        passwordLabel.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authHandle = Auth.auth().addStateDidChangeListener { auth, user in
          // ...
        }
    }
    
    static func generateCollectionView(with sectionIndex: Int)-> NSCollectionLayoutSection{
        
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(35)), subitem: item, count: 1)
        
            let section = NSCollectionLayoutSection(group: group)

            return section
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(authHandle!)
    }

}

extension DrawerMenuViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrawerMenuCollectionViewCell.identifier, for: indexPath) as? DrawerMenuCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.generateViewCell(menuName: menuItems[indexPath.row].0, icon: menuItems[indexPath.row].1)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    
    
}
