//
//  CalorieCounterViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-07-19.
//

import UIKit
import SwiftUI

class CalorieCounterViewController: UIViewController {
    
    let activityStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        stack.backgroundColor = .red
        return stack
    }()
    
    let totalCaloriesStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.backgroundColor = .blue
        return stack
    }()
    
    let totalCaloriesStackHeader: UILabel = {
        let label = UILabel()
        label.text = "Total Calories"
        label.textColor = .white
        return label
    }()
    
    let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        return stack
    }()
    
    let intakeCalorieRing : Ring = {
        let ring = Ring(percentage: 40, startAngle: -90, toDraw: true)
        ring.stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round)).fill(Color.mint).frame(width: 300, height: 300)
        
        return ring
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .darkGray
        initMainStack()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func initMainStack(){
        
        activityStack.widthAnchor.constraint(equalToConstant: view.frame.size.width*0.8).isActive = true
        activityStack.heightAnchor.constraint(equalToConstant: view.frame.size.height/3).isActive = true
        
        totalCaloriesStack.widthAnchor.constraint(equalToConstant: view.frame.size.width*0.8).isActive = true
        totalCaloriesStack.heightAnchor.constraint(equalToConstant: view.frame.size.height/3).isActive = true
        
        totalCaloriesStack.addArrangedSubview(totalCaloriesStackHeader)
        
        mainStack.addArrangedSubview(totalCaloriesStack)
        mainStack.addArrangedSubview(activityStack)
        mainStack.frame = view.bounds
        view.addSubview(mainStack)
    }

}
