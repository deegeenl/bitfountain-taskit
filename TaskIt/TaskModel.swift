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
class TaskModel: NSManagedObject, Equatable {

    @NSManaged var completed: Bool
    @NSManaged var date: NSDate
    @NSManaged var subtask: String
    @NSManaged var task: String

}

// Added this to make TaskModel conform to Equatable
// This can then be used to check equality between tasks, e.g. when filtering an array of tasks
func ==(lhs: TaskModel, rhs: TaskModel) -> Bool
{
    return lhs.task == rhs.task && lhs.subtask == rhs.subtask && lhs.date == rhs.date && lhs.completed == rhs.completed
}

