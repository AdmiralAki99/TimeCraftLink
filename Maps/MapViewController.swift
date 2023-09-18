//
//  MapViewController.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-02.
//

import UIKit
import MapKit
import CoreLocation

protocol MapSearch{
    func dropPin(location:MKPlacemark)
}

class MapViewController: UIViewController {
    
    var searchedLocations = [Location]()
    
    var selectedLocation : MKPlacemark? = nil
    
    let locationManager = CLLocationManager()
    
    let initialLocation = CLLocation(latitude: 37.785834, longitude: -122.406417)
    
    var search_button : UIBarButtonItem?
    
    let mapView : MKMapView = {
        let map = MapManager.mapView
        map.showsUserLocation = true
        map.showsCompass = true
        
        return map
    }()
    
    let searchField : UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.backgroundColor = UIColor.clear
        textField.placeholder = "Where do you want to go?"
        textField.textColor = .secondaryLabel
        textField.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = true
        
        return textField
    }()
    
//    let searchController : UISearchController = {
//
//        let controller = UISearchController(searchResultsController: MapSearchResultViewController())
//        controller.searchBar.placeholder = "Where do you want to go?"
//        controller.searchBar.searchBarStyle = .minimal
//
//        controller.definesPresentationContext = true
//        return controller
//
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
        
        let back_button = UIBarButtonItem(title: "Back",image: UIImage(systemName: "arrow.backward"), target: self, action: #selector(backButtonPressed))
        
        back_button.tintColor = .white
        
        navigationItem.leftBarButtonItem = back_button
//        navigationItem.rightBarButtonItem = search_button
        
//        searchController.searchBar.delegate = self
//        searchController.searchResultsUpdater = self
//        navigationItem.searchController = searchController
//        searchController.searchBar.searchBarStyle = .minimal
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.centerToLocation(initialLocation)
        mapView.selectableMapFeatures = [.pointsOfInterest]
        let mapConfiguration = MKStandardMapConfiguration()
//
//
        mapView.preferredConfiguration = mapConfiguration
        
        updateLocation()
        
        let region = MKCoordinateRegion(
              center: initialLocation.coordinate,
              latitudinalMeters: 50000,
              longitudinalMeters: 60000)
//            mapView.setCameraBoundary(
//              MKMapView.CameraBoundary(coordinateRegion: region),
//              animated: true)
//
//            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
//            mapView.setCameraZoomRange(zoomRange, animated: true)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

    }
    
    @objc func backButtonPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    func createUI(){
        view.addSubview(mapView)
        view.addSubview(searchField)
        
        view.bringSubviewToFront(searchField)
        
        searchField.delegate = self
        
        searchField.frame = CGRect(x: 10, y: 80, width: view.width - 20, height: 40)
        
        
        mapView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
        
        mapView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchForLocation(with location : String){
        mapView.removeAnnotations(mapView.annotations)

        MapManager.map_manager.searchForLocation(with: location) { result in
            switch result{
            case .success(let locations):
                self.searchedLocations = locations.map({
                    return Location(mapItem: $0)
                })
                self.searchedLocations.forEach { [weak self] location in
                    self?.mapView.addAnnotation(location)
                }
                self.displayLocationInfo()
            case .failure(let error):
                break
            }
        }
    }
    
    func clearSelections(){
        searchedLocations = searchedLocations.map { location in
            location.selectedFlag = false
            return location
        }
    }

}

extension MapViewController : CLLocationManagerDelegate{
    func initializeLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            let span = MKCoordinateSpan()
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        <#code#>
//    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
            print("error:: (error)")
        }
    
    func updateLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func displayLocationInfo(){
        
        guard let currentLocation = locationManager.location else{
            return 
        }
        
        let locationCollectionViewController = MapSearchResultViewController(currentLocation: currentLocation, locations: searchedLocations)
        locationCollectionViewController.modalPresentationStyle = .pageSheet
        
//        locationCollectionViewController.updateSearchResults(with: searchedLocations.map({$0.mapItem}))
        
        if let locationSheet = locationCollectionViewController.sheetPresentationController{
            locationSheet.prefersGrabberVisible = true
            locationSheet.detents = [.medium(),.large()]
            present(locationCollectionViewController, animated: true)
        }
    }
    
    
}

extension MapViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        
        if !text.isEmpty{
            textField.resignFirstResponder()

            searchForLocation(with: text)
            
        }
        
        return true
    }
    
    
}

//extension MapViewController : UISearchBarDelegate{
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        guard let resultSearchController = searchController.searchResultsController as? MapSearchResultViewController else{
//            return
//        }
//
//        resultSearchController.clearCollectionView()
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        guard let resultSearchController = searchController.searchResultsController as? MapSearchResultViewController,
//            let searchQuery = searchBar.text, !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else{
//            return
//        }
//
//        resultSearchController.delegate = self
//
//        resultSearchController.mapView = mapView
//
//        resultSearchController.clearCollectionView()
//
//        MapManager.map_manager.searchForLocation(with: searchQuery) { result in
//            switch result{
//            case .success(let locations):
//                self.searchedLocations = locations
//                resultSearchController.updateSearchResults(with: locations)
////                print(locations.first)
////                guard let placemark = locations.first?.placemark else{
////                    return
////                }
////                self.dropPin(location: placemark)
//            case .failure(let error):
//                break
//            }
//
//
//        }
//
//        resultSearchController.delegate = self
//
//    }
//
//
//}

//extension MapViewController : UISearchResultsUpdating{
//    func updateSearchResults(for searchController: UISearchController) {
//
//    }
//
//}

//extension MapViewController : MapSearchResultViewControllerDelegate{
//    func showResult(_ controller: UIViewController) {
//
//    }
//
//
//}

extension MapViewController : MapSearch{
    func dropPin(location: MKPlacemark) {
        selectedLocation = location
        
        mapView.removeAnnotations(mapView.annotations)
        
        let pin = MapManager.map_manager.createAnnotation(with: location)
        
        mapView.addAnnotation(pin)
        
        let span = MKCoordinateSpan()
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
//    func dropPin(location: MKPlacemark) {
//        mapView.removeAnnotations(mapView.annotations)
//
//        let pin = MapManager.map_manager.createAnnotation(with: location)
//
//        mapView.addAnnotation(pin)
//
//        let span = MKCoordinateSpan()
//        let region = MKCoordinateRegion(center: location.coordinate, span: span)
//        mapView.setRegion(region, animated: true)
//
//    }
    
    
}

extension MapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        clearSelections()
        
        guard let location = annotation as? Location else{
            return
        }
        
        let selectedLocation = searchedLocations.first(where: {$0.uuid == location.uuid})
        selectedLocation?.selectedFlag = true
        
        displayLocationInfo()
         
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        
        render.strokeColor = MapManager.map_manager.randomSelectOverlayColor()
        render.lineWidth = 2.0
        return render
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
