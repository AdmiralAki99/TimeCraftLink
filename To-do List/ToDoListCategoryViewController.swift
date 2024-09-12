//
//  ToDoListCategoryViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-17.
//

import UIKit
import SwiftUI

class EditTaskViewController : UIViewController{
    
    var task : Task?
    
    init(task: Task? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.task = task
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        overrideUserInterfaceStyle = .dark
        
        if let task = self.task{
            let taskView = EditTaskView(item: task)
            
            let hostingController = UIHostingController(rootView: taskView)
            
            addChild(hostingController)
            view.addSubview(hostingController.view)
            
            hostingController.view.frame = view.bounds
            hostingController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            
            hostingController.didMove(toParent: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

struct EditTaskView : View {
    @StateObject var todoListManager = ToDoListManager.toDoList_manager
    
    private var task : Task?
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
    
    init(item: Task) {
        self.task = item
        self.startDate = item.startDate
        self.endDate = item.dueDate
        self.description = item.summary
    }
    
    var body: some View {
        VStack{
            Text(task?.name ?? "").font(.largeTitle).frame(maxWidth: .infinity,alignment: .leading).bold().padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 0))
            Form{
                SwiftUI.Section(header: TaskSectionHeader(name: "Basic Info",iconName: "arrow.up.left.and.arrow.down.right")){
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
                                Label("Add New Task", systemImage: "checkmark").tint(.white).labelStyle(.iconOnly)
                            }
                        }
                        
                        TextField("",text: $description,axis: .vertical).multilineTextAlignment(.leading).lineLimit(4...).textFieldStyle(.roundedBorder).focused($isDescriptionFocused)
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
                    
                }label: {
                    Spacer()
                    Label("Save", systemImage: "plus").tint(.white).labelStyle(.titleOnly)
                    Spacer()
                }.tint(Color.white).frame(width: 60,height: 60).background(.pink).clipShape(Circle()).frame(maxWidth: .infinity,alignment: .leading)
                Spacer()
                Button{
                    
                }label: {
                    Spacer()
                    Label("Add", systemImage: "checkmark.circle").tint(.white).labelStyle(.titleOnly)
                    Spacer()
                }.tint(Color.white).frame(width: 60,height: 60).background(.pink).clipShape(Circle())
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
        }
    }
}

struct TaskSectionHeader : View {
    private var name = ""
    private var iconName = ""
    
    init(name: String = "", iconName: String = "") {
        self.name = name
        self.iconName = iconName
    }
    
    var body: some View {
        HStack{
            Text(name)
            Label("Header", systemImage: iconName).labelStyle(.iconOnly)
        }
    }
}
