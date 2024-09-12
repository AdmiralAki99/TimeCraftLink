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
            
            Text("Add A New Task").font(.largeTitle).frame(maxWidth: .infinity,alignment: .leading).bold().padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 0))
            Form{
                SwiftUI.Section(header: TaskSectionHeader(name: "Details",iconName: "arrow.up.left.and.arrow.down.right")){
                    VStack{
                        HStack{
                            Text("Task Name").frame(maxWidth: .infinity,alignment: .leading)
                            Button{
                                self.isNameFocused = false
                            }label: {
                                Label("Unfocus Name", systemImage: "checkmark").tint(.white).labelStyle(.iconOnly)
                            }
                        }
                        
                        TextField("Enter Task Name",text: $name,axis: .vertical).textFieldStyle(.roundedBorder).focused($isNameFocused)
                    }
                    HStack{
                        Text("Start Date").frame(maxWidth: .infinity,alignment: .leading)
                        DatePicker("",selection: $startDate,displayedComponents: [.date,.hourAndMinute]).datePickerStyle(.compact).padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0))
                    }
                    HStack{
                        Text("End Date").frame(maxWidth: .infinity,alignment: .leading)
                        DatePicker("",selection: $endDate,displayedComponents: [.date,.hourAndMinute]).datePickerStyle(.compact).padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0))
                    }
                    VStack{
                        HStack{
                            Text("Description").frame(maxWidth: .infinity,alignment: .leading).padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0)).frame(maxWidth: .infinity,alignment: .leading)
                            Button{
                                self.isDescriptionFocused = false
                            }label: {
                                Label("Unfocus Description", systemImage: "checkmark").tint(.white).labelStyle(.iconOnly)
                            }
                        }
                        
                        TextField("Enter description here",text: $description,axis: .vertical).multilineTextAlignment(.leading).lineLimit(4...).textFieldStyle(.roundedBorder).focused($isDescriptionFocused)
                    }
                    VStack{
                        Picker("Categories", selection: $categorySelection) {
                            ForEach(category,id: \.self){name in
                                Text(name).padding(.horizontal,10)
                            }
                        }.frame(maxWidth: .infinity,alignment: .leading)
                    }
                }
            }
            
            HStack{
                Button{
                    todoListManager.createTask(with: name, category: categorySelection, description: description, dueDate: endDate, startDate: startDate)
                }label: {
                    Spacer()
                    Label("Add New Task", systemImage: "checkmark.circle").tint(.white).labelStyle(.iconOnly)
                    Spacer()
                }.tint(Color.white).frame(width: 60,height: 60).background(.pink).clipShape(Circle())
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10)).frame(maxWidth: .infinity,alignment: .trailing)
            
            
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
