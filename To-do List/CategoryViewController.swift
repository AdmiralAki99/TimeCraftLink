//
//  CategoryViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-16.
//

import UIKit

class CategoryViewController: UIViewController {
    
    var category : ToDoListCategory
    
    var collectionView : UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return CategoryViewController.generateCollectionView(with: sectionIndex)
    })
    
    private let refreshControl = UIRefreshControl()
    
    let addTaskButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 20
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.tintColor = UIColor(red: 0.84, green: 0.24, blue: 0.96, alpha: 1.00)
        button.layer.masksToBounds = true
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(category: ToDoListCategory){
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(addTaskButton)
        
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        
        collectionView.addSubview(refreshControl)
        
        category.tasks = ToDoListManager.toDoList_manager.getCategoryTasks(with: category)
        
        collectionView.backgroundColor = .clear

        title = category.categoryName
        
        view.backgroundColor = UIColor(red: 0.21, green: 0.32, blue: 0.61, alpha: 1.00)
        
        let back_button = UIBarButtonItem(title: "Back",image: UIImage(systemName: "arrow.backward"), target: self, action: #selector(backButtonTapped))
        
        back_button.tintColor = .white
        
        navigationItem.leftBarButtonItem = back_button
        
        let add_button = UIBarButtonItem(title: "Add",image: UIImage(systemName: "plus"), target: self, action: #selector(addTask))
        
        add_button.tintColor = .white
        
        navigationItem.rightBarButtonItem = add_button
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ToDoListTaskCollectionViewCell.self, forCellWithReuseIdentifier: ToDoListTaskCollectionViewCell.identifier)
        
        collectionView.frame = view.bounds

        ToDoListManager.toDoList_manager.getTodaysTasks(with: Date())
        
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    static func generateCollectionView(with sectionIndex : Int) -> NSCollectionLayoutSection{
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 20)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            
            return section
    
    }
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshCollectionView(){
        self.category.tasks = ToDoListManager.toDoList_manager.getCategoryTasks(with: self.category)
        collectionView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    @objc func addTask(){
        let displayViewController = SelectedCategoryNewTaskViewController(categoryName: category.categoryName)
            
        displayViewController.modalPresentationStyle = .pageSheet
        
        if let displaySheet = displayViewController.sheetPresentationController{
            displaySheet.prefersGrabberVisible = true
            displaySheet.detents = [.medium(),.large()]
            present(displayViewController, animated: true)
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

extension CategoryViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ToDoListTaskCollectionViewCell.identifier, for: indexPath) as? ToDoListTaskCollectionViewCell else{
            return UICollectionViewCell()
        }
        cell.generateCell(with: category.tasks[indexPath.row])

        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    
}
