//
//  TaskModel.swift
//  TaskIt
//
//  Created by Dirk Groten on 26/02/15.
//  Copyright (c) 2015 Kridnet Software. All rights reserved.
//

import Foundation
import CoreData

@objc(TaskModel)
class TaskModel: NSManagedObject {

    @NSManaged var completed: NSNumber
    @NSManaged var date: NSDate
    @NSManaged var subtask: String
    @NSManaged var task: String

}

func ==(lhs: TaskModel, rhs: TaskModel) -> Bool
{
    return lhs.task == rhs.task && lhs.subtask == rhs.subtask && lhs.date == rhs.date && lhs.completed == rhs.completed
}

