//
//  LocationDemoViewController.swift
//  ContactListReal
//
//  Created by user272224 on 4/22/25.
//

import UIKit
import CoreLocation

class LocationDemoViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var lblAltitudeAccuracy: UILabel!
    @IBOutlet weak var lblAltitude: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblHeadingAccuracy: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblLocationAccuracy: UILabel!
    lazy var geoCoder = CLGeocoder()
    var locationManager: CLLocationManager!

    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy > 0 {
            let theHeading = newHeading.trueHeading
            var direction: String
            switch theHeading {
            case 225..<315:
                direction = "W"
            case 135..<225:
                direction = "S"
            case 45..<135:
                direction = "E"
            default:
                direction = "N"
            }
            lblHeading.text = String(format: "%g° (%@)", theHeading, direction)
            lblHeadingAccuracy.text = String(format: "%g°", newHeading.headingAccuracy)
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.last {
            let eventDate = location.timestamp
            let howRecent = eventDate.timeIntervalSinceNow
            if Double(howRecent) < 15.0 {
                let coordinate = location.coordinate
                lblLatitude.text = String(format: "%g\u{00B0}", coordinate.latitude)
                lblLongitude.text = String(format: "%g\u{00B0}", coordinate.longitude)
                lblLocationAccuracy.text = String(format: "%g\u{00B0}", location.horizontalAccuracy)
                lblAltitude.text = String(format: "%g\u{00B0}", location.altitude)
                lblAltitudeAccuracy.text = String(format: "%g\u{00B0}", location.verticalAccuracy)
            }
        }
    }
    
    
    @IBAction func deviceCoordinates(_ sender: Any) {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    
    }
    @IBAction func addressToCoordinates(_ sender: Any) {
        let address = "\(txtStreet.text!), \(txtCity.text!), \(txtState.text!)"
        geoCoder.geocodeAddressString(address) {
            (placemarks, error) in
            self.processAddressResponse(withPlacemarks: placemarks, error: error)
        }    }
    
    private func processAddressResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Geocode error: \(error)")
        } else {
            var bestMatch: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                bestMatch = placemarks.first?.location
            }
            if let coordinate = bestMatch?.coordinate {
                lblLatitude.text = String(format: "%g", coordinate.latitude)
                lblLongitude.text = String(format: "%g", coordinate.longitude)
            } else {
                print("Didn't find any matching locations")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == .authorizedWhenInUse{
            print("Permission granted")
        }
        else {
            print("Permission NOT granted")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
