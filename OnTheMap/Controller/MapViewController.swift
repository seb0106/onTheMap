//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
import UIKit
import MapKit


class MapViewController: UIViewController,  MKMapViewDelegate {
    
    @IBOutlet weak var MapView: MKMapView!
    
    var studentLocation: StudentLocation?
    override func viewDidLoad() {
        MapView.delegate = self
        var locations: StudentLocation?
        _ = UdacityClient.getStudentsLocation() {
            location, error in

            if (error != nil){
                let alert = UIAlertController(title: "Error Message", message: "Failed to load locations from student.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
         //   print(location)
            locations = location
            var annotations = [MKPointAnnotation]()
            if let location = locations{
                for dictionary in location.results {
                   
                    let lat = CLLocationDegrees(dictionary.latitude )
                    let long = CLLocationDegrees(dictionary.longitude )
                    
                  let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = dictionary.firstName
                    let last = dictionary.lastName
                    let mediaURL = dictionary.mediaURL
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append(annotation)
                }}
            
            self.MapView.addAnnotations(annotations)
        }
    }
    
    func handleStudentLocation(success: StudentLocation,error: Error?){
        if success.results.isEmpty {
            studentLocation? = success
        } else {
            print(error ?? "")
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                let urlOptional = URL(string: toOpen )
                if let url = urlOptional{
                    UIApplication.shared.open(url)
                }
            }
        }
    }
  
    @IBAction func reloadView(_ sender: Any) {
        self.loadView()
    }
}
