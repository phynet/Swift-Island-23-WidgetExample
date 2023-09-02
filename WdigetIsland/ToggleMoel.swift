//
//  ToggleMoel.swift
//  WdigetIsland
//
//  Created by Sofia Swidarowicz on 2/9/23.
//

import Foundation

struct TaskModel: Identifiable {
    var id: String = UUID().uuidString
    var taskTitle: String
    var isCompleted: Bool = false
}

class TaskDataModel {
    static let shared = TaskDataModel()
    private init() {}
    
    var tasks: [TaskModel] = [
        .init(taskTitle: "Take 500 mlt"),
        .init(taskTitle: "Take 1 Lt"),
        .init(taskTitle: "Take 1.5 Lt")
    ]
    
//    var tasks: [TaskModel] = [
//      
//    ]
}
