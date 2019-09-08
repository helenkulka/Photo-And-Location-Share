//
//  MapController.swift
//  gameOfChats
//
//  Created by Helen Kulka on 8/21/19.
//  Copyright © 2019 Helen Kulka. All rights reserved.
//

import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, LocationSearchControllerDelegate {
    
    var coreLoactionManager = CLLocationManager()
    var locationManager: LocationManager!
    var matchingItems:[MKMapItem] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    var locationName: String = ""
    var locationCoordinates: CLLocationCoordinate2D? = nil
   
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsCompass = true
        mapView.contentMode = .scaleToFill
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up mapview and viewcontroller
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSearch))
       // searchController.searchBar.delegate = self
        
        view.backgroundColor = .white
        setupMapView()
        
       
        //loading up location info
        locationManager = LocationManager.sharedInstance
        coreLoactionManager.delegate = self
        let authorizationCode = CLLocationManager.authorizationStatus()
        //print(authorizationCode)
        if authorizationCode == CLAuthorizationStatus.notDetermined && (coreLoactionManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) || coreLoactionManager.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization))) {
            
            if Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysAndWhenInUseUsageDescription") != nil {
                coreLoactionManager.requestAlwaysAuthorization()
            } else {
                print("no description provided")
            }
        }
        else {
            print("getting location")
            getLocation()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if locationCoordinates != nil {
        setupMap()
        }
    }
    
    
    func searchControllerFindName(Name: String) {
        self.locationName = Name
        print(Name)
        
    }
    
    func searchControllerFindLocation(Location: CLLocationCoordinate2D) {
        self.locationCoordinates = Location
        print(Location)
    }
    
    
    
    func getLocation() {
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            self.displayLocation(CLLocation(latitude: latitude, longitude: longitude))
        }
    }
    
    func displayLocation(_ location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
        
        //let locationPinCoord = CLLocationCoordinate2DMake(latitude, longitude)
        
        mapView.showsUserLocation = true
        
        //        let annotation = MKPointAnnotation()
        //        annotation.coordinate = CLLocationCoordinate2DMake(37.7850, -122.4023)
        //
        //        mapView.addAnnotation(annotation)
        //        mapView.showAnnotations([annotation], animated: true)
        
        locationManager.reverseGeocodeLocationWithCoordinates(location) { (reverseGeocodeInfo, placemark, error) in
            //let address = reverseGeocodeInfo?.object(forKey: "formattedAddress") as! String
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.notDetermined || status != CLAuthorizationStatus.denied || status != CLAuthorizationStatus.restricted {
            getLocation()
        }
    }
    
    
    fileprivate func setupMapView() {
        
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 0
        let mapWidth:CGFloat = view.frame.size.width
        let mapHeight:CGFloat = view.frame.size.height
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.center = view.center
        
        
        view.addSubview(mapView)
    }
    
    @objc func handleSearch() {
        let locationSearchVC = LocationSearchController()
        locationSearchVC.delegate = self
        navigationController?.pushViewController(locationSearchVC, animated: true)
    }
    
    func setupMap() {
        //only lets user focus on the search
        
        let annotations = self.mapView.annotations
        self.mapView.removeAnnotations(annotations)
        
        //getting data
        guard let latitude = locationCoordinates?.latitude else { return }
        guard let longitude = locationCoordinates?.longitude else { return }
        
        let annotation = MKPointAnnotation()
        annotation.title = locationName
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        self.mapView.addAnnotation(annotation)
        
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpanMake(0.006, 0.006)
        
        let region = MKCoordinateRegionMake(coordinate, span)
        self.mapView.setRegion(region, animated: true)
    
}
}




