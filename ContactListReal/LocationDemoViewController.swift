//
//  LocationDemoViewController.swift
//  ContactListReal
//
//  Created by user272224 on 4/22/25.
//

import UIKit
import CoreLocation

class LocationDemoViewController: UIViewController {

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
    
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    
    @IBAction func deviceCoordinates(_ sender: Any) {
    
    }
    @IBAction func addressToCoordinates(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
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
