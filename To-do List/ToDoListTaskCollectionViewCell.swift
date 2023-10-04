//
//  ToDoListTaskCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-16.
//

import UIKit

class ToDoListTaskCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ToDoListTaskCollectionViewCell"
    
    let taskLabel : UILabel = {
        let label = UILabel()
        label.autoresizesSubviews = true
        label.text = "Task Name and Description"
        return label
    }()
    
    let radioButton : UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)
        return button
    }()
    
    override func layoutSubviews() {
        addSubview(taskLabel)
        addSubview(radioButton)
        
        radioButton.frame = CGRect(x: 10, y: height/2 - 10, width: 20, height: 20)
        
        taskLabel.frame = CGRect(x: radioButton.right + 5, y: height/2 - 10, width: width, height: 20)
        
        backgroundColor = UIColor(red: 0.02, green: 0.11, blue: 0.32, alpha: 1.00)
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    func generateCell(with task: Task){
        if task.taskStatus == .Ongoing{
            taskLabel.attributedText = nil
            taskLabel.text = task.name
        }else{
            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: task.name)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
            taskLabel.attributedText = attributeString
        }
       
    }
    
}
