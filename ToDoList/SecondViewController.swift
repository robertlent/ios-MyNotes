/*
//  SecondViewController.swift
//  ToDoList
//
//  Created by Robert on 7/6/17.
//  Copyright © 2017 Lent Coding. All rights reserved.
*/

import UIKit

class SecondViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var input: UITextView!

    @IBAction func pressedCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Type your Task here. I suggest for longer Tasks that you write a short subject on the first line, followed by an empty line, and then the body of your Task.")
        {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if input.text != "" && input.text != "Type your Task here. I suggest for longer Tasks that you write a short subject on the first line, followed by an empty line, and then the body of your Task." {
            list.append(input.text!)
        }
        
        defaults.set(list, forKey: "ToDoListItems")
    }
    
}

