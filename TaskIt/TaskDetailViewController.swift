//
//  TaskDetailViewController.swift
//  TaskIt
//
//  Created by Dirk Groten on 12/01/15.
//  Copyright (c) 2015 Kridnet Software. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subTaskTextField: UITextField!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var completed: UISwitch!
    
    var detailTaskModel: TaskModel!
    weak var delegate: TaskSettingDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        println("task is \(detailTaskModel.task)")
        taskTextField.text = detailTaskModel.task
        subTaskTextField.text = detailTaskModel.subtask
        taskDatePicker.date = detailTaskModel.date
        completed.on = detailTaskModel.completed.boolValue
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTapped()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func doneTapped(sender: UIBarButtonItem)
    {
        self.delegate?.didSaveTaskWithTitle?(taskTextField.text, subTaskTitle: subTaskTextField.text, dueDate: taskDatePicker.date, completed:completed.on)
        self.navigationController?.popViewControllerAnimated(true)
        
    }
}
