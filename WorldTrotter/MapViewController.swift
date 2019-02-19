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
    let locations = ["Birth place": (lat:45.6580, long: 25.6012),
                     "Current place": (lat: 43.6532, long:-79.3832),
                     "Dream place": (lat:35.6895, long: 139.6917)]
    var currentLocationIndex = 0
    var annotations: [MKPointAnnotation] = []
    
    override func loadView(){
        mapView = MKMapView()
        view = mapView
        
        // Add Segment to select map type
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        // Set Segment constraints
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        topConstraint.isActive = true
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        leadingConstraint.isActive = true
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        trailingConstraint.isActive = true
        
        // Request permissions for location
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        
        // Button to Locate to current postion
        let locateButton = UIButton(type: .roundedRect)
        locateButton.setImage(UIImage(named: "MyLocation"), for: .normal)
        locateButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        locateButton.layer.cornerRadius = 6
        locateButton.translatesAutoresizingMaskIntoConstraints = false
        locateButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        locateButton.addTarget(self, action: #selector(MapViewController.showMeOnMap), for: .touchUpInside)
        view.addSubview(locateButton)
        
        // Set Button constraints
        let locateButtonTopConstraint = locateButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 48)
        locateButtonTopConstraint.isActive = true
        let locateButtonTrailingConstraint = locateButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        locateButtonTrailingConstraint.isActive = true
        
        // Annotate places on map
        addMapAnnotations()
        
        // Button to cycle dropped annotations
        let cycleButton = UIButton(type: .roundedRect)
        cycleButton.setImage(UIImage(named: "DroppedPin"), for: .normal)
        cycleButton.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        cycleButton.layer.cornerRadius = 6
        cycleButton.translatesAutoresizingMaskIntoConstraints = false
        cycleButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        cycleButton.addTarget(self, action: #selector(MapViewController.cycleMapAnnotations), for: .touchUpInside)
        view.addSubview(cycleButton)
        
        // Set Button constraints
        let cycleButtonTopConstraint = cycleButton.topAnchor.constraint(equalTo: locateButton.bottomAnchor, constant: 8)
        cycleButtonTopConstraint.isActive = true
        let cycleButtonTrailingConstraint = cycleButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        cycleButtonTrailingConstraint.isActive = true
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
    
    func addMapAnnotations() {
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.value.lat, longitude: location.value.long)
            annotation.title = location.key
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
    }
    
    @objc func cycleMapAnnotations() {
        if currentLocationIndex >= locations.count {
            currentLocationIndex = 0
        }
        
        let currentAnnotation = annotations[currentLocationIndex]
        mapView.showAnnotations([currentAnnotation], animated: true)
        currentLocationIndex += 1
    }
}
