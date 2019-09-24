//
//  DocumentsViewController.swift
//  Documents
//
//  Created by Cassidy Pelchat on 9/19/19.
//  Copyright © 2019 Cassidy Pelchat. All rights reserved.
//

import UIKit
import CoreData

class DocumentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var documentTableView: UITableView!
    let dateFormatted = DateFormatter()
    var documents = [Documents]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Documents"
        
        dateFormatted.dateStyle = .medium
        dateFormatted.timeStyle = .medium
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchDocuments()
        documentTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        if let tableCell = tableCell as? DocumentsTableViewCell {
            let document = documents[indexPath.row]
            tableCell.sizeLabel.text = String(document.size) + "bytes"
            tableCell.titleLabel.text = document.name
            
            if let modifiedDate = document.modifiedDate {
                tableCell.modifiedLabel.text = dateFormatted.string(from: modifiedDate)
            } else {
                tableCell.modifiedLabel.text = "unknown"
            }
        }
        return tableCell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) -> Int{
        return documents.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func errorMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            (alertAction) -> Void in
            print("OK selected")
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchDocuments() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Documents> = Documents.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            documents = try managedContext.fetch(fetchRequest)
        } catch {
            errorMessage(message: "Error! n/Fetch could not be performed.")
            return
        }
    }
    
    func deleteDocument(at indexPath: IndexPath) {
        let document = documents[indexPath.row]
        
        if let managedObjectContext = document.managedObjectContext {
            managedObjectContext.delete(document)
            
            do {
                try managedObjectContext.save()
                self.documents.remove(at: indexPath.row)
                documentTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                errorMessage(message: "Delete failed.")
                documentTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentContentViewController,
            let segueIdentifier = segue.identifier, segueIdentifier == "existingDocument",
            let row = documentTableView.indexPathForSelectedRow?.row {
            destination.document = documents[row]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            self.deleteDocument(at: indexPath)  // self is required because inside of closure
        }
        
        return [delete]
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
