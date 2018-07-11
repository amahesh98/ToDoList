//
//  ViewController.swift
//  ToDoList
//
//  Created by Ashwin Mahesh on 7/11/18.
//  Copyright © 2018 AshwinMahesh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    @IBAction func addPushed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddSegue", sender: sender)
    }
    @IBOutlet weak var checkmarkLabel: UILabel!
    var tableData:[Task] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    @IBOutlet var myTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()
        tableView.rowHeight=115
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchAll(){
        let request:NSFetchRequest<Task> = Task.fetchRequest()
        do{
            tableData = try context.fetch(request)
//            tableView.reloadData()
        }
        catch{
            print("Error")
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! CustomCell
        let currentTask:Task = tableData[indexPath.row]
        cell.titleLabel.text = currentTask.title
        cell.descriptionLabel.text = currentTask.notes
        if currentTask.completed==true{
            //show the checkmark
//            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            cell.checkmarkLabel.text = "\u{2713}"
        }
        else{
//            cell.accessoryType = .none
            cell.checkmarkLabel.text = ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a 'on' MM/dd/YY"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        cell.dateLabel.text = formatter.string(from:currentTask.date!)
        return cell
    }
    @IBAction func unwindToMainVC(segue:UIStoryboardSegue){
        let source = segue.source as! AddVCViewController
        let newTask = Task(context: context)
        newTask.title = source.titleField.text
        newTask.notes = source.descriptionField.text
        newTask.date = source.datePicker.date
        appDelegate.saveContext()
        print("Task successfully added")
        tableData.append(newTask)
        tableView.reloadData()
//        fetchAll()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableData[indexPath.row].completed==false{
            tableData[indexPath.row].completed = true
        }
        else{
            tableData[indexPath.row].completed = false
        }
        
        appDelegate.saveContext()
        tableView.reloadData()
//        fetchAll()
    }
}

