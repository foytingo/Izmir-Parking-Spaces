//
//  Parks.swift
//  Izmir Parking Spaces
//
//  Created by Murat Baykor on 12.06.2020.
//  Copyright © 2020 Murat Baykor. All rights reserved.
//

import MapKit
import Contacts

class Parks: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    let type: String?
    let status: String?
    let occupancy: Occupancy?
    let openingHours: Days?
    let provider: String?
    let payment: Payment?
    let isPaid: Bool?
    let parkInfo: String?
    
    var subtitle: String? {
        return parkInfo
    }
    
    var mapItem: MKMapItem? {
        guard let location = locationName else { return nil }
        
        let adressDict = [CNPostalAddressStreetKey: location]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: adressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    
    init?(park: ParkData) {
        title = park.name
        
        switch park.status {
        case "Opened":
            parkInfo = park.status + " - Free spaces: \(park.occupancy.total.free)"
            break
        case "Closed":
            parkInfo = park.status
        default:
            parkInfo = "No information"
        }
        
        coordinate = CLLocationCoordinate2D(latitude: park.lat, longitude: park.lng)
        type = park.type
        status = park.status
        locationName = park.name
        occupancy = park.occupancy
        openingHours = park.openingHours
        provider = park.provider
        payment = park.payment
        isPaid = park.isPaid
        
        super.init()
    }
    
}
