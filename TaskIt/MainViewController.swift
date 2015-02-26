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

                    // show TaskDetailViewController
                    case .SegueToDetailView:
                        let detailViewController = segue.destinationViewController as TaskDetailViewController
                        let indexPath = self.tableView.indexPathForSelectedRow()
                        let thisTask = fetchedResultsController.objectAtIndexPath(indexPath!) as TaskModel
                        detailViewController.detailTaskModel = thisTask
                        detailViewController.delegate = self

                    // show AddTaskViewController
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
        // if there are no tasks, return 1 to display an empty cell
        return fetchedResultsController.sections!.count == 0 ? 1 : fetchedResultsController.sections!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if fetchedResultsController.sections?.count == 1 // only one type of tasks
        {
            let task = fetchedResultsController.fetchedObjects![0] as TaskModel
            return task.completed ? "Done" : "To Do"
        }
        
        return section == 0 ? "To Do" : "Done"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return fetchedResultsController.sections?.count > 0 ? fetchedResultsController.sections![section].numberOfObjects : 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if fetchedResultsController.sections?.count > 0 // there are tasks in store
        {
            if fetchedResultsController.sections![indexPath.section].numberOfObjects > 0 // there are tasks in the section
            {
                var cell: TaskCell = tableView.dequeueReusableCellWithIdentifier("taskCell") as TaskCell
                let task = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
                cell.taskLabel.text = task.task
                cell.dateLabel.text = Date.toString(date: task.date)
                cell.descriptionLabel.text = task.subtask
                return cell
            }
        }
        
        // there are no tasks in store
        var cell: EmptyTaskCell = tableView.dequeueReusableCellWithIdentifier("emptyCell") as EmptyTaskCell
        return cell
    }
    
    // MARK: UITableViewDelegate protocol methods
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        // only perform segue if there are tasks, otherwise we're selecting an empty cell
        if fetchedResultsController.fetchedObjects?.count > 0
        {
            performSegueWithIdentifier("showTaskDetail", sender: self)
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if fetchedResultsController.fetchedObjects?.count == 0
        {
            return
        }
        
        managedObjectContext.deleteObject(fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel)
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
    }
    
    // MARK: - TaskSettingDelegate protocol methods
    
    func didSaveTaskWithTitle(title: String, subTaskTitle: String, dueDate: NSDate, completed isCompleted: Bool)
    {
        var task: TaskModel
        
        if let indexPath = tableView.indexPathForSelectedRow()
        {
            task = fetchedResultsController.objectAtIndexPath(indexPath) as TaskModel
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
    
    // Boiler plate to setup the fetchedResultsContoller, called in viewDidLoad()
    private func setupFetchRequestController()
    {
        let fetchRequest = NSFetchRequest(entityName: "TaskModel")
        let dateSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let completionSortDescriptor = NSSortDescriptor(key: "completed", ascending: true)
        fetchRequest.sortDescriptors = [completionSortDescriptor, dateSortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "completed", cacheName: nil)
    }

}

