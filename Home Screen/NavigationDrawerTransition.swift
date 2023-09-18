//
//  NavigationDrawerTransition.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-18.
//

import Foundation
import UIKit

class NavigationDrawerTransition : NSObject, UIViewControllerTransitioningDelegate{
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return NavigationDrawerPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
