//
//  NewTaskViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-16.
//

import Foundation
import UIKit
import SwiftUI
//
//class NewTaskViewController: UIViewController {
//    
//    let taskName : UITextField = {
//        let textField = UITextField()
//        textField.font = .preferredFont(forTextStyle: .largeTitle)
//        textField.placeholder = "Task Name"
//        textField.textColor = .secondaryLabel
//        return textField
//    }()
//    
//    let taskDescription : UITextField = {
//        let textField = UITextField()
//        textField.font = .preferredFont(forTextStyle: .title1)
//        textField.placeholder = "Task Description"
//        return textField
//    }()
//    let dueDate : UIDatePicker = {
//        let picker = UIDatePicker()
//        picker.datePickerMode = .date
//        picker.backgroundColor = .clear
//        picker.tintColor = .systemPurple
//        return picker
//    }()
//    
//    var selectedCategory = ""
//    
//    var selectedDate : Date?
//    
//    private let categoryPicker: UIPickerView = {
//        let pickerView = UIPickerView()
//        pickerView.translatesAutoresizingMaskIntoConstraints = false
//        pickerView.tintColor = .white
//        pickerView.backgroundColor = .clear
//        
//        return pickerView
//     }()
//    
//    let addTaskButton : UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor(red: 0.84, green: 0.24, blue: 0.96, alpha: 1.00)
//        button.layer.cornerRadius = 30
//        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
//        button.tintColor = .white
//        button.layer.masksToBounds = true
//        return button
//    }()
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        navigationItem.largeTitleDisplayMode = .always
//        navigationItem.title = "New Task"
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        
//        view.backgroundColor = UIColor(red: 0.21, green: 0.32, blue: 0.61, alpha: 1.00)
//        
//        let back_button = UIBarButtonItem(title: "Back",image: UIImage(systemName: "arrow.backward"), target: self, action: #selector(backButtonTapped))
//        
//        dueDate.addTarget(self, action: #selector(didSelectDate), for: .valueChanged)
//        addTaskButton.addTarget(self, action: #selector(didCreateTask), for: .touchUpInside)
//        
//        back_button.tintColor = .white
//        
//        navigationItem.leftBarButtonItem = back_button
//        
//        categoryPicker.delegate = self
//        categoryPicker.dataSource = self
//        
//        hideKeyboard()
//
//        // Do any additional setup after loading the view.
//    }
//    
//    @objc func backButtonTapped(){
//        navigationController?.popViewController(animated: true)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        view.addSubview(taskName)
//        view.addSubview(taskDescription)
//        view.addSubview(dueDate)
//        view.addSubview(categoryPicker)
//        view.addSubview(addTaskButton)
//        
//        taskName.frame = CGRect(x: 20, y: view.height/2 - 200, width: view.width - 20, height: 40)
//        taskDescription.frame = CGRect(x: 20, y: taskName.bottom + 40, width: view.width - 20, height: 40)
//        dueDate.frame = CGRect(x: 20, y: taskDescription.bottom + 40, width: 125, height: 60)
//        categoryPicker.frame = CGRect(x: dueDate.right + 20, y: taskDescription.bottom + 40, width: 150, height: 60)
//        addTaskButton.frame = CGRect(x: view.width - 100, y: view.height - 120, width: 60, height: 60)
//    }
//    
//    @objc func didSelectDate(){
//        selectedDate = dueDate.date
//    }
//    
//    @objc func didCreateTask(){
//        guard let finishDate = selectedDate else{
//            return
//        }
//        
//        guard let taskName = taskName.text else{
//            return
//        }
//        
//        guard let taskDescription = taskDescription.text else{
//            return
//        }
//        
//        ToDoListManager.toDoList_manager.createTask(with: Task(name: taskName, category: selectedCategory, description: taskDescription, dueDate: Date()), category: selectedCategory)
//        
//        navigationController?.popViewController(animated: true)
//        
//        ToDoListManager.collectionView.reloadData()
//    }
//    
//    func hideKeyboard(){
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tap)
//    }
//    
//    @objc func dismissKeyboard(){
//        view.endEditing(true)
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//extension NewTaskViewController : UIPickerViewDelegate, UIPickerViewDataSource{
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return ToDoListManager.categories.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return ToDoListManager.categories[row].categoryName
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedCategory = ToDoListManager.categories[row].categoryName
//    }
//    
//}

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
                    let task = Task(name: name, category: categorySelection, summary: description, dueDate: endDate, startDate: startDate)
                    todoListManager.addTaskToCategory(with: task, categoryName: categorySelection)
                    print(todoListManager.getCategories().map({ category in
                        return category.tasks
                    }))
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
