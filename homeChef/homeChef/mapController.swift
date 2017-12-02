//
//  mapController.swift
//  homeChef
//
//  Created by amit kumar on 10/21/17.
//  Copyright © 2017 amit kumar. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON

class mapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate  {

    @IBOutlet weak var mapView: MKMapView!
    var selectedPin: MKPlacemark?
    
    var resultSearchController: UISearchController!
    
    
    var locationManager = CLLocationManager()
    
    // MARK: - Search
    
    fileprivate var searchController: UISearchController!
    fileprivate var localSearchRequest: MKLocalSearchRequest!
    fileprivate var localSearch: MKLocalSearch!
    fileprivate var localSearchResponse: MKLocalSearchResponse!
    
    // MARK: - Map variables
    
    fileprivate var annotation: MKAnnotation!
    fileprivate var isCurrentLocation: Bool = false
    
    // MARK: - Activity Indicator
    
    fileprivate var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - UIViewController's methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(mapController.searchButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = searchButton
        
        mapView.delegate = self
        mapView.mapType = .standard
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        self.view.addSubview(activityIndicator)
        if (CLLocationManager.locationServicesEnabled()) {
            if locationManager == nil {
                locationManager = CLLocationManager()
            }
            locationManager.requestAlwaysAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            isCurrentLocation = true
        }
        test()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.center = self.view.center
    }
    
    // MARK: - Search
    
    func searchButtonAction(_ button: UIBarButtonItem) {
        if searchController == nil {
            searchController = UISearchController(searchResultsController: nil)
        }
        searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    // MARK: - UISearchBarDelegate
    
    func test() {
        
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = "Restaurant"
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { [weak self] (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil {
                let alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
            
            struct Location {
                let title: String
                let latitude: Double
                let longitude: Double
            }

    
            let locations = [
                Location(title: "Dinesh' Dhaba",    latitude: 37.33893, longitude: -122.028483),
                Location(title: "Sam's Noodle",     latitude: 37.4024645, longitude: -121.9791814),
                Location(title: "Qualty home food",     latitude: 37.392828, longitude: -121.988716),
                Location(title: "Tandoori Kitchen",     latitude: 37.3942821, longitude: -87.632398),
                Location(title: "Trans Phoe", latitude: 37.359109, longitude: -122.032806),
                Location(title: "Amit's Vada pav corner", latitude: 37.402403, longitude: -122.009925)
            ]
            

            for item in (locations) {
                
               
                
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = item.title
                
//                pointAnnotation.coordinate = CLLocationCoordinate2DMake(item.placemark.coordinate.latitude, item.placemark.coordinate.longitude)
                
                pointAnnotation.coordinate = CLLocationCoordinate2DMake(item.latitude, item.longitude)
                
                let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
                self!.mapView.centerCoordinate = pointAnnotation.coordinate
                self!.mapView.addAnnotation(pinAnnotationView.annotation!)
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !isCurrentLocation {
            return
        }
        
        isCurrentLocation = false
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        
        if self.mapView.annotations.count != 0 {
            annotation = self.mapView.annotations[0]
            self.mapView.removeAnnotation(annotation)
        }
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = location!.coordinate
        pointAnnotation.title = ""
        mapView.addAnnotation(pointAnnotation)
    }
    
    func driving() {
        
        let request = MKDirectionsRequest()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.add(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "Identifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "annotationPin")
        }
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation selected")
        
        let annotation = view.annotation?.coordinate
        print(annotation?.latitude)
        print(view.annotation)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chefVC") as! HistoryViewController
        self.present(vc, animated: true, completion: nil)
}
}
