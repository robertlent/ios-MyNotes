/*
  FirstViewController.swift
  MyNotes

  Created by Robert on 7/6/17.
  Copyright © 2017 Lent Coding. All rights reserved.
*/

import UIKit
import Social

let defaults = UserDefaults.standard
var list = defaults.stringArray(forKey: "Notes") ?? [String]()

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var noteList: UITableView!
    @IBOutlet weak var arrangeListButton: UIBarButtonItem!
    @IBOutlet weak var newNoteButton: UIBarButtonItem!
    var noteText = ""
    
    func pressedShare() {
        let shareAlert = UIAlertController(title: "Share", message: "Share your note!", preferredStyle: .actionSheet)
        
        let shareFacebook = UIAlertAction(title: "Share on Facebook", style: .default, handler: {(shareAlert: UIAlertAction!) in
            let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
            
            post.setInitialText("\(self.noteText) - Shared from Lent Coding's My Notes iOS app")
            post.add(URL(string: "https://github.com/robertmlent/ios-MyNotes"))
            post.add(UIImage(named: "iPad-ProApp-83.5@2x.png"))
            
            self.present(post, animated: true, completion: nil)
        })
        
        let shareTwitter = UIAlertAction(title: "Share on Twitter", style: .default, handler: {(shareAlert: UIAlertAction!) in
            let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
            var twitterText = ""
            
            // If text is longer than 70 chars, truncate to 69 and add special char …, else share whole text
            if self.noteText.characters.count > 70 {
                twitterText = "\(self.noteText.substring(to: self.noteText.index(self.noteText.startIndex, offsetBy: 69)))…"
                
                post.setInitialText("\(twitterText) - Shared from Lent Coding's My Notes iOS app")
                post.add(URL(string: "https://github.com/robertmlent/ios-MyNotes"))
            } else {
                post.setInitialText("\(self.noteText) - Shared from Lent Coding's My Notes iOS app")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "note")
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = list[sourceIndexPath.row]
        list.remove(at: sourceIndexPath.row)
        list.insert(item, at: destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewItem", sender: self)
    }

    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.noteList)
            if let indexPath = noteList.indexPathForRow(at: touchPoint) {
                noteText = String(list[indexPath.row])
                pressedShare()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            list.remove(at: indexPath.row)
            defaults.set(list, forKey: "Notes")
            noteList.reloadData()
            arrangeButtonStatus()
        }
    }
    
    @IBAction func pressedArrange(_ sender: Any) {
        noteList.isEditing = !noteList.isEditing
        
        switch noteList.isEditing {
        case true:
            arrangeListButton.title = "Done"
            newNoteButton.isEnabled = false
        default:
            arrangeListButton.title = "Arrange"
            newNoteButton.isEnabled = true
            defaults.set(list, forKey: "Notes")
            arrangeButtonStatus()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrangeButtonStatus()
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(FirstViewController.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arrangeButtonStatus()
        noteList.reloadData()
        defaults.set(list, forKey: "Notes")
    }
    
    func arrangeButtonStatus() {
        if list.count <= 1 {
            arrangeListButton.isEnabled = false
        } else {
            arrangeListButton.isEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewItem" {
            if let destination = segue.destination as? ThirdViewController {
                let selectedItem = noteList.indexPathForSelectedRow!.row
                let arrayIndex = selectedItem
                destination.selectedItem = list[selectedItem]
                destination.arrayIndex = arrayIndex
            }
        }
    }
    
    @IBAction func unwindToFirstViewController(segue: UIStoryboardSegue){
    }
}

