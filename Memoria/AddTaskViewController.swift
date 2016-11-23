//
//  AddTaskViewController.swift
//  Memoria
//
//  Created by Matan Cohen on 23/11/2016.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit

class AddTaskViewController: ViewController {
    let btnTaskType = Button()
    let dayTimeRepeatePicker = DayTimeRepeatePicker()
    let btnCreate = Button()
    var pickerWithBlock: UIPickerWithBlock?
    let currentTaskCreator: CurrenctTaskCreator
    
    init(currentTaskCreator: CurrenctTaskCreator) {
        self.currentTaskCreator = currentTaskCreator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(btnTaskType)
        view.addSubview(dayTimeRepeatePicker)
        view.addSubview(btnCreate)
        
        dayTimeRepeatePicker.topAlighnToViewTop(view, offset: 30)
        dayTimeRepeatePicker.leadingToSuperView(true)
        dayTimeRepeatePicker.trailingToSuperView(true)
        
        btnTaskType.centerHorizontlyInSuperView()
        btnTaskType.topAlighnToViewBottom(dayTimeRepeatePicker, offset: 30)
        btnTaskType.defaultStyleMini()
        btnTaskType.setTitle(Content.getContent(name: "btnChooseTaskType"), for: UIControlState.normal)
        btnTaskType.addTarget(self, action: #selector(btnChooseTaskTypePress), for: UIControlEvents.touchUpInside)
        
        btnCreate.defaultStyle()
        btnCreate.setTitle(Content.getContent(name: "btnCreateTask"), for: UIControlState.normal)
        
        btnCreate.bottomAlighnToViewBottom(view, offset: -20)
        btnCreate.centerHorizontlyInSuperView()
    }
    
    func btnChooseTaskTypePress() {
        let titles = [TaskType.drugs.name(), TaskType.brushTeeth.name(), TaskType.food.name(), TaskType.wakeUp.name(), TaskType.goToGym.name(), TaskType.goToWork.name()]
        self.pickerWithBlock = UIPickerWithBlock(viewController: self, titles: titles) { index, title  in
            var choosenTaskType: TaskType
            switch title {
            case TaskType.brushTeeth.name():
                choosenTaskType = TaskType.brushTeeth
            case TaskType.drugs.name():
                choosenTaskType = TaskType.drugs
            case TaskType.food.name():
                choosenTaskType = TaskType.food
            case TaskType.goToWork.name():
                choosenTaskType = TaskType.goToWork
            case TaskType.goToGym.name():
                choosenTaskType = TaskType.goToGym
            case TaskType.wakeUp.name():
                choosenTaskType = TaskType.wakeUp
            default:
                print("No Task title has match")
                choosenTaskType = TaskType.food
            }
            
            self.btnTaskType.setTitle(title, for: UIControlState.normal)
            self.currentTaskCreator.setTaskType(type: choosenTaskType)
        }
    }
    
    func btnCreatePress() {
        self.currenctTaskCreator.setTaskTimePriority(self.switchPrairity.isOn)
        self.tasksServices.saveTask(self.currenctTaskCreator.getCurrenctTask())
        
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
