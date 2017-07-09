/*
//  FirstViewController.swift
//  ToDoList
//
//  Created by Robert on 7/6/17.
//  Copyright © 2017 Lent Coding. All rights reserved.
*/

import UIKit

let defaults = UserDefaults.standard
var list = defaults.stringArray(forKey: "ToDoListItems") ?? [String]()

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var taskList: UITableView!
    @IBOutlet weak var arrangeListButton: UIBarButtonItem!
    @IBOutlet weak var newTaskButton: UIBarButtonItem!
    
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

