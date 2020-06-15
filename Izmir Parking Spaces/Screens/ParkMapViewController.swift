//
//  ParkMapViewController.swift
//  Izmir Parking Spaces
//
//  Created by Murat Baykor on 12.06.2020.
//  Copyright © 2020 Murat Baykor. All rights reserved.
//

import UIKit
import MapKit

class ParkMapViewController: DataLoadingVC {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var parks: [Parks] = [] {
        didSet {
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.parks)
            }
        }
    }
    
    
    private var parksData: [ParkData] = [] {
        didSet {
            for park in parksData {
                let newPark = Parks(park: park)
                parks.append(newPark!)
            }
        }
    }
    
    
    override func viewDidLoad() {
        configureNavBar()
        configureMapView()
        loadParks()
    }
    
    
    private func configureNavBar() {
        self.navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(showListView))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshParkData))
    }
    
    
    private func configureMapView() {
        let initialLocation = CLLocation(latitude: 38.434718, longitude: 27.142079)
        mapView.centerToLocation(initialLocation)
        
        let izmirCenter = CLLocation(latitude: 38.419019, longitude: 27.128451)
        let region = MKCoordinateRegion(center: izmirCenter.coordinate, latitudinalMeters: 15000, longitudinalMeters: 20000)
        
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 15000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        mapView.delegate = self
    }
    
    
    @objc func showListView() {
        if let vc = storyboard?.instantiateViewController(identifier: "ParkListView") as? ParkListViewController {
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    
    @objc func refreshParkData() {
        loadParks()
    }
    
    
    private func loadParks() {
        showLoadingView()
        NetworkManager.shared.getParksData { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let parks):
                self.parksData = parks
            case .failure(let error):
                self.presentAlertOnMainThread(alertTitle: "Error", alertMessage: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
}


private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 2000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}


extension ParkMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Parks else {
            return nil
        }
        let identifier = "parks"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        view.displayPriority = .required
        return view
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let park = view.annotation as? Parks else { return }
        
        if let vc = storyboard?.instantiateViewController(identifier: "ParkDetail") as? ParkDetailViewController {
            vc.park = park
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

