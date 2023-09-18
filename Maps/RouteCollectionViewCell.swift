//
//  RouteCollectionViewCell.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-10.
//

import UIKit
import MapKit

class RouteCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RouteCollectionViewCell"
    
    var route : MKRoute?
    
    var userLocation: CLLocation?
    
    var destination : Location?
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    let distanceLabel : UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    let selectButton : UIButton = {
        let button = UIButton()
//        button.setTitle("Walk", for: .normal)
        button.tintColor = UIColor.white
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.cornerRadius = 10
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubview(timeLabel)
        addSubview(distanceLabel)
        addSubview(selectButton)
        
        selectButton.addTarget(self, action: #selector(displayRoute), for: .touchUpInside)
        
        backgroundColor = .systemCyan
//        timeLabel.text = "13 mins"
//        distanceLabel.text = "900m Mostly Flat"
//
        timeLabel.frame = CGRect(x: 10, y: 10, width: width - 80, height: 30)
        distanceLabel.frame = CGRect(x: 10, y: timeLabel.bottom, width: width - 80, height: 30)
        selectButton.frame = CGRect(x: timeLabel.right + 10, y: 10, width: 60, height: 60)
    
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func generateCell(route : MKRoute,currentLocation : CLLocation,endLocation : Location){
        self.route = route
        self.userLocation = currentLocation
        self.destination = endLocation
        
        let formatter = DateComponentsFormatter()
        
        formatter.allowedUnits = [.hour,.minute]
        
        let timeString = formatter.string(from: route.expectedTravelTime) ?? ""
        
        timeLabel.text = timeString + " minutes"
        
        distanceLabel.text = MapManager.map_manager.formatDistance(distance: MapManager.map_manager.calculateDistanceFromUser(currentLocation: userLocation!, selectedLocation: destination!.location))
    }
    
    @objc func displayRoute(){
        guard let route = self.route else{
            return
        }
        MapManager.map_manager.clearRoutes()
        MapManager.map_manager.displayRoute(route: route)
        MapManager.map_manager.getDirection(with: route)
    }
}
