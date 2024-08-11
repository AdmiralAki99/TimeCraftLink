//
//  FoodItem.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-09.
//

import Foundation
import SwiftUI
import Charts

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
        
        view.backgroundColor = .red
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

class FoodItemScannedViewController : UIViewController{
    
    
    override func viewDidLoad() {
        view.overrideUserInterfaceStyle = .dark
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}
