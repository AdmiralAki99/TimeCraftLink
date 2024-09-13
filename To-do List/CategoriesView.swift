//
//  NewCategoryViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-18.
//

import UIKit
import SwiftUI

class CategoriesView: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        
        let newCategoryButton = UIBarButtonItem(title: "Add Category",image: UIImage(systemName: "plus"), target: self, action: #selector(addNewCategory))
        newCategoryButton.tintColor = .white
        
        navigationItem.rightBarButtonItem = newCategoryButton
        
        let newCategoryView = CategoryListView()
        
        let hostingController = UIHostingController(rootView: newCategoryView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        hostingController.didMove(toParent: self)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func addNewCategory(){
        navigationController?.pushViewController(NewCategoryViewController(), animated: true)
    }

}

struct CategoryListView : View {
    
    @StateObject var todoListManager = ToDoListManager.toDoList_manager
    @State var displayPopUpScreen : Bool = false
    @State var selectedCategory : ToDoListCategory?
    
    var body: some View {
        List{
            ForEach(todoListManager.getCategories(),id:\.id){ category in
                HStack{
                    Label("Icon", systemImage: category.icon).foregroundStyle(Color(hexCode: category.colour) ?? .white).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)).labelStyle(.iconOnly)
                    Text(category.categoryName)
                }.swipeActions(allowsFullSwipe: false) {
                    Button {
                        selectedCategory = category
                        displayPopUpScreen = true
                    } label: {
                        Label("Edit", systemImage: "").labelStyle(.titleOnly)
                    }.tint(.pink)
                }
            }
        }.popover(isPresented: $displayPopUpScreen) {
            CategoryEditView(category: selectedCategory)
        }
    }
}

struct CategoryEditView : View {
    
    @State var category : ToDoListCategory?
    @FocusState var isNameFocused : Bool
    @FocusState var isDescriptionFocused : Bool
    
    @State var categoryName : String
    @State var categoryIcon : String
    @State var categoryColour : Color
    
    init(category : ToDoListCategory?){
        self.category = category
        self.categoryName = category?.categoryName ?? ""
        self.categoryIcon = category?.icon ?? ""
        self.categoryColour = Color(hexCode: category?.colour ?? "") ?? Color.pink
        
    }
    
    var body: some View {
        Form{
            SwiftUI.Section("Information"){
                VStack{
                    HStack{
                        Text("Category Name").frame(maxWidth: .infinity,alignment: .leading)
                        Button{
                            self.isNameFocused = false
                        }label: {
                            Label("Unfocus Name", systemImage: "checkmark").tint(.white).labelStyle(.iconOnly)
                        }
                    }
                    
                    TextField("Category Name",text: $categoryName,axis: .vertical).textFieldStyle(.roundedBorder).focused($isNameFocused)
                }
                VStack{
                    ColorPicker(selection: $categoryColour, supportsOpacity: true) {
                        Text("Category Colour")
                    }
                    
                }
            }
        }
    }
}

extension Color{
    var hexCode : String{
        let colour = UIColor(self)
        guard let components = colour.cgColor.components, components.count >= 3 else {
            return ""
        }

        let rComponent = Float(components[0])
        let gComponent = Float(components[1])
        let bComponent = Float(components[2])
        let alphaComponent = Float(1.0)

        if alphaComponent != 1.0 {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(rComponent * 255), lroundf(gComponent * 255), lroundf(bComponent * 255), lroundf(alphaComponent * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(rComponent * 255), lroundf(gComponent * 255), lroundf(bComponent * 255)) // fixed the format
        }

    }
    
    init?(hexCode:String){
        var code = hexCode.trimmingCharacters(in: .whitespacesAndNewlines)
        code = code.replacingOccurrences(of: "#", with: "")
        
        var colour : UInt64 = 0
        var rComponent = 0.0
        var gComponent = 0.0
        var bComponent = 0.0
        var alphaComponent = 1.0
        
        guard Scanner(string: code).scanHexInt64(&colour) else{
            return nil
        }
        
        if code.count == 6{
            // There is not alpha
            rComponent = CGFloat((colour & 0xFF0000) >> 16) / 255.0
            gComponent = CGFloat((colour & 0x00FF00) >> 8) / 255.0
            bComponent = CGFloat((colour & 0x0000FF)) / 255.0
            
        } else if code.count == 8{
            // There is an alpha
            rComponent = CGFloat((colour & 0xFF0000) >> 24) / 255.0
            gComponent = CGFloat((colour & 0x00FF00) >> 16) / 255.0
            bComponent = CGFloat((colour & 0x0000FF) >> 8) / 255.0
            alphaComponent = CGFloat((colour & 0x0000FF)) / 255.0
        }else{
            return nil
        }
        
        self.init(red: rComponent, green: gComponent, blue: bComponent,opacity: alphaComponent)
    }
}
