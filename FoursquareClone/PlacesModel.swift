//
//  PlacesModel.swift
//  FoursquareClone
//
//  Created by Meryem Demir on 14.10.2025.
//

import Foundation
import UIKit

class PlacesModel {
    
    static let sharedInstance = PlacesModel()
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(){}
}
