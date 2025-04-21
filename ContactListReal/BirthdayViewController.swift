//
//  BirthdayViewController.swift
//  ContactListReal
//
//  Created by user272224 on 4/16/25.
//

import UIKit

protocol DateControllerDelegate: AnyObject {
    func dateChanged(date: Date)
}

class BirthdayViewController: UIViewController {

    @IBOutlet weak var dtpDate: UIDatePicker!
    weak var delegate: DateControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDate))
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Pick a birthdate"
    }

    @objc func saveDate() {
        delegate?.dateChanged(date: dtpDate.date)
        navigationController?.popViewController(animated: true)
    }
}
