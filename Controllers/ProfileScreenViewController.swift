//
//  ProfileScreenViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import UIKit

class ProfileScreenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var models = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Profile"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        getUserProfile()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func getUserProfile(){
        SpotifyAPIManager.api_manager.getUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let user):
                    self?.fetchUserProfile(with:user)
                case .failure(let err):
                    self?.failedToGetUserProfile()
                }
            }
            
        }
    }
    
    private func fetchUserProfile(with user: User){
        tableView.isHidden = false
        models.append("Full Name: \(user.display_name)")
        models.append("Email: \(user.email)")
        models.append("User ID: \(user.id)")
        models.append("Plan: \(user.product)")
        tableView.reloadData()
    }
    
    private func failedToGetUserProfile(){
        let label = UILabel(frame: .zero )
        label.text = "Failed to get Profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = models[indexPath.row]
        return cell
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
