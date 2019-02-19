//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Bogdan Orzea on 2/17/19.
//  Copyright © 2019 Bogdan Orzea. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    var mapView: MKMapView!
    var locationManager: CLLocationManager?
    var currentCoordinates: CLLocationCoordinate2D?
    
    override func loadView(){
        mapView = MKMapView()
        
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        topConstraint.isActive = true

        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)

        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        // Request permissions for location
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        // Button to Zoom to current location
        let locateButton = UIButton(type: .roundedRect)
        locateButton.setImage(UIImage(named: "MyLocation"), for: .normal)
        locateButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        locateButton.layer.cornerRadius = 6
        locateButton.translatesAutoresizingMaskIntoConstraints = false
        locateButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        locateButton.addTarget(self, action: #selector(MapViewController.showMeOnMap), for: .touchUpInside)
        view.addSubview(locateButton)
        
        let buttonTopConstraint = locateButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 48)
        buttonTopConstraint.isActive = true
        let buttonTrailingConstraint = locateButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        buttonTrailingConstraint.isActive = true
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        currentCoordinates = userLocation.location!.coordinate
    }
    
    override func viewDidLoad() {
        mapView.showsUserLocation = true
        mapView.delegate = self
    }
    
    @objc func showMeOnMap() {
        let regionRadius = 400
        if let coordinates = currentCoordinates {
            let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: CLLocationDistance(regionRadius), longitudinalMeters: CLLocationDistance(regionRadius))
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
}
