//
//  SettingsViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let settingsView : UITableView = {
        let settingsView = UITableView(frame: .zero,style: .grouped)
        settingsView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return settingsView
    }()
    
    var settingsSection = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        
        view.addSubview(settingsView)
        
        settingsView.dataSource = self
        settingsView.delegate = self
        
        configureSettingsMenu()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsSection[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = settingsSection[indexPath.section].options[indexPath.row]
        let cell = settingsView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        settingsView.deselectRow(at: indexPath, animated: true)
        let model = settingsSection[indexPath.section].options[indexPath.row]
        model.handler()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = settingsSection[section]
        return model.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsSection.count
    }
    
    private func configureSettingsMenu(){
        
        settingsSection.append(Section(title: "Profile", options: [Option(title: "View Profile", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.viewProfile()
            }
        })]))
        
        settingsSection.append(Section(title: "Sign Out", options: [Option(title: "Sign Out", handler: { [weak self] in
            DispatchQueue.main.async {
                self?.signOutTapped()
            }
        })]))
    }
    
    private func viewProfile(){
        let profileViewController = ProfileScreenViewController()
        profileViewController.title = "Profile"
        profileViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    private func signOutTapped(){
        let profileViewController = ProfileScreenViewController()
        profileViewController.title = "Profile"
        profileViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(profileViewController, animated: true)
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
