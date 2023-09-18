//
//  DirectionDisplayViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-10.
//

import UIKit
import CoreLocation
import MapKit

enum Transportation{
    case Walk
    case Transit
    case Drive
    case Cycle
    case Ride_Share
    
    var colour : UIColor{
        switch self {
        case .Walk:
            return UIColor.systemGreen
        case .Transit:
            return UIColor.systemBlue
        case .Drive:
            return UIColor.systemMint
        case .Cycle:
            return UIColor.systemPink
        case .Ride_Share:
            return UIColor.systemCyan
        }
    }
    
    var title : String{
        switch self {
        case .Walk:
            return "Walk"
        case .Transit:
            return "Transit"
        case .Drive:
            return "Drive"
        case .Cycle:
            return "Cycle"
        case .Ride_Share:
            return "Ride Share"
        }
    }
    
    var symbol : String {
        switch self {
        case .Walk:
            return "figure.walk"
        case .Transit:
            return "bus.doubledecker"
        case .Drive:
            return "car"
        case .Cycle:
            return "scooter"
        case .Ride_Share:
            return "car.2"
        }
    }
    
    var transportType : MKDirectionsTransportType{
        switch self {
        case .Walk:
            return .walking
        case .Transit:
            return .transit
        case .Drive:
            return .automobile
        case .Cycle:
            return .walking
        case .Ride_Share:
            return .automobile
        }
    }
}

class DirectionDisplayViewController: UIViewController {
    
    var routes : [MKRoute]
    let userLocation : CLLocation
    let destination : Location
    
    var transitButtonStatus = Transportation.Walk
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        label.font = .preferredFont(forTextStyle: .title1)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    let currentLocationTextField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
    }()
    
    let destinationTextField : UITextField = {
        let textField = UITextField()
        textField.borderStyle = .line
        textField.layer.borderColor = UIColor.white.cgColor
        return textField
    }()
    
    private var collectionView : UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return DirectionDisplayViewController.generateCollectionView(with: sectionIndex)
    })
    
    let transitTypeButton : UIButton = {
        let button = UIButton()
        button.setTitle("Walk", for: .normal)
        button.tintColor = UIColor.systemGreen
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = true
        button.setImage(UIImage(systemName: "figure.walk"), for: .normal)
        return button
    }()
    
    let avoidOptionsButton : UIButton = {
        let button = UIButton()
        button.setTitle("Avoid", for: .normal)
        button.tintColor = UIColor.systemYellow
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setImage(UIImage(systemName: "hazardsign"), for: .normal)
        return button
    }()
    
    let displayStack = UIStackView()
    let textFieldStack = UIStackView()
    let buttonStack = UIStackView()
    let routeStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(RouteCollectionViewCell.self, forCellWithReuseIdentifier: RouteCollectionViewCell.identifier)
        
        createStack()
        
        collectionView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(displayStack)
        
        collectionView.reloadData()
    }
    
    init(userLocation : CLLocation , destination : Location, routes : [MKRoute]){
//        MapManager.map_manager.clearRoutes()
        self.routes = routes
        self.userLocation = userLocation
        self.destination = destination
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func createStack(){
        displayStack.heightAnchor.constraint(equalToConstant: view.height).isActive = true
        displayStack.widthAnchor.constraint(equalToConstant: view.width).isActive = true
        displayStack.backgroundColor = .black
        displayStack.alignment = .fill
        displayStack.translatesAutoresizingMaskIntoConstraints = false
        displayStack.axis = .vertical
        displayStack.spacing = UIStackView.spacingUseSystem
        displayStack.isLayoutMarginsRelativeArrangement = true
        displayStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        titleLabel.text = "Directions"
        displayStack.addArrangedSubview(titleLabel)
        
        textFieldStack.alignment = .leading
        textFieldStack.translatesAutoresizingMaskIntoConstraints = false
        textFieldStack.axis = .vertical
        textFieldStack.spacing = UIStackView.spacingUseSystem
        textFieldStack.isLayoutMarginsRelativeArrangement = true
        textFieldStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        
        currentLocationTextField.text = "My Location"
        destinationTextField.text = destination.name
        
        textFieldStack.addArrangedSubview(currentLocationTextField)
        textFieldStack.addArrangedSubview(destinationTextField)
        
        displayStack.addArrangedSubview(textFieldStack)
        
        buttonStack.alignment = .leading
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillProportionally
        buttonStack.spacing = 20
        buttonStack.isLayoutMarginsRelativeArrangement = true
        buttonStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        
        transitTypeButton.addTarget(self, action: #selector(updateButton), for: .touchUpInside)
        
        buttonStack.addArrangedSubview(transitTypeButton)
        buttonStack.addArrangedSubview(avoidOptionsButton)
        
        displayStack.addArrangedSubview(buttonStack)
        
        routeStack.alignment = .leading
        routeStack.translatesAutoresizingMaskIntoConstraints = false
        routeStack.axis = .vertical
        routeStack.spacing = 20
        routeStack.isLayoutMarginsRelativeArrangement = true
        routeStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        routeStack.backgroundColor = .black
        routeStack.distribution = .fill
        
        collectionView.frame = displayStack.bounds
        collectionView.backgroundColor = .clear
        
//        routeStack.addArrangedSubview(collectionView)
        
        displayStack.addArrangedSubview(collectionView)
    }
    
    static func generateCollectionView(with sectionIndex: Int) -> NSCollectionLayoutSection{
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    @objc func updateButton(){
        switch transitButtonStatus {
        case .Walk:
            transitButtonStatus = .Transit
            transitTypeButton.tintColor = transitButtonStatus.colour
            transitTypeButton.setTitle(transitButtonStatus.title, for: .normal)
            transitTypeButton.layer.borderColor = transitButtonStatus.colour.cgColor
            transitTypeButton.setImage(UIImage(systemName: transitButtonStatus.symbol), for: .normal)
            updateRoutes()
        case .Transit:
            transitButtonStatus = .Drive
            transitTypeButton.tintColor = transitButtonStatus.colour
            transitTypeButton.setTitle(transitButtonStatus.title, for: .normal)
            transitTypeButton.layer.borderColor = transitButtonStatus.colour.cgColor
            transitTypeButton.setImage(UIImage(systemName: transitButtonStatus.symbol), for: .normal)
            updateRoutes()
        case .Drive:
            transitButtonStatus = .Cycle
            transitTypeButton.tintColor = transitButtonStatus.colour
            transitTypeButton.setTitle(transitButtonStatus.title, for: .normal)
            transitTypeButton.layer.borderColor = transitButtonStatus.colour.cgColor
            transitTypeButton.setImage(UIImage(systemName: transitButtonStatus.symbol), for: .normal)
            updateRoutes()
        case .Cycle:
            transitButtonStatus = .Ride_Share
            transitTypeButton.tintColor = transitButtonStatus.colour
            transitTypeButton.setTitle(transitButtonStatus.title, for: .normal)
            transitTypeButton.layer.borderColor = transitButtonStatus.colour.cgColor
            transitTypeButton.setImage(UIImage(systemName: transitButtonStatus.symbol), for: .normal)
            updateRoutes()
        case .Ride_Share:
            transitButtonStatus = .Walk
            transitTypeButton.tintColor = transitButtonStatus.colour
            transitTypeButton.setTitle(transitButtonStatus.title, for: .normal)
            transitTypeButton.layer.borderColor = transitButtonStatus.colour.cgColor
            transitTypeButton.setImage(UIImage(systemName: transitButtonStatus.symbol), for: .normal)
            updateRoutes()
        }
    }
    
    func updateRoutes(){
        MapManager.map_manager.clearRoutes()
        MapManager.map_manager.getRoutes(with: userLocation, destination: destination, transportType: transitButtonStatus.transportType) { result in
            switch result{
            case .success(let routes):
                self.routes = routes
            case .failure(let error):
                break
            }
            
            self.collectionView.reloadData()
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

extension DirectionDisplayViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteCollectionViewCell.identifier, for: indexPath) as? RouteCollectionViewCell else{
            return UICollectionViewCell()
        }
        
        cell.layer.cornerRadius = 12
        
        cell.generateCell(route: routes[indexPath.row], currentLocation: userLocation, endLocation: destination)
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return routes.count
    }
    
}
