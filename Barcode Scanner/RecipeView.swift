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
                VStack(alignment: .center){
                    Label("Prep Mins",systemImage: "clock").padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)).labelStyle(.iconOnly)
                    Text("\(String(recipeItem.preparationMinutes ?? 0)) mins").foregroundColor(Color(UIColor.label))
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                Divider().frame(width: 2,height:50).overlay(Color.pink)
                VStack(alignment: .center){
                    Label("Cooking Mins",systemImage: "oven").labelStyle(.iconOnly)
                    Text("\(String(recipeItem.cookingMinutes ?? 0)) mins").foregroundColor(Color(UIColor.label))
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                Divider().frame(width: 2,height:50).overlay(Color.pink)
                VStack(alignment: .center){
                    Label("Calories",systemImage: "flame.fill").labelStyle(.iconOnly)
                    Text("\(String(recipeNutritionalInfo?.calories ?? "")) cal").foregroundColor(Color(UIColor.label)).labelStyle(.iconOnly)
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                Divider().frame(width: 2,height:50).overlay(Color.pink)
                VStack(alignment: .center){
                    Label("Protein",systemImage: "p.circle.fill").labelStyle(.iconOnly)
                    Text("\(String(recipeNutritionalInfo?.protein ?? ""))").foregroundColor(Color(UIColor.label)).labelStyle(.iconOnly)
                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            }.frame(height: 70,alignment:.center).overlay(RoundedRectangle(cornerRadius: 3).stroke(.pink,lineWidth: 1)).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            VStack{
//                Text(String(htmlText: recipeItem.summary ?? "")).multilineTextAlignment(.leading)
                ExpandSummaryView(text: String(htmlText: recipeItem.summary ?? ""))
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            VStack{
                ForEach(recipeItem.extendedIngredients ?? [],id:\.id) { item in
                    RecipeIngredientCell(recipeIngredient: item)
                }
            }.foregroundColor(Color(UIColor.label)).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            VStack{
                ForEach(recipeItem.analyzedInstructions?.first?.steps ?? [],id:\.number) { item in
                    RecipeInstructionCell(recipeStep : item)
                }
            }.foregroundColor(Color(UIColor.label)).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
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
    @State private var isClicked : Bool = false
    
    init(recipeIngredient: RecipeIngredient) {
        self.recipeIngredient = recipeIngredient
    }
    var body: some View {
        HStack{
            VStack{
                Text(String(recipeIngredient.name ?? "").firstCapitalized).frame(maxWidth: .infinity,alignment: .leading)
                Text("\(String(recipeIngredient.measures?.metric?.amount ?? 0.0)) \(String(recipeIngredient.measures?.metric?.unitShort ?? ""))").frame(maxWidth: .infinity,alignment: .leading).font(.caption)
            }
            Circle().stroke(.pink,lineWidth: 1)
                .frame(width: 20,height: 20,alignment: .trailing)
                .foregroundColor(.pink).overlay{
                Image(systemName: isClicked ? "checkmark": "")
            }.onTapGesture {
                withAnimation(.smooth) {
                    isClicked.toggle()
                }
            }
        }
    }
}

struct RecipeInstructionCell : View {
    private var recipeStep : Step
    @State private var isClicked : Bool = false
    
    init(recipeStep: Step) {
        self.recipeStep = recipeStep
    }
    
    var body: some View {
        HStack{
            Circle().stroke(.pink,lineWidth: 1)
                .frame(width: 20,height: 20,alignment: .leading)
                .foregroundColor(.pink).overlay{
                Image(systemName: isClicked ? "checkmark": "")
            }.onTapGesture {
                withAnimation(.smooth) {
                    isClicked.toggle()
                }
            }
            VStack{
                Text(String(recipeStep.step ?? "").firstCapitalized).multilineTextAlignment(.leading).frame(maxWidth: .infinity,alignment: .leading)
    //            ForEach(recipeStep.ingredients, id: \.id) { ingredient in
    //                Text(String(ingredient.localizedName?.firstLetterInEachWordCapitalized ?? "")).font(.caption2)
    //            }
            }.frame(maxWidth: .infinity,alignment: .trailing)
        }
    }
}

struct ExpandSummaryView : View {
    @State private var isEnlarged: Bool = false
    private var descriptionText : String
    
    init(text : String){
        self.descriptionText = text
    }
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    withAnimation {
                        isEnlarged.toggle()
                    }
                } label: {
                    Label("Expand Button",systemImage: "ellipsis").labelStyle(.iconOnly).foregroundColor(.white)
                }.frame(maxWidth: .infinity,alignment: .trailing)
            }.frame(maxWidth: .infinity)
            
            VStack{
                Text(String(self.descriptionText)).multilineTextAlignment(.leading)
            }.frame(height: isEnlarged ? nil : 30,alignment: .top).clipped()
            
        }.frame(maxWidth: .infinity).background(.thickMaterial).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
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
    
    init(htmlText: String){
        let data = Data(htmlText.utf8)
        do{
            if let decodedText = try? NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html],documentAttributes: nil){
                self.init(decodedText.string)
            }else{
                self.init()
            }
        }
    }
}



