//
//  ParkData.swift
//  Izmir Parking Spaces
//
//  Created by Murat Baykor on 12.06.2020.
//  Copyright © 2020 Murat Baykor. All rights reserved.
//

import Foundation

struct ParkData: Codable {
    let ufid: String
    let name: String
    let type: String
    let status: String
    let occupancy: Occupancy
    let openingHours: Days
    let isPaid: Bool
    let nonstop: Bool
    let provider: String
    let accessibility: Accessibility
    let payment: Payment
    let lat: Double
    let lng: Double
    
}


struct Occupancy: Codable {
    let total: Total
}


struct Total: Codable {
    let free: Int
    let occupied: Int
}


struct Days: Codable {
    let monday: String
    let tuesday: String
    let wednesday: String
    let thursday: String
    let friday: String
    let saturday: String
    let sunday: String
}


struct Accessibility: Codable {
    let lpgAllowed: Bool
}


struct Payment: Codable {
    let sms: Bool
    let card: Bool
    let cash: Bool
}
