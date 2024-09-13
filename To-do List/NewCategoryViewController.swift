//
//  NewCategoryViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2024-09-13.
//

import Foundation
import UIKit
import SwiftUI

class NewCategoryViewController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .dark
        
        let newCategoryView = NewCategoryView()
        
        let hostingController = UIHostingController(rootView: newCategoryView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        hostingController.didMove(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}


struct NewCategoryView : View {
    
    @FocusState var isNameFocused : Bool
    @FocusState var isDescriptionFocused : Bool
    
    @State var categoryName : String = ""
    @State var categoryIcon : String =  ""
    @State var categoryColour : Color = Color.clear
    
    @StateObject var todoListManager = ToDoListManager.toDoList_manager
    
    var body: some View {
        VStack{
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
            HStack{
                Button{
                    todoListManager.createCategory(with: categoryName, colour: categoryColour.hexCode, icon: categoryIcon)
                }label: {
                    Spacer()
                    Label("Add New Task", systemImage: "checkmark.circle").tint(.white).labelStyle(.iconOnly)
                    Spacer()
                }.tint(Color.white).frame(width: 60,height: 60).background(.pink).clipShape(Circle())
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)).frame(maxWidth: .infinity,alignment: .trailing)
        }
    }
}
