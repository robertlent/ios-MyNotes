/*
  ThirdViewController.swift
  MyNotes

  Created by Robert on 7/6/17.
  Copyright © 2017 Lent Coding. All rights reserved.
*/

import UIKit
import Social

class ThirdViewController: UIViewController {
    @IBOutlet weak var viewNote: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    var selectedItem = ""
    var arrayIndex = 0
    
    @IBAction func pressedCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNote.text = selectedItem
    }
    
    @IBAction func pressedShare(_ sender: UIBarButtonItem) {
        let shareAlert = UIAlertController(title: "Share", message: "Share your note!", preferredStyle: .actionSheet)
        
        let shareFacebook = UIAlertAction(title: "Share on Facebook", style: .default, handler: {(shareAlert: UIAlertAction!) in
            let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
            
            post.setInitialText("\(self.viewNote) - Shared from Lent Coding's My Notes iOS app")
            post.add(URL(string: "https://github.com/robertmlent/ios-MyNotes"))
            post.add(UIImage(named: "iPad-ProApp-83.5@2x.png"))
            
            self.present(post, animated: true, completion: nil)
        })
        
        let shareTwitter = UIAlertAction(title: "Share on Twitter", style: .default, handler: {(shareAlert: UIAlertAction!) in
            let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
            var twitterText = ""
            
            // If text is longer than 70 chars, truncate to 69 and add special char …, else share whole text
            if self.viewNote.text.characters.count > 70 {
                twitterText = "\(self.viewNote.text.substring(to: self.viewNote.text.index(self.viewNote.text.startIndex, offsetBy: 69)))…"
                
                post.setInitialText("\(twitterText) - Shared from Lent Coding's My Notes iOS app")
                post.add(URL(string: "https://github.com/robertmlent/ios-MyNotes"))
            } else {
                post.setInitialText("\(self.viewNote.text!) - Shared from Lent Coding's My Notes iOS app")
                post.add(URL(string: "https://github.com/robertmlent/ios-MyNotes"))
            }
            
            self.present(post, animated: true, completion: nil)
        })
        
        let cancelShare = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        shareAlert.addAction(shareFacebook)
        shareAlert.addAction(shareTwitter)
        shareAlert.addAction(cancelShare)
        
        self.present(shareAlert, animated: true, completion: nil)
    }
    
    @IBAction func pressedEdit(_ sender: UIBarButtonItem) {
        if editButton.title == "Edit" {
            shareButton.isEnabled = false
            editButton.title = "Save"
            viewNote.isEditable = true
            viewNote.becomeFirstResponder()
        } else {
            shareButton.isEnabled = true
            editButton.title = "Edit"
            viewNote.isEditable = false
            viewNote.resignFirstResponder()
            
            if viewNote.text == "" {
                list.remove(at: arrayIndex)
            } else {
                list[arrayIndex] = viewNote.text
            }
            dismiss(animated: true, completion: nil)
        }
    }
}

