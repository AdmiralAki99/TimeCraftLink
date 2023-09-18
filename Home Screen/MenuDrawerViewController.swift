//
//  MenuDrawerViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-14.
//

import UIKit

class MenuDrawerViewController: UIViewController {
    
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
        
        view.backgroundColor = .purple

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
