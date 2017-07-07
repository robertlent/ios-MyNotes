//
//  FirstViewController.swift
//  ToDoList
//
//  Created by Robert on 7/6/17.
//  Copyright © 2017 Lent Coding. All rights reserved.
//

import UIKit

let defaults = UserDefaults.standard
var list = defaults.stringArray(forKey: "ToDoListItems") ?? [String]()

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var taskList: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "task")
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }

    //Editing tasks is not working, so disabled segue until Edit is implemented
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "editItem", sender: self)
//    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            list.remove(at: indexPath.row)
            defaults.set(list, forKey: "ToDoListItems")
            taskList.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        taskList.reloadData()
    }
    
    //Editing tasks is not working
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "editItem" {
//            if let destination = segue.destination as? ThirdViewController {
//                let selectedItem = taskList.indexPathForSelectedRow?.row
//                destination.editTask.text = list[selectedItem!]
//            }
//        }
//    }
    
    @IBAction func unwindToFirstViewController(segue: UIStoryboardSegue){
    }
}

