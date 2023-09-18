//
//  SectionHeader.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-08-20.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let identifier = "SectionHeaderReusableView"
    
    private let headerTitle : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18,weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerTitle)
        backgroundColor = .systemBackground
        headerTitle.text = "Example"
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerTitle.frame = CGRect(x: 10, y: 0, width: width-20, height: height)
    }
    
    func configure(with title: String){
        headerTitle.text = title
    }
}
