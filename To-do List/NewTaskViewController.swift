//
//  NewTaskViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-16.
//

import Foundation
import UIKit
import SwiftUI

class NewTaskViewController: UIViewController {
    
    override func viewDidLoad() {
        
        overrideUserInterfaceStyle = .dark
        
        let newTaskView = NewTaskView(navigationController: self.navigationController)
        
        let hostingController = UIHostingController(rootView: newTaskView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        hostingController.didMove(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
}

struct NewTaskView: View {
    
    @StateObject var todoListManager = ToDoListManager.toDoList_manager
    
    @State var name : String = ""
    @State var startDate : Date = Date.now
    @State var endDate : Date = Date.now
    @State var description : String = ""
    
    @FocusState var isNameFocused : Bool
    @FocusState var isDescriptionFocused : Bool

    private let category : [String] = {
        let categoryNames = ToDoListManager.toDoList_manager.getCategories().map { category in
            return category.categoryName
        }
        return categoryNames
    }()
    
    @State private var categorySelection : String = {
        return ToDoListManager.toDoList_manager.getCategories().first?.categoryName ?? ""
    }()
    
    private var navigationController : UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    var body: some View {
        VStack{
            Text("Add New Task").font(.largeTitle).frame(maxWidth: .infinity,alignment: .leading).bold()
            VStack{
                HStack{
                    Text("Name").font(.caption).bold().frame(maxWidth: .infinity,alignment: .leading).padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0)).frame(maxWidth: .infinity,alignment:.leading)
                    Button{
                        self.isNameFocused = false
                    }label: {
                        Label("Add New Task", systemImage: "checkmark").tint(.white).labelStyle(.iconOnly)
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                }
                
                TextField("Enter the task name",text: $name,axis: .vertical).lineLimit(2...).padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0)).textFieldStyle(.roundedBorder).focused($isNameFocused)
            }.overlay{
                RoundedRectangle(cornerRadius: 15).stroke(.white,lineWidth: 1)
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            VStack{
                Text("Date").font(.caption).bold().frame(maxWidth: .infinity,alignment: .leading).padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                DatePicker("Enter the start date",selection: $startDate,displayedComponents: [.date,.hourAndMinute]).datePickerStyle(.compact).padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0))
                
                DatePicker("Enter the start date",selection: $endDate,displayedComponents: [.date,.hourAndMinute]).datePickerStyle(.compact).padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0))
            }.overlay{
                RoundedRectangle(cornerRadius: 15).stroke(.white,lineWidth: 1)
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            
            HStack{
                Text("Description").font(.caption).bold().frame(maxWidth: .infinity,alignment: .leading).padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0)).frame(maxWidth: .infinity,alignment: .leading)
                Button{
                    self.isDescriptionFocused = false
                }label: {
                    Label("Add New Task", systemImage: "checkmark").tint(.white).labelStyle(.iconOnly)
                }
            }
            
            TextField("Enter the task description",text: $description,axis: .vertical).padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0)).multilineTextAlignment(.leading).lineLimit(4...).textFieldStyle(.roundedBorder).padding().focused($isDescriptionFocused)
            
            HStack{
                Picker("Meal Selection",selection: $categorySelection){
                    ForEach(category,id:\.self){
                        Text($0).foregroundColor(Color(UIColor.label))
                    }
                }.background(Color.pink).clipShape(Capsule()).accentColor(Color(UIColor.label)).pickerStyle(.menu).frame(maxWidth: .infinity,alignment: .leading)
                Spacer()
                Button{
                    todoListManager.createTask(with: "Test", category: "Important", description: "Test", dueDate: Date(), startDate: Date())
                }label: {
                    Spacer()
                    Label("Add New Task", systemImage: "plus").tint(.white).labelStyle(.iconOnly)
                    Spacer()
                }.tint(Color.white).frame(width: 60,height: 60).background(.pink).clipShape(Circle())
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
            
            
        }
    }
}

extension Date{
    func toString() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}
