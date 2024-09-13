//
//  CategoryViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-16.
//

import UIKit
import SwiftUI
import Charts

class CategoryViewController : UIViewController{
    
    private var category: ToDoListCategory?
    
    init(category: ToDoListCategory) {
        super.init(nibName: nil, bundle: nil)
        self.category = category
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        
        overrideUserInterfaceStyle = .dark
        
        if let category = self.category{
            let categoryView = CategoryView(category: category.categoryName,navigationController: self.navigationController)
            
            let hostingController = UIHostingController(rootView: categoryView)
            
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

struct CategoryView : View {
    
    @State var category : String
    @StateObject var todoListManager = ToDoListManager.toDoList_manager
    private var navigationController : UINavigationController?
    @State var selectedTab : Int = 0
    
    private var overviewBarIndices = [0,1,2]

    
    init(category: String, navigationController: UINavigationController? = nil) {
        self.category = category
        self.navigationController = navigationController
    }
    
    var body: some View {
        ScrollView{
            VStack{
                Text(category).font(.title).frame(maxWidth: .infinity,alignment: .leading).bold().padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 0))
            }
            VStack{
                Picker(selection:$selectedTab,label:Text("")){
                    Text("Overview").tag(0)
                    Text("Weekly").tag(1)
                }.pickerStyle(SegmentedPickerStyle()).padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                TabView(selection: $selectedTab) {
                    Chart{
                        ForEach(overviewBarIndices,id: \.self){ index in
                            if index == 0{
                                BarMark(x: .value("Due Timeframe", "Today"), y: .value("Freq", todoListManager.getCategoryStatistics(categoryName: category)[index]),width: 100).foregroundStyle(.pink).clipShape(RoundedRectangle(cornerRadius: 10))
                            }else if index == 1{
                                BarMark(x: .value("Due Timeframe", "Week"), y: .value("Freq", todoListManager.getCategoryStatistics(categoryName: category)[index]),width: 100).foregroundStyle(.pink).clipShape(RoundedRectangle(cornerRadius: 10))
                            } else{
                                BarMark(x: .value("Due Timeframe", "Month"), y: .value("Freq", todoListManager.getCategoryStatistics(categoryName: category)[index]),width: 100).foregroundStyle(.pink).clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }.frame(height: 200).padding(.horizontal,10).padding(.vertical,10).foregroundStyle(.white).chartXAxis{
                        AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                    }.chartYAxis{
                        AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                    }.tag(0)
                    
                    Chart{
                        BarMark(x: .value("Weekday", "Mon"), y: .value("Freq", 10)).foregroundStyle(.pink).clipShape(RoundedRectangle(cornerRadius: 10))
                        BarMark(x: .value("Weekday", "Tue"), y: .value("Freq", 30)).foregroundStyle(.pink).clipShape(RoundedRectangle(cornerRadius: 10))
                        BarMark(x: .value("Weekday", "Wed"), y: .value("Freq", 20)).foregroundStyle(.pink).clipShape(RoundedRectangle(cornerRadius: 10))
                        BarMark(x: .value("Weekday", "Thu"), y: .value("Freq", 15)).foregroundStyle(.pink).clipShape(RoundedRectangle(cornerRadius: 10))
                        BarMark(x: .value("Weekday", "Fri"), y: .value("Freq", 25)).foregroundStyle(.pink).clipShape(RoundedRectangle(cornerRadius: 10))
                        BarMark(x: .value("Weekday", "Sat"), y: .value("Freq", 8)).foregroundStyle(.pink).clipShape(RoundedRectangle(cornerRadius: 10))
                        BarMark(x: .value("Weekday", "Sun"), y: .value("Freq", 40)).foregroundStyle(.pink).clipShape(RoundedRectangle(cornerRadius: 10))
                    }.frame(height: 250).padding(.horizontal,10).padding(.vertical,10).foregroundStyle(.white).chartXAxis{
                        AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                    }.chartYAxis{
                        AxisMarks(stroke: StrokeStyle(lineWidth: 0))
                    }.tag(1)
                }.tabViewStyle(PageTabViewStyle()).background(.gray.opacity(0.1)).cornerRadius(15).frame(height:325).padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                
            }
            
            Text("Tasks").font(.title).frame(maxWidth: .infinity,alignment: .leading).bold().padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 0))
            
            ForEach(todoListManager.getCategoryTasks(categoryName: category),id:\.id){ task in
                CategoryTaskCell(task: task, navigationController: navigationController).padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            }.background(.gray.opacity(0.1)).cornerRadius(10).padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            
        }.onAppear{
            print(todoListManager.getCategoryStatistics(categoryName: category))
        }
    }
}

struct CategoryTaskCell : View {
    
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
                }
            }
            VStack{
                DisclosureGroup(task.name){
                    HStack{
                        Text("Description: ").bold()
                        Text(task.summary).multilineTextAlignment(.leading)
                    }.frame(maxWidth: .infinity,alignment:.leading)
                    HStack{
                        Text("Start Date: ").bold()
                        Text(task.startDate.toString())
                    }.frame(maxWidth: .infinity,alignment:.leading)
                    HStack{
                        Text("End Date: ").bold()
                        Text(task.dueDate.toString())
                    }.frame(maxWidth: .infinity,alignment:.leading)
                }.frame(minHeight: 50).foregroundStyle(.white)
            }.frame(maxWidth: .infinity,alignment: .leading).padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
        }.contextMenu{
            Button("Edit Task"){
                navigationController?.pushViewController(EditTaskViewController(task: task), animated: true)
            }
            Button("Delete Task"){
                
            }
        }
        
    }
}


