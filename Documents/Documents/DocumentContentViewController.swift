//
//  DocumentContentViewController.swift
//  Documents
//
//  Created by Cassidy Pelchat on 9/19/19.
//  Copyright © 2019 Cassidy Pelchat. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class DocumentContentViewController: UIViewController, UINavigationControllerDelegate {

    
    @IBOutlet weak var userInputName: UITextField!
    @IBOutlet weak var userInputContent: UITextView!

    var document: Documents?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        
        if let document = document {
            let name = document.name
            userInputName.text = name
            userInputContent.text = document.content
            title = name
        }
        
        // Do any additional setup after loading the view.
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func errorMessage(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func saveDocument(_ sender: Any) {
        guard let name = userInputName.text else{
            errorMessage(message: "Error!\nThe document could not be saved.")
            return
        }
        
        let documentName = name.trimmingCharacters(in: .whitespaces)
        if (documentName == "") {
            errorMessage(message: "Error!\nThe document needs a name.")
            return
        }
        let documentContent = userInputContent.text
        
        if document == nil {
            document = Documents(name: documentName, content: documentContent)
        }
        else{
            document?.update(name: documentName, content: documentContent)
        }
        if let document = document {
            do {
                let managedContext = document.managedObjectContext
                try managedContext?.save()
            }
            catch {
                errorMessage(message: "Error!\nThe document could not be saved.")
            }
        }
        else {
            errorMessage(message: "Error!\nThe document could not be created.")
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func changedName(_ sender: Any) {
        title = userInputName.text
    }
    
    
}
