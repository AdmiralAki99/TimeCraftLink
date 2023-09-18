//
//  ToDoCategoriesCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-16.
//

import UIKit

class ToDoCategoriesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ToDoCategoriesCollectionViewCell"
    
    var tasks = [Task]()
    
    var completedTasks = [Task]()
    
    var categoryColour : UIColor?
    
    let taskCountLabel : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()
    
    let progressSlider : UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.tintColor = .systemGreen
        slider.setThumbImage(UIImage(), for: .normal)
        slider.isEnabled = false
        return slider
    }()
    
    override func layoutSubviews() {
        addSubview(taskCountLabel)
        addSubview(categoryLabel)
        addSubview(progressSlider)
        
        backgroundColor = UIColor(red: 0.02, green: 0.10, blue: 0.29, alpha: 1.00)
        
        taskCountLabel.frame = CGRect(x: 10, y: height/2 - 30, width: width, height: 20)
        categoryLabel.frame = CGRect(x: 10, y: taskCountLabel.bottom + 10, width: width, height: 20)
        
        progressSlider.frame = CGRect(x: 10, y: categoryLabel.bottom + 5, width: width - 20, height: 20)
        
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    func generateViewCell(category : CategoryViewController){
        categoryLabel.text = category.category.categoryName
        tasks = ToDoListManager.toDoList_manager.getCategoryTasks(with: category.category)
        taskCountLabel.text = "\(tasks.count) Tasks"
        completedTasks = category.category.completedTasks
        categoryColour = category.category.colour
        progressSlider.tintColor = categoryColour
    }
    
}
