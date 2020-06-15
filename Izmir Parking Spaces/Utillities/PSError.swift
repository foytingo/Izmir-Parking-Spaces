//
//  PSError.swift
//  Izmir Parking Spaces
//
//  Created by Murat Baykor on 12.06.2020.
//  Copyright © 2020 Murat Baykor. All rights reserved.
//

import Foundation

enum PSError: String, Error {
    case invalidURL = "This url created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
