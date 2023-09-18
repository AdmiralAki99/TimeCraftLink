//
//  SelectedCategoryNewTaskViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-17.
//

import UIKit

protocol ModalListener{
    func popOverDismissed()
}

class SelectedCategoryNewTaskViewController: UIViewController {

    let taskName : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Task Name"
        textField.textColor = .secondaryLabel
        return textField
    }()
    
    let dueDate : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.backgroundColor = .clear
        picker.tintColor = .systemPurple
        return picker
    }()
    
    var selectedCategory = ""
    
    var selectedDate : Date?
    
    let addTaskButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.84, green: 0.24, blue: 0.96, alpha: 1.00)
        button.layer.cornerRadius = 30
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        return button
    }()
    
    let dismissButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        return button
    }()
    
    init(categoryName : String){
        selectedCategory = categoryName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.21, green: 0.32, blue: 0.61, alpha: 1.00)
        
        let back_button = UIBarButtonItem(title: "Back",image: UIImage(systemName: "arrow.backward"), target: self, action: #selector(backButtonTapped))
        
        dueDate.addTarget(self, action: #selector(didSelectDate), for: .valueChanged)
        addTaskButton.addTarget(self, action: #selector(didCreateTask), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(didDismiss), for: .touchUpInside)
        
        back_button.tintColor = .white
        
        navigationItem.leftBarButtonItem = back_button

        // Do any additional setup after loading the view.
    }
    
    @objc func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(taskName)
        view.addSubview(dueDate)
        view.addSubview(addTaskButton)
        view.addSubview(dismissButton)
        
        taskName.frame = CGRect(x: 20, y: view.height/2 - 50, width: view.width - 20, height: 20)
        dueDate.frame = CGRect(x: 20, y: view.height/2 - 30, width: 125, height: 40)
        addTaskButton.frame = CGRect(x: view.width - 100, y: view.height - 120, width: 60, height: 60)
        dismissButton.frame = CGRect(x: view.width - 40, y: 20, width: 30, height: 30)
    }
    
    @objc func didSelectDate(){
        selectedDate = dueDate.date
    }
    
    @objc func didDismiss(){
//        if let firstVC = presentingViewController as? CategoryViewController {
//                DispatchQueue.main.async {
//                    firstVC.dismiss(animated: true)
//                }
//            }
        dismiss(animated: true)
    }
    
    @objc func didCreateTask(){
        ToDoListManager.toDoList_manager.createTask(with: Task(name: "New Event", category: selectedCategory, description: "New Event Trial", dueDate: Date()), category: selectedCategory)
        
        print("Adding Event")
        
//        firstVC.category.tasks.append(Task(name: "New Event", category: self.selectedCategory, description: "New Event Trial", dueDate: Date()))
        
        ToDoListManager.collectionView.reloadData()
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
