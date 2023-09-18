//
//  RadioButton.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-16.
//

import UIKit

class RadioButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        tintColor = .white
        setImage(UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    

}
