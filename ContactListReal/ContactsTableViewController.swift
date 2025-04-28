//
//  ContactsTableViewController.swift
//  ContactListReal
//
//  Created by user272224 on 4/16/25.
//
import UIKit
import CoreData
class ContactsTableViewController: UITableViewController {
    var contacts: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contacts[indexPath.row] as? Contact
        let name = selectedContact!.contactName!
        
        let actionHandler = { (action: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "EditContact", sender: tableView.cellForRow(at: indexPath))
        }
        
        let alertController = UIAlertController(
            title: "Contact selected",
            message: "Selected row \(indexPath.row) (\(name))",
            preferredStyle: .alert
        )
        
        let actionCancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        
        let actionDetails = UIAlertAction(
            title: "Show Details",
            style: .default,
            handler: actionHandler
        )
        
        alertController.addAction(actionCancel)
        alertController.addAction(actionDetails)
        
        present(alertController, animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditContact" {
            let contactController = segue.destination as? ContactsViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedContact = contacts[selectedRow!] as? Contact
            contactController?.currentContact = selectedContact!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadDataFromDatabase() {
        let settings = UserDefaults.standard
        let sortField = settings.string(forKey: Constants.kSortField)
        let sortAscending = settings.bool(forKey: Constants.kSortDirectionAscending)
        
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject> (entityName: "Contact")
        
        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: sortAscending)
        let sortDescriptorArray = [sortDescriptor]
        request.sortDescriptors = sortDescriptorArray
        
        do {
            contacts = try context.fetch(request )
            
        }catch let error as NSError {
            print("could not fetch. \(error),\(error.userInfo)")
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsCell", for: indexPath)
        let contact = contacts[indexPath.row] as? Contact
        cell.textLabel?.text = contact?.contactName
        cell.detailTextLabel?.text = contact?.city
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = contacts[indexPath.row] as? Contact
            let context = appDelegate.persistentContainer.viewContext
            context.delete(contact!)

            do {
                try context.save()
            } catch {
                fatalError("Error deleting contact: \(error)")
            }

            loadDataFromDatabase()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // nothing here
        }
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
    

