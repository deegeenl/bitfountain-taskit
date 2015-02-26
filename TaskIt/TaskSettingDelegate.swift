//
//  TaskSettingDelegate.swift
//  TaskIt
//
//  Created by Dirk Groten on 25/02/15.
//  Copyright (c) 2015 Kridnet Software. All rights reserved.
//

import Foundation

@objc protocol TaskSettingDelegate: class
{
    optional func didSaveTaskWithTitle(title: String, subTaskTitle: String, dueDate: NSDate, completed isCompleted: Bool)
}

