//
//  Location.swift
//  TimeCraft
//
//  Created by Akhilesh Warty on 2023-09-06.
//

import Foundation
import MapKit

private extension CLLocation{
    static var `default` : CLLocation{
        CLLocation(latitude: 36.06, longitude: -96)
    }
}

class Location : MKPointAnnotation{
    
    let mapItem : MKMapItem
    let uuid = UUID()
    var selectedFlag : Bool
    var distance : String
    
    var name : String{
        return mapItem.name ?? ""
    }
    
    var phone : String{
        return mapItem.phoneNumber ?? ""
    }
    
    var location : CLLocation{
        return mapItem.placemark.location ?? CLLocation.default
    }
    var address : String{
        return "\(mapItem.placemark.subThoroughfare ?? "") \(mapItem.placemark.thoroughfare ?? "") \(mapItem.placemark.locality ?? "") \(mapItem.placemark.countryCode ?? "")"
    }
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
        self.selectedFlag = false
        self.distance = ""
        super.init()
        self.coordinate = mapItem.placemark.coordinate
    }
}
