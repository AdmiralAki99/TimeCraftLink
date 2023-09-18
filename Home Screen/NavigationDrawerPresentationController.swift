//
//  NavigationDrawerPresentationController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-18.
//

import UIKit

class NavigationDrawerPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect{
        var frame : CGRect = .zero
        guard let containerView = containerView else{
            return frame
        }
        
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView.bounds.size)
        
        return frame
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width * 0.8, height: parentSize.height)
    }
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    

}
