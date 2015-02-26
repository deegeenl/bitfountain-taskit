//
//  AddTaskViewController.swift
//  TaskIt
//
//  Created by Dirk Groten on 25/02/15.
//  Copyright (c) 2015 Kridnet Software. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    weak var delegate: TaskSettingDelegate?

    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var subTaskTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTapped()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func addTask(sender: UIButton)
    {
        self.delegate?.didSaveTaskWithTitle?(taskTextField.text, subTaskTitle: subTaskTextField.text, dueDate: datePicker.date, completed: false)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
