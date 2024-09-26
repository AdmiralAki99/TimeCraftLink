//
//  ToDoListViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-14.
//

import UIKit
import SwiftUI
import Charts

class ToDoListViewController: UIViewController{
    
    override func viewDidLoad() {
        
        view.overrideUserInterfaceStyle = .dark
        
        let newCategoryButton = UIBarButtonItem(title: "Calendar View",image: UIImage(systemName: "calendar"), target: self, action: #selector(showCalendarView))
        newCategoryButton.tintColor = .white
        
        navigationItem.rightBarButtonItem = newCategoryButton
        
        let todoListView = ToDoListView(navigationController: self.navigationController)
        
        let hostingController = UIHostingController(rootView: todoListView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        hostingController.didMove(toParent: self)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    @objc func showCalendarView(){
        
    }
}

struct ToDoListView: View {
    
    @StateObject private var todoListManager = ToDoListManager.toDoList_manager
    @StateObject var manager = DataManager.data_manager
    private var navigationController : UINavigationController?
    
    init(navigationController : UINavigationController? = nil){
        self.navigationController = navigationController
    }
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                ScrollView(showsIndicators: false){
                    VStack{
                        VStack(alignment: .center){
                            StackedRingView(colors: [Color.orange,Color.mint,Color.green], categoryPercentages: todoListManager.getCategoryCompletedInfo(), categoryLabels: todoListManager.getCategoryLabels()).fixedSize()
                        }.background(.gray.opacity(0.1)).cornerRadius(15).frame(width: 200,height: 200).padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack(alignment: .center){
                                ForEach(self.todoListManager.getCategories(),id: \.id){ category in
                                    TodoListCategoryCell(category: category, navigationController: navigationController).padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                }.frame(width: 150, height: 200).background(.gray.opacity(0.1)).cornerRadius(10)
                                VStack(alignment: .center){
                                    Label("Icon", systemImage: "ellipsis").foregroundStyle(.gray).labelStyle(.iconOnly).padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                                    Text("Edit Categories").bold().lineLimit(2).truncationMode(.tail).multilineTextAlignment(.center).font(.subheadline).foregroundStyle(.gray)
                                }.frame(width: 150, height: 200).background(.gray.opacity(0.1)).cornerRadius(10).onTapGesture {
                                    navigationController?.pushViewController(CategoriesView(), animated: true)
                                }
                            }
                        }.padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                        Text("Today's Tasks").font(.title2).frame(maxWidth: .infinity,alignment: .leading).bold().padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 0))
                        ForEach(self.todoListManager.getTodaysTasks(),id: \.id){ task in
                            TodoListTaskCell(task: task,navigationController: self.navigationController).frame(height: 50).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                        }.background(.gray.opacity(0.1)).cornerRadius(10).padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                    }.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                }
            }
            HStack{
                Button {
                    self.navigationController?.pushViewController(NewTaskViewController(), animated: true)
                } label: {
                    Spacer()
                    Label("Add New Task", systemImage: "plus").tint(.white).labelStyle(.iconOnly)
                    Spacer()
                }.frame(width: 80,height: 80).background(.pink.opacity(0.75)).clipShape(Circle())
            }.frame(maxWidth: .infinity,alignment: .trailing).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
        }.onAppear{
//            print(todoListManager.getCategoryLabels())
//            print(todoListManager.getCategoryCompletedInfo())
        }
        
    }
}

struct TodoListCategoryCell : View {
    
    @State var category : ToDoListCategory
    @StateObject private var todoListManager = ToDoListManager.toDoList_manager
    var navigationController : UINavigationController?
    
    init(category: ToDoListCategory,navigationController: UINavigationController?) {
        self.category = category
        self.navigationController = navigationController
    }
    
    private let dateDictionary = [
        1 : "Sun",
        2 : "Mon",
        3 : "Tue",
        4 : "Wed",
        5 : "Thu",
        6 : "Fri",
        7 : "Sat"
    ]
    
    private let weekdayColors = [Color.pink,Color.cyan,Color.green,Color.orange,Color.yellow,Color.mint,Color.teal]
    
    @State private var isToday : Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            Label("Icon", systemImage: category.icon).foregroundStyle(Color(hexCode: category.colour) ?? .white).labelStyle(.iconOnly)
            Text(self.category.categoryName).font(.caption).foregroundStyle(.gray).padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            Text("\(todoListManager.peekCategory(categoryName: category.categoryName)?.name ?? "")").frame(maxWidth: .infinity,alignment: .leading).bold().lineLimit(2).truncationMode(.tail)
            if ((todoListManager.peekCategory(categoryName: category.categoryName)?.dueDate.isThisWeek()) ?? false){
                if(todoListManager.peekCategory(categoryName: category.categoryName)?.dueDate.isToday() ?? false){
                    HStack{
                        Text("Today").foregroundStyle(.red).font(.caption).bold().padding(.horizontal,10).padding(.vertical,2)
                    }.background(
                        RoundedRectangle(cornerRadius: 10).fill(.red.opacity(0.3))
                    ).padding(.vertical,10)
                }else{
                    HStack{
                        Text(self.dateDictionary[todoListManager.peekCategory(categoryName: category.categoryName)?.dueDate.getWeekday() ?? 0] ?? "").foregroundStyle(self.weekdayColors[(todoListManager.peekCategory(categoryName: category.categoryName)?.dueDate.getWeekday() ?? 1) - 1 ?? 0]).font(.caption).bold().padding(.horizontal,10).padding(.vertical,2)
                    }.background(
                        RoundedRectangle(cornerRadius: 10).fill(self.weekdayColors[todoListManager.peekCategory(categoryName: category.categoryName)?.dueDate.getWeekday() ?? 0].opacity(0.3))
                    ).padding(.vertical,10)
                }
                
            }
            
        }.onAppear(){
        
        }.onTapGesture {
            navigationController?.pushViewController(CategoryViewController(category: self.category), animated: true)
        }
    }
}

struct TodoListTaskCell: View {
    
    @State var task : Task
    @State var navigationController : UINavigationController?
    
    @State var isChecked: Bool
    
    init(task: Task,navigationController : UINavigationController?) {
        self.task = task
        self.navigationController = navigationController
        self.isChecked = task.ongoing
    }
    
    var body: some View {
        HStack{
            Circle().stroke( isChecked ? Color.gray : Color.pink, lineWidth: 2).fill(isChecked ? Color.clear: Color.pink ).frame(width: 20,height: 20).onTapGesture {
                withAnimation(.smooth) {
                    isChecked.toggle()
                    if !isChecked{
                        ToDoListManager.toDoList_manager.completeTask(with: task, categoryName: task.category)
                    }else{
                        ToDoListManager.toDoList_manager.uncompleteTask(with: task, categoryName: task.category)
                    }
                }
            }
            
            Text(task.name).foregroundStyle(isChecked ? Color.white : Color.gray).strikethrough(!isChecked,color: Color.gray).frame(maxWidth: .infinity,alignment: .leading).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
        }
        
    }
}

extension Date{
    func isThisWeek() -> Bool{
        
        guard let startOfWeek = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.start else{
            return false
        }
        guard let endOfWeek = Calendar.current.dateInterval(of: .weekOfYear, for: Date())?.end else{
            return false
        }
        
        return self >= startOfWeek && self < endOfWeek
    }
    
    func isToday() -> Bool{
        return Calendar.current.isDateInToday(self)
    }
    
    func isThisMonth()->Bool{
        guard let startOfMonth = Calendar.current.dateInterval(of: .month, for: self)?.start else{
            return false
        }
        guard let endOfMonth = Calendar.current.dateInterval(of: .month, for: self)?.end else{
            return false
        }
        
        return self >= startOfMonth && self < endOfMonth
    }
    
    func getWeekday() -> Int{
        let weekday = Calendar.current.component(.weekday, from: self)
        
        return weekday
    }
}
