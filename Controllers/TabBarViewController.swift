//
//  TabBarViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-10.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeScreenController = HomeScreenController()
        let searchViewController = SearchViewController()
        let libraryViewController = LibraryViewController()
        let bluetoothPlayerViewController = PlaybackViewController()
        
        homeScreenController.navigationItem.largeTitleDisplayMode = .always
        searchViewController.navigationItem.largeTitleDisplayMode = .always
        libraryViewController.navigationItem.largeTitleDisplayMode = .always
        bluetoothPlayerViewController.navigationItem.largeTitleDisplayMode = .always
        
        
        let homeScreenNavController = UINavigationController(rootViewController: homeScreenController)
        
        let searchViewNavController = UINavigationController(rootViewController: searchViewController)
        
        let libraryViewNavController = UINavigationController(rootViewController: libraryViewController)
        let bluetoothPlayerViewNavCounter = UINavigationController(rootViewController: bluetoothPlayerViewController)
        
        homeScreenNavController.navigationBar.tintColor = .label
        searchViewNavController.navigationBar.tintColor = .label
        libraryViewNavController.navigationBar.tintColor = .label
        bluetoothPlayerViewNavCounter.navigationBar.tintColor = .label
        
        homeScreenNavController.navigationBar.prefersLargeTitles = true
        searchViewNavController.navigationBar.prefersLargeTitles = true
        libraryViewNavController.navigationBar.prefersLargeTitles = true
        bluetoothPlayerViewNavCounter.navigationBar.prefersLargeTitles = true
        
        homeScreenNavController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        searchViewNavController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        libraryViewNavController.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 2)
        bluetoothPlayerViewNavCounter.tabBarItem = UITabBarItem(title: "Player", image: UIImage(systemName: "bluetooth"), tag: 3)
        
        setViewControllers([homeScreenNavController,searchViewNavController,libraryViewNavController,bluetoothPlayerViewNavCounter], animated: false)
        
        
        // Do any additional setup after loading the view.
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
