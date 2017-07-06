//
//  ThirdViewController.swift
//  ToDoList
//
//  Created by Robert on 7/6/17.
//  Copyright © 2017 Lent Coding. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    @IBOutlet weak var editTask: UITextView!
    
    @IBAction func pressedCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTask.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if editTask.text != "" {
            list.append(editTask.text!)
        }
    }
    
}

