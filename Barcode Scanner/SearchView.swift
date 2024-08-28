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
        let vc = UIHostingController(rootView: NutritionSearchResultView(navigationController: self.navigationController!))
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
    
    private let columnVal = [GridItem(.adaptive(minimum: 150))]
    
    private var navigationController : UINavigationController
    
    init(navigationController : UINavigationController){
        self.navigationController = navigationController
    }
    
    var body: some View {
        TabView{
            NavigationStack{
                ScrollView{
                    LazyVGrid(columns: columnVal, spacing: 20){
                        if searchRecipeText == "" {

                        }else{
                            ForEach(self.searchResults,id: \.id){ item in
                                RecipeSearchResultCell(navigationController: navigationController, searchResult: item).frame(width: UIScreen.screenWidth/2)
                            }
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
                        SearchGroceryItemCell(navigationController: navigationController, searchResult: item)
                    }
                }
            }.searchable(text: $searchGroceryText).onSubmit(of: .search, {
                // This is done due to current API restrictions, still works with the onChange function
                NutritionManager.nutritionManager.searchGroceryID(with: searchGroceryText, offset: 0) { res in
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
            
        }
    }
}

struct SearchGroceryItemCell : View {
    private let navigationController : UINavigationController
    private let searchResult : GrocerySearchResult
    @State private var foodItem : GroceryItem?
    
    init(navigationController: UINavigationController, searchResult: GrocerySearchResult) {
        self.navigationController = navigationController
        self.searchResult = searchResult
    }
    
    func getGroceryItem(){
        print("ID: \(self.searchResult.id)")
            DispatchQueue.main.async{
                NutritionManager.nutritionManager.searchGroceryFromID(with: String(self.searchResult.id), completion: { res in
                    switch res{
                    case .success(let item):
                        foodItem = item
                        break
                    case .failure(let error):
                        print("ERROR: \(String(describing: error))")
                    }
                })
        }
    }
    
    var body: some View {
        HStack{
            VStack{
                Text("\(searchResult.title)").truncationMode(.tail)
            }
        }.onTapGesture {
            DispatchQueue.main.async{
                getGroceryItem()
            }
            if let food = self.foodItem{
                navigationController.pushViewController(GrocerySearchItemViewController(foodItem: food), animated: true)
            }
        }
    }
}

struct RecipeSearchResultCell : View {
    private let navigationController : UINavigationController
    private let searchResult : RecipeSearchResult
    @State private var recipeItem : Recipe?
    @State private var nutritionalInfo : RecipeNutritionInfo?
    
    init(navigationController: UINavigationController, searchResult: RecipeSearchResult) {
        self.navigationController = navigationController
        self.searchResult = searchResult
    }
    
    func getRecipe(){
        if recipeItem == nil{
            DispatchQueue.main.async{
                NutritionManager.nutritionManager.searchRecipeFromID(with:self.searchResult.id, completion: { res in
                    switch res{
                    case .success(let item):
                        recipeItem = item
                        break
                    case .failure(let error):
                        print("ERROR: \(String(describing: error))")
                    }
                })
            }
        }
    }
    
    func getNutritionalInfo(){
        if nutritionalInfo == nil{
            if let recipeItem = self.recipeItem{
                DispatchQueue.main.async{
                    NutritionManager.nutritionManager.getRecipeNutritionalInfo(with: String(recipeItem.id)) { res in
                        switch res{
                        case .success(let item):
                            self.nutritionalInfo = item
                        case .failure(let error):
                            print("RECIPE VIEW :\(error)")
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: searchResult.image)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)).frame(width: 50,height: 50)
            VStack{
                Text("\(searchResult.title)").truncationMode(.tail).lineLimit(2)
            }
        }.onTapGesture {
            getRecipe()
            if let recipe = recipeItem{
                navigationController.pushViewController(RecipeViewController(recipe: recipe,nutritionalInfo: recipe.nutritionalInfo!), animated: true)
            }
        }
    }
}

