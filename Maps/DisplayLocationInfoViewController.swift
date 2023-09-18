//
//  DisplayLocationInfoViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-10.
//

import UIKit
import CoreLocation

class DisplayLocationInfoViewController: UIViewController {
    
    var location : Location
    var userLocation : CLLocation
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.textColor = .secondaryLabel
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let directionsButton : UIButton = {
        let config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.layer.borderColor = UIColor.systemGreen.cgColor
        button.layer.borderWidth = 2
        button.setImage(UIImage(systemName: "arrow.triangle.turn.up.right.diamond"), for: .normal)
        button.tintColor = .white
//        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
//        button.setTitle("Directions", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let callButton : UIButton = {
        let config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.setImage(UIImage(systemName: "phone"), for: .normal)
        button.tintColor = .white
//        button.backgroundColor = .purple
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
//        button.setTitle("Directions", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let websiteButton : UIButton = {
        let config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.setImage(UIImage(systemName: "safari"), for: .normal)
        button.tintColor = .white
        button.layer.borderColor = UIColor.systemYellow.cgColor
        button.layer.borderWidth = 2
//        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
//        button.setTitle("Directions", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let smartwatchButton : UIButton = {
        let config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.setImage(UIImage(systemName: "applewatch"), for: .normal)
        button.tintColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
//        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
//        button.setTitle("Directions", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let shareButton : UIButton = {
        let config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .white
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 2
//        button.backgroundColor = .purple
        button.layer.cornerRadius = 10
//        button.setTitle("Directions", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
   
    
    let nameStackView = UIStackView()
    let buttonStackView = UIStackView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        createNameStackView()

        // Do any additional setup after loading the view.
    }
    
    func createNameStackView(){
        nameStackView.alignment = .leading
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.axis = .vertical
        nameStackView.spacing = UIStackView.spacingUseSystem
        nameStackView.isLayoutMarginsRelativeArrangement = true
        nameStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)

        nameLabel.text = location.name
        categoryLabel.text = location.address

        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(categoryLabel)
        
        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 10).isActive = true
        
        buttonStackView.alignment = .leading
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.isLayoutMarginsRelativeArrangement = true
        buttonStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        
        buttonStackView.addArrangedSubview(directionsButton)
        directionsButton.addTarget(self, action: #selector(findDirections), for: .touchUpInside)
        buttonStackView.addArrangedSubview(callButton)
        buttonStackView.addArrangedSubview(websiteButton)
        buttonStackView.addArrangedSubview(smartwatchButton)
        buttonStackView.addArrangedSubview(shareButton)
        
        buttonStackView.backgroundColor = .clear
        
        nameStackView.addArrangedSubview(buttonStackView)
        
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(nameStackView)
        
    }
    
    init(location: Location,userLocation: CLLocation) {
        self.location = location
        self.userLocation = userLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func findDirections(_ sender:UIButton){
        MapManager.map_manager.clearRoutes()
        MapManager.map_manager.getRoutes(with: userLocation, destination: location, transportType: .walking) { result in
            switch result{
            case .success(let routes):
                let routeDisplayViewController = DirectionDisplayViewController(userLocation: self.userLocation, destination: self.location, routes: routes)
                self.displayRouteSelector(with: routeDisplayViewController)
            case .failure(let error):
                break
            }
        }
    }
    
    func displayRouteSelector(with routeSelector : UIViewController){
        routeSelector.modalPresentationStyle = .pageSheet
        
//        locationCollectionViewController.updateSearchResults(with: searchedLocations.map({$0.mapItem}))
        
        if let routesheet = routeSelector.sheetPresentationController{
            routesheet.prefersGrabberVisible = true
            routesheet.detents = [.medium(),.large()]
            present(routeSelector, animated: true)
        }
    }
}
