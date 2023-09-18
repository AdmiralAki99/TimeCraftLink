//
//  LocationCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-09.
//

import UIKit
import MapKit

class LocationCollectionViewCell: UICollectionViewCell {
    static let identifier = "LocationCollectionViewCell"
    
    let locationName : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "User Name"
        return label
    }()
    
    let locationSubtitle : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "User Name"
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        addSubview(locationName)
        addSubview(locationSubtitle)
        
        locationName.frame = CGRect(x: 25, y: 10, width: width, height: 20)
        locationSubtitle.frame = CGRect(x: 25, y: locationName.bottom, width: width, height: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func generateCell(with location: Location){
        locationName.text = location.name
        locationSubtitle.text = location.distance
    }
}
