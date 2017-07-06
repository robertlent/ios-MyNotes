//
//  SecondViewController.swift
//  ToDoList
//
//  Created by Robert on 7/6/17.
//  Copyright © 2017 Lent Coding. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var input: UITextView!

    @IBAction func pressedCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        input.becomeFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if input.text != "" {
            list.append(input.text!)
        }
        
        defaults.set(list, forKey: "ToDoListItems")
    }
    
}

