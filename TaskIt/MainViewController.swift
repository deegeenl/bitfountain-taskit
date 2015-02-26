//
//  ViewController.swift
//  TaskIt
//
//  Created by Dirk Groten on 12/01/15.
//  Copyright (c) 2015 Kridnet Software. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, TaskSettingDelegate {

    @IBOutlet var tableView: UITableView!
    private var fetchedResultsController = NSFetchedResultsController()
    private let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    
    private enum SegueIndentifier: String
    {
        case SegueToDetailView = "showTaskDetail"
        case SegueToAddTask = "addTask"
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupFetchRequestController()
        fetchedResultsController.delegate = self
        fetchedResultsController.performFetch(nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let id = segue.identifier {
            if let segueIdentifier = SegueIndentifier(rawValue: id)
            {
                switch segueIdentifier {
                    case .SegueToDetailView:
                        let detailViewController = segue.destinationViewController as TaskDetailViewController
                        let indexPath = self.tableView.indexPathForSelectedRow()
                        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as TaskModel
                        detailViewController.detailTaskModel = thisTask
                        detailViewController.delegate = self
                    case .SegueToAddTask:
                        let addTaskViewController = segue.destinationViewController as AddTaskViewController
                        addTaskViewController.delegate = self
                    default: break
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource protocol methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To Do" : "Done"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if fetchedResultsController.sections![indexPath.section].numberOfObjects > 0
        {
            var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("taskCell") as TaskCell
            let task = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
            cell.taskLabel.text = task.task
            cell.dateLabel.text = Date.toString(date: task.date)
            cell.descriptionLabel.text = task.subtask
            return cell
        }
        else
        {
            var cell: EmptyTaskCell = tableView.dequeueReusableCellWithIdentifier("emptyCell") as EmptyTaskCell
            return cell
        }
    }
    
    // MARK: UITableViewDelegate protocol methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        println("selected \(indexPath.row)")
        performSegueWithIdentifier("showTaskDetail", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if fetchedResultsController.fetchedObjects?.count == 0
        {
            return
        }
        
        let swipedTask = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        swipedTask.completed = !swipedTask.completed.boolValue
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
    // MARK: - TaskSettingDelegate protocol methods
    
    func didSaveTaskWithTitle(title: String, subTaskTitle: String, dueDate: NSDate, completed isCompleted: Bool)
    {
        var task: TaskModel
        
        if let indexPath = tableView.indexPathForSelectedRow()
        {
            task = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
        }
        else
        {
            let entityDescription = NSEntityDescription.entityForName("TaskModel", inManagedObjectContext: managedObjectContext)
            task = TaskModel(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        }
        
        task.task = title
        task.subtask = subTaskTitle
        task.date = dueDate
        task.completed = isCompleted

        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
    // MARK: NSFetchResultsController Delegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    // MARK: Helper functions
    
    private func setupFetchRequestController()
    {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completionSortDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        fetchRequest.sortDescriptors = [completionSortDescriptor, dateSortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
    }

}

