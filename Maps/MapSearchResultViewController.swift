//
//  MapSearchResultViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-06.
//

import UIKit
import MapKit

enum MapSearchSections{
    case FriendInfo(viewModel: [FriendInfo])
    case LocalSearchInfo(viewModel: [Location])
    
    var title : String{
        switch self{
        case .FriendInfo:
            return "Friends"
        case .LocalSearchInfo:
            return "Locations"
        }
    }
}

protocol MapSearchResultViewControllerDelegate : AnyObject{
    func showResult(_ controller : UIViewController)
    
}

class MapSearchResultViewController: UIViewController {
    
    var userLocation : CLLocation
    
    var resultSections = [MapSearchSections]()
    
    var searchedLocations = [Location]()
    
    let blurView : UIVisualEffectView = {
        let view = UIVisualEffectView()
        
        return view
    }()
    
    var indexAtFirstPlace : Int?{
        return searchedLocations.firstIndex(where:{$0.selectedFlag == true})
    }
    
    private var collectionView : UICollectionView = UICollectionView(frame: .zero , collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
        return MapSearchResultViewController.generateCollectionView(with: sectionIndex)
    })
    
    weak var delegate : MapSearchResultViewControllerDelegate?
    
    init(currentLocation: CLLocation, locations: [Location]){
        userLocation = currentLocation
        let friends = [FriendInfo(name: "Akhilesh Warty", image: ""),FriendInfo(name: "User Name", image: ""),FriendInfo(name: "User Name 2", image: ""),FriendInfo(name: "User Name 3", image: "")]
        searchedLocations = locations
        super.init(nibName: nil, bundle: nil)
        
        searchedLocations.swapAt(self.indexAtFirstPlace ?? 0, 0)
        populateSearchResults(with: friends, locationInfo: locations)
    }
    
    //todo: Add Dismiss function
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.showsHorizontalScrollIndicator = true
        
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.register(FriendInfoCollectionViewCell.self, forCellWithReuseIdentifier: FriendInfoCollectionViewCell.identifier)
        collectionView.register(LocationCollectionViewCell.self, forCellWithReuseIdentifier: LocationCollectionViewCell.identifier)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func clearCollectionView(){
        resultSections = []
        
        collectionView.reloadData()
    }
    
    func presentDisplayInfo(location: Location){
        
        let displayViewController = DisplayLocationInfoViewController(location: location,userLocation: userLocation)
            
            displayViewController.modalPresentationStyle = .pageSheet
        
//        locationCollectionViewController.updateSearchResults(with: searchedLocations.map({$0.mapItem}))
        
        if let displaySheet = displayViewController.sheetPresentationController{
            displaySheet.prefersGrabberVisible = true
            displaySheet.detents = [.medium(),.large()]
            present(displayViewController, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        initalizeBlurView()
        view.addSubview(collectionView)
        
        collectionView.frame = view.bounds
    }
    
    func initalizeBlurView(){
        
        blurView.frame = view.frame
        
        blurView.effect = UIBlurEffect(style: .regular)
        
        view.addSubview(blurView)
    }
    
    func calculateDistanceFromUser(currentLocation: CLLocation,selectedLocation : CLLocation) -> CLLocationDistance{
        return currentLocation.distance(from: selectedLocation)
    }
    
    func formatDistance(distance:CLLocationDistance) -> String{
        var distance = Measurement(value: distance, unit: UnitLength.meters)
        return distance.converted(to: UnitLength.meters).formatted()
    }
    
    static func generateCollectionView(with sectionIndex: Int)-> NSCollectionLayoutSection{
        switch sectionIndex{
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let horizontal_group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100)), subitem: item, count: 1)
            
            let vertical_group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100)), subitem: horizontal_group, count: 1)
            
            let section = NSCollectionLayoutSection(group: vertical_group)
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)

            return section
        default:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)), subitem: item, count:  1)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
    }
    
    func populateSearchResults(with friendInfo : [FriendInfo],locationInfo:[Location]){
        
        resultSections.append(.FriendInfo(viewModel: friendInfo))
        resultSections.append(.LocalSearchInfo(viewModel: locationInfo))
        
        collectionView.reloadData()
    }
    
    func updateSearchResults(with locations : [MKMapItem],currentLocation : CLLocation){
    }

}

extension MapSearchResultViewController : UICollectionViewDelegate{
    
}

extension MapSearchResultViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = resultSections[section]
        
        switch section{
        case .FriendInfo(let viewModels):
            return viewModels.count
        case .LocalSearchInfo(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath)
//
//        return cell
        
        let section = resultSections[indexPath.section]
        
        switch section{
        case .FriendInfo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendInfoCollectionViewCell.identifier, for: indexPath) as? FriendInfoCollectionViewCell else{
                return UICollectionViewCell()
            }
            
            let model = viewModel[indexPath.row]
            
            cell.generateCell(with: model)
            
            return cell
            
        case .LocalSearchInfo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath) as? LocationCollectionViewCell else{
                return UICollectionViewCell()
            }
            
            let model = viewModel[indexPath.row]
            
            let distance = formatDistance(distance: calculateDistanceFromUser(currentLocation: userLocation, selectedLocation: model.location))
            
            model.distance = distance
            
            cell.generateCell(with: model)
            
            if(model.selectedFlag == true){
                cell.backgroundColor = .systemGreen
            }
            
            return cell
            
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return resultSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = resultSections[indexPath.section]
        
        switch section{
        case .FriendInfo:
            print("Touched Friend Cell")
        case .LocalSearchInfo:
            let location = searchedLocations[indexPath.row]
            presentDisplayInfo(location: location)
//            dropPin(location: location.placemark)
            
        }
    }
    
    
}

