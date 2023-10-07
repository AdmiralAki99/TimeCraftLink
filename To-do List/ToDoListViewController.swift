//
//  ToDoListViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-14.
//

import UIKit

enum ToDoListSection{
    case Category(viewModel: [CategoryViewController])
    case Tasks(viewModel: [Task])
    
    var title : String{
        switch self{
        case .Category:
            return "Category"
        case .Tasks:
            return "Today's Tasks"
        }
    }
}

class ToDoListViewController: UIViewController {
    
    var todoListSection = [ToDoListSection]()
    
    var categoriesButton : UIBarButtonItem?
    
    private let refreshControl = UIRefreshControl()
    
    private var collectionView = ToDoListManager.collectionView
    
    let addTaskButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.84, green: 0.24, blue: 0.96, alpha: 1.00)
        button.layer.cornerRadius = 30
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Whats up, Akhilesh!"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        categoriesButton = UIBarButtonItem(title: "Categories",image: UIImage(systemName: "square.grid.2x2"), target: self, action: #selector(showCategories))
        categoriesButton?.tintColor = .white
        
        navigationItem.rightBarButtonItem = categoriesButton
        
        let back_button = UIBarButtonItem(title: "Back",image: UIImage(systemName: "arrow.backward"), target: self, action: #selector(backButtonTapped))
        
        back_button.tintColor = .white
        
        navigationItem.leftBarButtonItem = back_button
        
        view.backgroundColor = UIColor(red: 0.21, green: 0.32, blue: 0.61, alpha: 1.00)
        
        ToDoListManager.collectionView.delegate = self
        ToDoListManager.collectionView.dataSource = self
        
        ToDoListManager.collectionView.register(ToDoCategoriesCollectionViewCell.self, forCellWithReuseIdentifier: ToDoCategoriesCollectionViewCell.identifier)
        
        ToDoListManager.collectionView.register(ToDoListTaskCollectionViewCell.self, forCellWithReuseIdentifier: ToDoListTaskCollectionViewCell.identifier)
        
        ToDoListManager.collectionView.backgroundColor = .clear
        
        ToDoListManager.toDoList_manager.createCategory(with: "Important", colour: UIColor.magenta,icon: "checklist.unchecked")
        ToDoListManager.toDoList_manager.createCategory(with: "Personal", colour: UIColor.systemGreen,icon: "person.fill.checkmark")
        ToDoListManager.toDoList_manager.createCategory(with: "School", colour: .systemCyan,icon: "backpack.fill")
        
        ToDoListManager.toDoList_manager.createCategory(with: "Projects", colour: .systemPurple, icon: "macpro.gen1.fill")
        
        todoListSection.append(.Category(viewModel: ToDoListManager.toDoList_manager.getCategoryLists()))
        
        ToDoListManager.toDoList_manager.createTask(with: Task(name: "Create To Do List", category: "Important", description: "Creating the Initial To-do List", dueDate: Date()), category: "Important")
        
        ToDoListManager.toDoList_manager.createTask(with: Task(name: "Retreive Today's Tasks", category: "Personal", description: "Getting todays tasks", dueDate: Date()), category: "Personal")
        
        ToDoListManager.toDoList_manager.createTask(with: Task(name: "Check Watch Development", category: "Personal", description: "Check today's development", dueDate: Date()), category: "Important")
        
        ToDoListManager.toDoList_manager.createTask(with: Task(name: "Go-To School", category: "School", description: "Getting ready for university", dueDate: Date()), category: "School")
        
        todoListSection.append(.Tasks(viewModel: ToDoListManager.toDoList_manager.getTodaysTasks(with: Date())))
        
        addTaskButton.addTarget(self, action: #selector(newTaskScreenTapped), for: .touchUpInside)
        
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        
        ToDoListManager.convertTasksToString()

        ToDoListManager.collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(ToDoListManager.collectionView)
        view.addSubview(addTaskButton)
        view.bringSubviewToFront(addTaskButton)
        
        ToDoListManager.collectionView.frame = view.bounds
        addTaskButton.frame = CGRect(x: view.width - 100, y: view.height - 120, width: 60, height: 60)
    }
    
    @objc func showCategories(){
        let categoryViewController = ToDoListCategoryViewController()
        categoryViewController.modalPresentationStyle = .overCurrentContext
        present(categoryViewController, animated: true)
    }
    
    @objc func newTaskScreenTapped(){
        navigationController?.pushViewController(NewTaskViewController(), animated: true)
    }
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshCollectionView(){
        collectionView.reloadData()
        print(ToDoListManager.todays_tasks)
        ToDoListManager.convertTasksToString()
        self.refreshControl.endRefreshing()
    }

    static func generateCollectionView(with sectionIndex : Int) -> NSCollectionLayoutSection{
        switch sectionIndex{
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5)
            
            let horizontal_group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(100)), subitem: item, count: 1)
            
            let vertical_group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(180), heightDimension: .absolute(100)), subitem: horizontal_group, count: 1)
            
            let section = NSCollectionLayoutSection(group: vertical_group)
            
            section.orthogonalScrollingBehavior = .continuous
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 20)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
    
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ToDoListViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = todoListSection[section]
        
        switch section{
        case .Category(let viewModel):
            return viewModel.count
        case .Tasks(let viewModel):
            return ToDoListManager.todays_tasks.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = todoListSection[indexPath.section]
        switch section{
        case .Category(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoCategoriesCollectionViewCell.identifier, for: indexPath) as? ToDoCategoriesCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.generateViewCell(category: viewModel[indexPath.row])
            return cell
        case .Tasks:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoListTaskCollectionViewCell.identifier, for: indexPath) as? ToDoListTaskCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.generateCell(with: ToDoListManager.todays_tasks[indexPath.row])
            
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return todoListSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = todoListSection[indexPath.section]
        
        switch section{
        case .Category(let viewModel):
            navigationController?.pushViewController(viewModel[indexPath.row], animated: true)
            navigationController?.navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        case .Tasks(let viewModel):
            break
            
        }
    }
    
    
}
