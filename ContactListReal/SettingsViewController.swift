//
//  SettingsViewController.swift
//  ContactListReal
//
//  Created by user272224 on 4/15/25.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var lblBattery: UILabel!
    @IBOutlet weak var swAscending: UISwitch!
    @IBOutlet weak var pckSortField: UIPickerView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let settings = UserDefaults.standard
        swAscending.setOn(settings.bool(forKey: Constants.kSortDirectionAscending), animated: true)
        
        if let sortField = settings.string(forKey: Constants.kSortField) {
            var i = 0
            for field in sortOrderItems {
                if field == sortField {
                    pckSortField.selectRow(i, inComponent: 0, animated: false)
                    break
                }
                i += 1
            }
        }

        pckSortField.reloadComponent(0)
    }

    override func viewDidAppear(_ animated: Bool) {
        let device = UIDevice.current
        print("Device info:")
        print("Name: \(device.name)")
        
        print("Model: \(device.model)")
        print("System Name: \(device.systemName)")
        print("Identifier: \(device.identifierForVendor!)")
        
        let orientation: String
        switch device.orientation {
        case .faceDown:
            orientation = "Face Down"
        case .landscapeLeft:
            orientation = "Landscape left"
        case . portrait:
            orientation = "Portrait"
        case .landscapeRight:
            orientation = "Landscape Right"
        case .faceUp:
            orientation = "Face Up"
        case .portraitUpsideDown:
            orientation = "Portrait Upside Down"
        case .unknown:
            orientation = "Unknown Orientation"
        @unknown default:
            fatalError()
        }
        print("Orientation: \(orientation)")
    }
    
    
    let sortOrderItems: Array<String> = ["contactName", "city", "birthday"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        pckSortField.dataSource = self;
        pckSortField.delegate = self;
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.batteryChanged),
                                               name: UIDevice.batteryStateDidChangeNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.batteryChanged),
                                               name: UIDevice.batteryLevelDidChangeNotification,
                                               object:nil)
        self.batteryChanged()
    }
    
    @objc func batteryChanged() {
        let device = UIDevice.current
        var batteryState: String
        switch(device.batteryState){
        case .charging:
            batteryState = "+"
        case .full:
            batteryState = "!"
        case .unplugged:
            batteryState = "-"
        case .unknown:
            batteryState = "?"
        @unknown default:
            batteryState = "?"
            
        }
        let batteryLevelPercent = device.batteryLevel * 100
        let batteryLevel = String(format: "%.0f%%", batteryLevelPercent)
        let batteryStatus = "\(batteryLevel) (\(batteryState))"
        lblBattery.text = batteryStatus
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func sortDirectionChanged(_ sender: Any) {
        let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: Constants.kSortDirectionAscending)
        settings.synchronize()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOrderItems[row]
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedField = sortOrderItems[row]
        print("chosen item: \(selectedField)")
        
        let settings = UserDefaults.standard
        settings.set(selectedField, forKey: Constants.kSortField)
        settings.synchronize()
    }
}
