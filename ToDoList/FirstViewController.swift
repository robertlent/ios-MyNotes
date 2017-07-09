/*
//  FirstViewController.swift
//  ToDoList
//
//  Created by Robert on 7/6/17.
//  Copyright © 2017 Lent Coding. All rights reserved.
*/

import UIKit
import Social

let defaults = UserDefaults.standard
var list = defaults.stringArray(forKey: "ToDoListItems") ?? [String]()

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var taskList: UITableView!
    @IBOutlet weak var arrangeListButton: UIBarButtonItem!
    @IBOutlet weak var newTaskButton: UIBarButtonItem!
    var taskText = ""
    
    func pressedShare() {
        let shareAlert = UIAlertController(title: "Share", message: "Share your task!", preferredStyle: .actionSheet)
        
        let shareFacebook = UIAlertAction(title: "Share on Facebook", style: .default, handler: {(shareAlert: UIAlertAction!) in
            let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
                
            post.setInitialText("\(self.taskText) - Shared from Lent Coding's To-Do-List iOS app. https://github.com/robertmlent/ios-ToDoList")
            post.add(UIImage(named: "iPad-ProApp-83.5@2x.png"))
                
            self.present(post, animated: true, completion: nil)
        })
        
        let shareTwitter = UIAlertAction(title: "Share on Twitter", style: .default, handler: {(shareAlert: UIAlertAction!) in
            let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                
            post.setInitialText("\(self.taskText) - Shared from Lent Coding's To-Do-List iOS app. https://github.com/robertmlent/ios-ToDoList")
            post.add(UIImage(named: "iPad-ProApp-83.5@2x.png"))
                
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
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "task")
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
        performSegue(withIdentifier: "editItem", sender: self)
    }

    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.taskList)
            if let indexPath = taskList.indexPathForRow(at: touchPoint) {
                taskText = String(list[indexPath.row])
                pressedShare()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            list.remove(at: indexPath.row)
            defaults.set(list, forKey: "ToDoListItems")
            taskList.reloadData()
        }
    }
    
    @IBAction func pressedArrange(_ sender: Any) {
        taskList.isEditing = !taskList.isEditing
        
        switch taskList.isEditing {
        case true:
            arrangeListButton.title = "Done"
            newTaskButton.isEnabled = false
        default:
            arrangeListButton.title = "Arrange"
            newTaskButton.isEnabled = true
            defaults.set(list, forKey: "ToDoListItems")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(FirstViewController.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskList.reloadData()
        defaults.set(list, forKey: "ToDoListItems")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editItem" {
            if let destination = segue.destination as? ThirdViewController {
                let selectedItem = taskList.indexPathForSelectedRow!.row
                let arrayIndex = selectedItem
                destination.selectedItem = list[selectedItem]
                destination.arrayIndex = arrayIndex
            }
        }
    }
    
    @IBAction func unwindToFirstViewController(segue: UIStoryboardSegue){
    }
}

