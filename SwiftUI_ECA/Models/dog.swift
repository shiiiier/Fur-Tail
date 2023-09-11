//
//  dog.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 8/9/22.
//
import CoreLocation
import Foundation
import SwiftUI
import FirebaseCore
import Firebase
import FirebaseStorage
import MapKit

struct Dog: Identifiable, Hashable {

    var id: String
    var name: String
    var gender: String
    var age: String
    var imageURL: String
    var ownerUID: String
    var vaccStatus: String
    var latitude: Double
    var longitude: Double
    var breed: String
    var ownerName: String
    var date: String
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var imageList: [UIImage]
}

