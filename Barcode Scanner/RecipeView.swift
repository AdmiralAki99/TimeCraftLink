//
//  RecipeView.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-08-20.
//

import Foundation
import SwiftUI
import WebKit

class RecipeViewController : UIViewController{
    
    private var recipe: Recipe = {
        return Recipe(id: 0, vegetarian: nil, vegan: nil, glutenFree: nil, dairyFree: nil, preparationMinutes: nil, cookingMinutes: nil, extendedIngredients: nil, nutrition: nil, analyzedInstructions: nil,title: nil, readyInMinutes: nil,servings:nil,summary: nil,sourceUrl: nil, sourceName: nil, image: nil)
    }()
    
    init(recipe: Recipe){
        super.init(nibName: nil, bundle: nil)
        self.recipe = recipe
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.overrideUserInterfaceStyle = .dark
        
        let vc = UIHostingController(rootView: RecipeView(recipeItem: recipe))
        let recipeView = vc.view!
        recipeView.translatesAutoresizingMaskIntoConstraints = false
        addChild(vc)
        view.addSubview(recipeView)
        
        NSLayoutConstraint.activate([recipeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),recipeView.centerYAnchor.constraint(equalTo: view.centerYAnchor), recipeView.widthAnchor.constraint(equalToConstant: view.bounds.width),recipeView.heightAnchor.constraint(equalToConstant: view.bounds.height)])
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

struct RecipeView : View {
    
    private var recipeItem : Recipe
    @State private var recipeNutritionalInfo : RecipeNutritionInfo?
    @State private var recipeReveal : Bool = true
    @State private var mealSelection = "Breakfast"
    private let meals =  ["Breakfast","Lunch","Dinner","Snack"]
    
    init(recipeItem: Recipe) {
        self.recipeItem = recipeItem
    }
    
    func getNutritionalInfo(){
        DispatchQueue.main.async{
            NutritionManager.nutritionManager.getRecipeNutritionalInfo(with: String(recipeItem.id)) { res in
                switch res{
                case .success(let item):
                    self.recipeNutritionalInfo = item
                case .failure(let error):
                    print("RECIPE VIEW :\(error)")
                }
            }
        }
    }
    
    var body: some View {
        
        ScrollView{
            AsyncImage(url: URL(string: recipeItem.image ?? "")) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }.frame(width: UIScreen.screenWidth,height: 300)

            VStack{
                Text(String(recipeItem.title ?? "")).font(.title).bold()
                Text("By: \(String(recipeItem.sourceName ?? ""))")
            }
            HStack{
                Label("\(String(recipeItem.cookingMinutes ?? 0)) mins",systemImage: "clock")
                Spacer()
                Label("\(String(recipeItem.preparationMinutes ?? 0)) mins",systemImage: "clock")
                Spacer()
                Label("\(String(recipeNutritionalInfo?.calories ?? "0")) cal",systemImage: "clock")
            }.frame(maxWidth: .infinity,alignment: .leading)
            VStack{
                Text(String(recipeItem.summary ?? ""))
            }
            DisclosureGroup("Ingredients"){
                ForEach(recipeItem.extendedIngredients ?? [],id:\.id) { item in
                    RecipeIngredientCell(recipeIngredient: item)
                }
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)).background(Color(UIColor.lightGray).opacity(0.4)).cornerRadius(10.0).foregroundColor(Color(UIColor.label))
            DisclosureGroup("Steps"){
                ForEach(recipeItem.analyzedInstructions?.first?.steps ?? [],id:\.number) { item in
                    RecipeInstructionCell(recipeStep : item)
                }
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)).background(Color(UIColor.lightGray).opacity(0.4)).cornerRadius(10.0).foregroundColor(Color(UIColor.label))
            HStack(alignment:.center){
                Picker("Meal Selection",selection: $mealSelection){
                    ForEach(meals,id:\.self){
                        Text($0).foregroundColor(Color(UIColor.label))
                    }
                }.background(Color.pink).clipShape(Capsule()).accentColor(Color(UIColor.label)).pickerStyle(.menu)
                Spacer()
                Button("+ Add"){
                    switch mealSelection{
                    case "Breakfast":
                        NutritionManager.nutritionManager.addMealToList(mealType: .Breakfast, meal: recipeItem)
                        break
                    case "Lunch":
                        NutritionManager.nutritionManager.addMealToList(mealType: .Lunch, meal: recipeItem)
                        break
                    case "Dinner":
                        NutritionManager.nutritionManager.addMealToList(mealType: .Dinner, meal: recipeItem)
                        break
                    case "Snack":
                        NutritionManager.nutritionManager.addMealToList(mealType: .Snack, meal: recipeItem)
                        break
                    default:
                        fatalError("Wrong Meal Selection")
                        break
                    }
 
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10)).tint(Color.pink)
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
        }.onAppear(){
            getNutritionalInfo()
        }
    }
}

struct RecipeIngredientCell : View {
    private var recipeIngredient : RecipeIngredient
    
    init(recipeIngredient: RecipeIngredient) {
        self.recipeIngredient = recipeIngredient
    }
    var body: some View {
        HStack{
            Text(String(recipeIngredient.name ?? "").firstCapitalized).frame(maxWidth: .infinity,alignment: .leading)
            Text("\(String(recipeIngredient.measures?.metric?.amount ?? 0.0)) \(String(recipeIngredient.measures?.metric?.unitShort ?? ""))").frame(maxWidth: .infinity,alignment: .trailing)
        }
    }
}

struct RecipeInstructionCell : View {
    private var recipeStep : Step
    
    init(recipeStep: Step) {
        self.recipeStep = recipeStep
    }
    
    var body: some View {
        VStack{
            Text(String(recipeStep.step ?? "").bulletedString).multilineTextAlignment(.leading)
//            ForEach(recipeStep.ingredients, id: \.id) { ingredient in
//                Text(String(ingredient.localizedName?.firstLetterInEachWordCapitalized ?? "")).font(.caption2)
//            }
        }.cornerRadius(10.0)
    }
}

extension String{
    var firstCapitalized : String{
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        
        return firstLetter + remainingLetters
    }
    
    var firstLetterInEachWordCapitalized : String{
        let words = self.components(separatedBy: " ").map { string in
            return string.firstCapitalized
        }
        return words.joined(separator: " ")
    }
    
    var bulletedString : String{
        let bullet = "\u{2022} "
        
        return bullet + self
    }
}



