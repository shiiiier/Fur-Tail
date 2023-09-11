//
//  LocationViewModel.swift
//  SwiftUI_ECA
//
//  Created by Shi Er Lee on 13/9/22.
//

import SwiftUI
import MapKit

final class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    
    @Published var region = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: 1.2837,
                        longitude: 103.8509),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.1,
                        longitudeDelta: 0.1)
                    )
    @Published var location: CLLocation? = nil
    @Published var latitude: Double = 0.00
    @Published var longitude: Double = 0.00
    @Published var coordinates = [Double]()
    
    var locationManager: CLLocationManager?

    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.delegate = self
        } else {
            print("Show alert")
        }
    }
    
    private func checkLocationAuthotization() {
        guard let locationManager = locationManager else {
            return
        }
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted")
        case .denied:
            print("Permission denied")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            
            self.latitude = locationManager.location!.coordinate.latitude
            self.longitude = locationManager.location!.coordinate.longitude
            
            self.coordinates.append(self.latitude)
            self.coordinates.append(self.longitude)
            
            print("From coordinates array: \(self.coordinates[0])")
            print("From coordinates array: \(self.coordinates[1])")
            
        @unknown default:
            break
        }
    }

                                        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthotization()
    }
}
