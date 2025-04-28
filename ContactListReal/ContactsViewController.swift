//
//  ContactsViewController.swift
//  ContactListReal
//
//  Created by user272224 on 4/15/25.
//

import UIKit
import CoreData
class ContactsViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var currentContact: Contact? = nil
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var btnChangeDate: UIButton!
    @IBOutlet weak var lblBirthdate: UILabel!
    @IBOutlet weak var txtHomePhone: UITextField!
    @IBOutlet weak var txtCellPhone: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtContactName: UITextField!
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    
    @IBOutlet weak var imgContactPicture: UIImageView!
    @IBAction func changePicture(_ sender: Any) {
        print("take picture button clicked")
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraController = UIImagePickerController()
            cameraController.sourceType = .camera
            cameraController.cameraCaptureMode = .photo
            cameraController.delegate = self
            cameraController.allowsEditing = true
            self.present(cameraController, animated: true, completion: nil)
        } // method to a ccess defualt image library to test / see if image saving works succcesfully
        //else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //let libraryController = UIImagePickerController()
            //libraryController.sourceType = .photoLibrary
            //libraryController.delegate = self
            //libraryController.allowsEditing = true
            //self.present(libraryController, animated: true, completion: nil)
        //}
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                                didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.editedImage] as? UIImage {
            imgContactPicture.contentMode = .scaleAspectFit
            imgContactPicture.image = image

            if currentContact == nil {
                let context = appDelegate.persistentContainer.viewContext
                currentContact = Contact(context: context)
            }
            currentContact?.image = image.jpegData(compressionQuality: 1.0)
        }
        dismiss(animated: true, completion: nil)
    }

    func dateChanged(date: Date) {
        if currentContact == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
        }
        currentContact?.birthday = date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        lblBirthdate.text = formatter.string(from: date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if(segue.identifier == "segueContactDate" ){
                let dateController = segue.destination as! BirthdayViewController
                dateController.delegate = self
            }
        }

   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentContact != nil {
            txtContactName.text  = currentContact?.contactName
                    txtAddress.text      = currentContact!.streetAddress
                    txtCity.text         = currentContact!.city
                    txtState.text        = currentContact!.state
                    txtZip.text          = currentContact!.zipCode
                    txtEmail.text        = currentContact!.email
                    txtCellPhone.text    = currentContact!.cellPhone
                    txtHomePhone.text    = currentContact!.homePhone
            
            if let imageData  = currentContact?.image {
                imgContactPicture.image = UIImage(data:imageData)
            }
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            if currentContact!.birthday != nil {
                lblBirthdate.text = formatter.string(from:currentContact!.birthday as! Date)
                self.navigationItem.leftBarButtonItem = self.editButtonItem
            }
        }
        
        self.changeEditMode(self)
        let textFields: [UITextField] = [txtContactName, txtAddress, txtCity, txtState, txtZip, txtCellPhone, txtHomePhone, txtEmail]
        
        for textField in textFields {
            textField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        }
    }
    
    @objc func saveContact() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
        print(" Saved contact!")

    }

    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if currentContact == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
        }
        currentContact?.contactName    = txtContactName.text
        currentContact?.streetAddress = txtAddress.text
        currentContact?.city          = txtCity.text
        currentContact?.state         = txtState.text
        currentContact?.zipCode       = txtZip.text
        currentContact?.email         = txtEmail.text
        currentContact?.cellPhone     = txtCellPhone.text
        currentContact?.homePhone     = txtHomePhone.text
    }

                                     

    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtContactName, txtAddress, txtCity, txtState, txtZip, txtCellPhone, txtHomePhone, txtEmail]

        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = .none
            }
            btnChangeDate.isHidden = true
            navigationItem.rightBarButtonItem = nil
        } else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = .roundedRect
            }
            btnChangeDate.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .save,
                target: self,
                action: #selector(self.saveContact)
            )
        }
    }

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        self.registerKeyboardNotifications()
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.unregisterKeyboardNotifications()
        }
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(ContactsViewController.keyboardDidShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(self,
            selector: #selector(ContactsViewController.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }

    

        func unregisterKeyboardNotifications () {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue
        let keyboardSize = keyboardInfo?.cgRectValue.size ?? .zero

        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardSize.height

        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }

    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
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
