//
//  SearchView.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-16.
//

import Foundation
import SwiftUI

class NutritionSearchViewController : UIViewController{

    override func viewDidLoad() {
        let vc = UIHostingController(rootView: NutritionSearchResultView())
        let searchView = vc.view!
        searchView.translatesAutoresizingMaskIntoConstraints = false

        addChild(vc)
        view.addSubview(searchView)
        
        NSLayoutConstraint.activate([searchView.centerXAnchor.constraint(equalTo: view.centerXAnchor),searchView.centerYAnchor.constraint(equalTo: view.centerYAnchor), searchView.widthAnchor.constraint(equalToConstant: view.bounds.width),searchView.heightAnchor.constraint(equalToConstant: view.bounds.height)])
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

struct NutritionSearchResultView : View {
    @State private var searchRecipeText = ""
    @State private var searchGroceryText = ""
    @State private var searchIngredientText = ""
    @State private var tabIndexSelected : Int = 0
    
    @State private var searchResults : [RecipeSearchResult] = []
    @State private var searchGroceryResults : [GrocerySearchResult] = []
    @State private var searchIngredientResults : [IngredientSearchResult] = []
    
    var body: some View {
        TabView{
            NavigationStack{
                List{
                    if searchRecipeText == "" {
                        Text("No Search")
                    }else{
                        ForEach(self.searchResults,id: \.id){ item in
                            Text("\(item.title)")
                        }
                    }
                }
            }.searchable(text: $searchRecipeText).onSubmit(of: .search, {
                // This is done due to current API restrictions, still works with the onChange function
                NutritionManager.nutritionManager.searchRecipeID(with: searchRecipeText, offset: 0) { res in
                    switch res{
                        case .success(let search):
                            self.searchResults = search.results
                            break
                        case .failure(let error):
                            fatalError()
                            break
                    }
                }
            })
//                .onChange(of: searchText, perform: { newValue in
//                NutritionManager.nutritionManager.searchRecipeID(with: searchText, offset: 0) { res in
//                    switch res{
//                    case .success(let search):
//                        self.searchResults = search.results
//                        break
//                    case .failure(let error):
//                        fatalError()
//                        break
//                    }
//                }
//            })
            .tabItem {
                Text("Recipe")
                Image(systemName: "fork.knife").renderingMode(.template).foregroundColor(Color.pink)
            }.tag(0)
            
            NavigationStack{
                List{
                    ForEach(self.searchGroceryResults,id: \.id){ item in
                        Text("\(item.name)")
                    }
                }
            }.searchable(text: $searchGroceryText).onSubmit(of: .search, {
                // This is done due to current API restrictions, still works with the onChange function
                NutritionManager.nutritionManager.searchGroceryID(with: searchRecipeText, offset: 0) { res in
                    switch res{
                        case .success(let search):
                            self.searchGroceryResults = search.products
                            break
                        case .failure(let error):
                            fatalError()
                            break
                    }
                }
            })
            .tabItem {
                Text("Grocery")
                Image(systemName: "cart.fill").renderingMode(.template).foregroundColor(Color.pink)
            }.tag(1)
            
            NavigationStack{
                List{
                    ForEach(self.searchIngredientResults,id: \.id){ item in
                        Text("\(item.name)")
                    }
                }
            }.searchable(text: $searchIngredientText).onSubmit(of: .search, {
                // This is done due to current API restrictions, still works with the onChange function
                NutritionManager.nutritionManager.searchPureIngredientID(with: searchRecipeText, offset: 0) { res in
                    switch res{
                        case .success(let search):
                        self.searchIngredientResults = search.results
                            break
                        case .failure(let error):
                            fatalError()
                            break
                    }
                }
            })
            .tabItem {
                Text("Ingredient Search")
                Image(systemName: "carrot.fill").renderingMode(.template).foregroundColor(Color.pink)
            }.tag(2)

            
        }
    }
}
