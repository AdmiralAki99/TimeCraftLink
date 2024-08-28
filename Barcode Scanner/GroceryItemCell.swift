//
//  GroceryItemCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-15.
//

import Foundation
import SwiftUI

struct GroceryItemCell : View {
    
    let scannedFood : GroceryItem
    
    private let navigationController : UINavigationController
    
    init(scannedFood: GroceryItem, navigationController: UINavigationController) {
        self.scannedFood = scannedFood
        self.navigationController = navigationController
    }
    
    var body: some View {
        HStack{
            VStack{
                Text(String(scannedFood.title ?? "")).truncationMode(.tail)
//                Text("\(scannedFood.brand)").font(.caption)
            }
            Button(){
                navigationController.pushViewController(GroceryItemViewController(foodItem: scannedFood), animated: true)
            }label: {
                Label(
                    title: { Text("") },
                    icon: { Image(systemName: "chevron.right").foregroundColor(Color(UIColor.label)) }
                )
            }.frame(maxWidth: .infinity,alignment: .trailing).controlSize(.small).frame(maxWidth: .infinity,alignment: .trailing)
        }
    }
}
