//
//  MKMapView+extensions.swift
//  mobile-my-weather
//
//  Created by Ivan Veramyou on 18.02.24.
//

import MapKit


private enum Constants {
    static let radius: CLLocationDistance = 1000
    
    static let altitude: CLLocationDistance = 100   // Adjust the altitude (zoom level)
    static let pitch: CGFloat = 55                  // Set the pitch (tilt) angle
    static let heading: CLLocationDirection = 190   // Set the heading (rotation) angle
    
    enum Planet {
        // CLLocationCoordinate2D
        static let latitude:  CLLocationDegrees = 53.9006
        static let longitude:  CLLocationDegrees = 27.5590
        
        static let altitude: CLLocationDistance = 35_000_000
        static let pitch: CGFloat = 75
        static let heading: CLLocationDirection = 0
        
    }
    
}

extension MKMapView {
    
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = Constants.radius) {
        let region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        setRegion(region, animated: true)
    }
    
    func setupCamera(_ location: CLLocation, altitude: CLLocationDistance = Constants.altitude) {
        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        camera.altitude = altitude
        camera.pitch = Constants.pitch
        camera.heading = Constants.heading
        
        setCamera(camera, animated: true)
    }
    
    func setCameraToPlanet() {
        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(
            latitude: Constants.Planet.latitude,
            longitude: Constants.Planet.longitude
        )
        camera.altitude = Constants.Planet.altitude
        camera.pitch = Constants.Planet.pitch
        camera.heading = Constants.Planet.heading
        
        setCamera(camera, animated: true)
    }
    
}
