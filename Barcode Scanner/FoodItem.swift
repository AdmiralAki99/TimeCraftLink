//
//  FoodItem.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-09.
//

import Foundation
import SwiftUI

struct FoodItemListCell : View {
    
    private let navigationController : UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    var body: some View {
        HStack{
            VStack{
                Text("Title")
                Text("Subtitle").font(.caption)
            }
            Button(){
                navigationController.pushViewController(FoodItemViewController(), animated: true)
            }label: {
                Label(
                    title: { Text("") },
                    icon: { Image(systemName: "chevron.right").foregroundColor(Color(UIColor.label)) }
                )
            }.frame(maxWidth: .infinity,alignment: .trailing).controlSize(.small).frame(maxWidth: .infinity,alignment: .trailing)
        }
    }
}

class FoodItemViewController : UIViewController{
    
    
    override func viewDidLoad() {
        view.overrideUserInterfaceStyle = .dark
        
        let vc = UIHostingController(rootView: FoodItemView())
        let foodView = vc.view!
        foodView.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        view.addSubview(foodView)
        
        NSLayoutConstraint.activate([foodView.centerXAnchor.constraint(equalTo: view.centerXAnchor),foodView.centerYAnchor.constraint(equalTo: view.centerYAnchor), foodView.widthAnchor.constraint(equalToConstant: view.bounds.width),foodView.heightAnchor.constraint(equalToConstant: view.bounds.height)])
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

struct FoodItemView : View {
    var body: some View {
        VStack{
            
        }
    }
}



