//
//  MapManager.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-02.
//

import Foundation
import MapKit

class MapManager{
    
    /*
     MARK: Base API
     */
    
    struct API{
        let base_url = "http://maps.apple.com"
    }
    // One instance of MapManager class that can be accessed by the app.
    static let map_manager = MapManager()
    // One instance of an array of routes which is refreshed when a new location is seleceted or MOT changes
    static var routes = [MKRoute]()
    // Once instance of map that needs to be updated and annotated from different screens and view controllers
    static let mapView : MKMapView = MKMapView()
    // Random colors to make the map routes interesting instead of blue all the time
    static let overlayColors = [
        UIColor.systemRed,
        UIColor.systemBlue,
        UIColor.systemGreen,
        UIColor.systemOrange,
        UIColor.systemPurple,
        UIColor.systemYellow,
        UIColor.systemPink,
        UIColor.systemTeal,
        UIColor.systemIndigo,
        UIColor.systemGray,
    ]
    
    /*
     MARK: API Response Error
     */
    
    enum MapResponseError : Error{
        case FailedToGetLocation
        case FailedToGetDirections
    }
    
    /*
     MARK: API CALLS
     */
    
    func searchForLocation(with location:String, completion: @escaping(((Result<[MKMapItem],Error>) -> Void))){
        
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = location
        
        do{
            let searchQuery = MKLocalSearch(request: request)
            
            searchQuery.start { response, err in
                guard let response = response, err == nil else{
                    completion(.failure(MapResponseError.FailedToGetLocation))
                    return
                }
                completion(.success(response.mapItems))
            }
        }catch{
            completion(.failure(error))
            print(error.localizedDescription)
        }
        
    }
    
    func createAnnotation(with location: MKPlacemark) -> MKAnnotation{
        let pin = MKPointAnnotation()
        
        pin.coordinate = location.coordinate
        pin.title = location.name
        
        if let city = location.locality, let state = location.administrativeArea{
            pin.subtitle = "\(city) \(state)"
        }
        
        return pin
    }
    
    func getRoutes(with currentLocation : CLLocation, destination : Location,transportType : MKDirectionsTransportType,completion: @escaping (Result<[MKRoute],Error>) -> Void){
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
        directionsRequest.destination = destination.mapItem
        directionsRequest.requestsAlternateRoutes = true
        directionsRequest.transportType = transportType
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate { response, err in
            guard let response = response, err == nil else{
                completion(.failure(MapResponseError.FailedToGetDirections))
                return
            }
            
            MapManager.routes = response.routes
            
            completion(.success(response.routes))
        }
//            for route in response.routes{
//                MapManager.mapView.addOverlay(route.polyline)
//                MapManager.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//            }
        
        
    }
    
    func calculateDistanceFromUser(currentLocation: CLLocation,selectedLocation : CLLocation) -> CLLocationDistance{
        return currentLocation.distance(from: selectedLocation)
    }
    
    func formatDistance(distance:CLLocationDistance) -> String{
        var distance = Measurement(value: distance, unit: UnitLength.meters)
        return distance.converted(to: UnitLength.meters).formatted()
    }
    
    func calculateTimeTaken(currentLocation: CLLocation,selectedLocation : CLLocation){
        
    }
    
    func displayRoute(route:MKRoute){
        MapManager.mapView.addOverlay(route.polyline)
        MapManager.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
    }
    
    func clearRoutes(){
        for route in MapManager.routes {
            MapManager.mapView.removeOverlay(route.polyline)
        }
    }
    
    func getDirection(with route : MKRoute){
        for steps in route.steps{
            print("\(steps.notice);\(steps.instructions);\(steps.description)")
            
        }
    }
    
    func randomSelectOverlayColor() -> UIColor{
        return MapManager.overlayColors.randomElement() ?? UIColor.systemPurple
    }
    
    
    
    
}
