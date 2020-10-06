//*
// * Copyright (C) Schweizerische Bundesbahnen SBB, 2020.
//*

import Foundation
import UIKit
import MapKit
class MapLocationViewController: UIViewController {
    @IBOutlet weak var MapView: MKMapView!
    
    var mediaLink: String?
    var geocode: String?
    var lat: Double = 0.0
    var long: Double = 0.0
    
    override func viewDidLoad() {
        coordinates(forAddress: geocode ?? ""){
            (location) in
            guard let location = location else {
                    print("error")
                let alert = UIAlertController(title: "Error Message", message: "Failed to load locations from geocode. Go back and try another location.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
                   return
               }
            self.lat = location.latitude
            self.long = location.longitude
            self.openMapOnLocation(lat: location.latitude, long: location.longitude)
            self.setPinUsingMKAnnotation(location: location)
        }
    }
    func setPinUsingMKAnnotation(location: CLLocationCoordinate2D) {
        let pin1 = MapPin(title: geocode ?? "", coordinate: location)
       let coordinateRegion = MKCoordinateRegion(center: pin1.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
       MapView.setRegion(coordinateRegion, animated: true)
       MapView.addAnnotations([pin1])
    }
    
    func openMapOnLocation(lat: Double, long: Double){
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long
        MapView.centerToLocation(CLLocation(latitude: latitude, longitude: longitude))
    }
    
    func coordinates(forAddress address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) {
            (placemarks, error) in
            guard error == nil else {
                print("Geocoding error: \(error!)")
                completion(nil)
                return
            }
            completion(placemarks?.first?.location?.coordinate)
        }
    }
    @IBAction func postLocation(_ sender: Any) {
        UdacityClient.postStudentLocation(studenLocationRequest: StudentLocationRequest(uniqueKey: "1234", firstName: "Sebi", lastName: "asdfsadf", mapString: geocode ?? "", mediaURL: mediaLink ?? "https://udacity.com", latitude: lat, longitude: long), completion: handlePostLocationResponse(success:error:))
    }
    func handlePostLocationResponse(success: Bool, error: Error?){
        if success{
            print(success)
            dismiss(animated: true)
        }else{
            let alert = UIAlertController(title: "Error Message", message: "Failed to upload location due to this error  \(error!).", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
}
class MapPin: NSObject, MKAnnotation {
   let title: String?
   let coordinate: CLLocationCoordinate2D
init(title: String, coordinate: CLLocationCoordinate2D) {
      self.title = title
      self.coordinate = coordinate
   }
}
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
