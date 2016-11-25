//
//  TaskDisplay.swift
//  Memoria
//
//  Created by Matan Cohen on 25/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

struct  TaskDisplay {
    let taskType: String
    let isCompeate: Bool
    let date: Date
    let image: UIImage
    let uid: String

    init(task: Task, date: Date) {
        self.taskType = task.taskType.name()
        self.isCompeate = false //TBD
        self.date = date
        self.image = task.taskType.image(withColor: false)
        self.uid = task.uid
    }
}
