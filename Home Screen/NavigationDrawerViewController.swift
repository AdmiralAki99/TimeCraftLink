//
//  NavigationDrawerViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-18.
//

import UIKit

class NavigationDrawerViewController: UIViewController {
    
    let transition = NavigationDrawerTransition()
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        transitioningDelegate = transition
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
