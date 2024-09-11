//
//  CategoryViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-16.
//

import UIKit
import SwiftUI
import Charts
//
//class CategoryViewController: UIViewController {
//    
//    var category : ToDoListCategory
//    
//    var collectionView : UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
//        return CategoryViewController.generateCollectionView(with: sectionIndex)
//    })
//    
//    private let refreshControl = UIRefreshControl()
//    
//    let addTaskButton : UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .clear
//        button.layer.cornerRadius = 20
//        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
//        button.tintColor = UIColor(red: 0.84, green: 0.24, blue: 0.96, alpha: 1.00)
//        button.layer.masksToBounds = true
//        return button
//    }()
//    
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    
//    init(category: ToDoListCategory){
//        self.category = category
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(collectionView)
//        view.addSubview(addTaskButton)
//        
//        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
//        
//        collectionView.addSubview(refreshControl)
//        
//        category.tasks = ToDoListManager.toDoList_manager.getCategoryTasks(with: category)
//        
//        collectionView.backgroundColor = .clear
//
//        title = category.categoryName
//        
//        view.backgroundColor = UIColor(red: 0.21, green: 0.32, blue: 0.61, alpha: 1.00)
//        
//        let back_button = UIBarButtonItem(title: "Back",image: UIImage(systemName: "arrow.backward"), target: self, action: #selector(backButtonTapped))
//        
//        back_button.tintColor = .white
//        
//        navigationItem.leftBarButtonItem = back_button
//        
//        let add_button = UIBarButtonItem(title: "Add",image: UIImage(systemName: "plus"), target: self, action: #selector(addTask))
//        
//        add_button.tintColor = .white
//        
//        navigationItem.rightBarButtonItem = add_button
//        
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        
//        collectionView.register(ToDoListTaskCollectionViewCell.self, forCellWithReuseIdentifier: ToDoListTaskCollectionViewCell.identifier)
//        
//        collectionView.frame = view.bounds
//
//        ToDoListManager.toDoList_manager.getTodaysTasks(with: Date())
//        
//        collectionView.reloadData()
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//    }
//    
//    static func generateCollectionView(with sectionIndex : Int) -> NSCollectionLayoutSection{
//            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
//            
//            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 20)
//            
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item, count: 1)
//            let section = NSCollectionLayoutSection(group: group)
//            
//            return section
//    
//    }
//    
//    @objc func backButtonTapped(){
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @objc func refreshCollectionView(){
//        self.category.tasks = ToDoListManager.toDoList_manager.getCategoryTasks(with: self.category)
//        collectionView.reloadData()
//        self.refreshControl.endRefreshing()
//    }
//    
//    @objc func addTask(){
//        let displayViewController = SelectedCategoryNewTaskViewController(categoryName: category.categoryName)
//            
//        displayViewController.modalPresentationStyle = .pageSheet
//        
//        if let displaySheet = displayViewController.sheetPresentationController{
//            displaySheet.prefersGrabberVisible = true
//            displaySheet.detents = [.medium(),.large()]
//            present(displayViewController, animated: true)
//        }
//    }
//    
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
//extension CategoryViewController : UICollectionViewDelegate,UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return category.tasks.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoListTaskCollectionViewCell.identifier, for: indexPath) as? ToDoListTaskCollectionViewCell else{
//            return UICollectionViewCell()
//        }
//        cell.generateCell(with: category.tasks[indexPath.row])
//
//        return cell
//        
//    }
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        <#code#>
////    }
//    
//    
//}



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
                navigationController?.pushViewController(EditTaskViewController(), animated: true)
            }
        }
        
    }
}


