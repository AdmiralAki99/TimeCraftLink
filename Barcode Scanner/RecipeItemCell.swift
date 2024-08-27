//
//  RecipeItemCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-26.
//

import Foundation
import SwiftUI

struct RecipeItemCell : View {
    @State private var recipeItem: Recipe
    @State private var navigationController : UINavigationController
    
    init(recipeItem: Recipe, navigationController: UINavigationController) {
        self.recipeItem = recipeItem
        self.navigationController = navigationController
    }
    
    var body: some View {
        HStack{
            VStack{
                Text(recipeItem.title ?? "").truncationMode(.tail)
//                Text(recipeItem.sourceName ?? "").font(.subheadline)
            }
            Button(){
                if let nutrInfo = recipeItem.nutritionalInfo{
                    navigationController.pushViewController(RecipeItemViewController(recipe: recipeItem, nutritionalInfo: nutrInfo), animated: true)
                }
                
            }label: {
                Label(
                    title: { Text("") },
                    icon: { Image(systemName: "chevron.right").foregroundColor(Color(UIColor.label)) }
                )
            }.frame(maxWidth: .infinity,alignment: .trailing).controlSize(.small).frame(maxWidth: .infinity,alignment: .trailing)
        }
    }
}
