//
//  AddTaskConfirmationViewController.swift
//  Memoria
//
//  Created by Matan Cohen on 1/6/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import Swinject

class AddTaskConfirmationViewController : ViewController {
    let cellIdentifier = "Cell"
    let container : Container
    let recorder = VoiceRecorder()
    let tasksServices : TasksServices
    let lblTaskTime = Label()
    let lblTaskTimePriority = Label()
    var currenctTaskCreator : CurrenctTaskCreator
    
    var addTaskNameViewController : AddTaskNameViewController!
    var addTaskVoiceViewController : AddTaskVoiceViewController!
    var addTaskTimeViewController : AddTaskTimeViewController!
    var addTaskTimePriorityViewController : AddTaskTimePriorityController!
    
    let lblTaskName = Label()
    
    init(container : Container, tasksServices : TasksServices, currenctTaskCreator : CurrenctTaskCreator) {
        self.currenctTaskCreator = currenctTaskCreator
        self.tasksServices = tasksServices
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        lblTaskName.text = self.currenctTaskCreator.getTaskName()

        let currenctTime = self.currenctTaskCreator.getTaskTime()
        let timeString = currenctTime!.toStringWithCurrentRegion()
        self.lblTaskTime.text = "\(timeString)"
        
        if let isTimePriority = self.currenctTaskCreator.getTaskTimePriority() {
            let timePriorityToString = (isTimePriority == true) ? "Hi" : "Low"
            self.lblTaskTimePriority.text = timePriorityToString
            self.lblTaskTimePriority.textColor = Colors.green()
        }


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneButtonPress")
        self.navigationItem.rightBarButtonItem = doneButton

        //Name
        let lblTaskNameDesc = Label()
        lblTaskNameDesc.titleGray()
        lblTaskNameDesc.text = Content.getContent(ContentType.LabelTxt, name: "taskConfirmationTaskNameDesc")
    
        
        let btnEditTaskName = Button()
        btnEditTaskName.editBtn()

        //Sound
        let lblTaskSoundDesc = Label()
        lblTaskSoundDesc.titleGray()
        lblTaskSoundDesc.text = Content.getContent(ContentType.LabelTxt, name: "taskConfirmationTaskSoundDesc")

        let btnTaskSound = Button()
        btnTaskSound.playSoundBtn()
        
        let btnEditTaskSound = Button()
        btnEditTaskSound.editBtn()
        
        //Time
        let lblTaskTimeDesc = Label()
        lblTaskTimeDesc.titleGray()
        lblTaskTimeDesc.text = Content.getContent(ContentType.LabelTxt, name: "taskConfirmationTaskTimeDesc")
        
        lblTaskTime.defaultyTitle()
        
        let btnEditTaskTime = Button()
        btnEditTaskTime.editBtn()

        
        //TimePriority
        let lblTimePriorityDesc = Label()
        lblTimePriorityDesc.titleGray()
        lblTimePriorityDesc.text = Content.getContent(ContentType.LabelTxt, name: "taskConfirmationTaskTimePriorityDesc")
        
        lblTaskTimePriority.defaultyTitle()
        
        let btnEditTaskTimePriority = Button()
        btnEditTaskTimePriority.editBtn()


        
        self.view.addSubviewsWithAutoLayoutOn(
            [
            lblTaskNameDesc,
            lblTaskName,
            btnEditTaskName,//Edit
            lblTaskSoundDesc,
            btnTaskSound,
            btnEditTaskSound,//Edit
            lblTaskTimeDesc,
            btnEditTaskTime,//Edit
            self.lblTaskTime,
            lblTaskTimePriority,
            lblTimePriorityDesc,
            btnEditTaskTimePriority,
            ]
        )
        
        let viewsKeys : [String : AnyObject] =
        [
            "lblTaskNameDesc" : lblTaskNameDesc,
            "lblTaskName" :lblTaskName,
            "btnEditTaskName" : btnEditTaskName,//Edit
            "lblTaskSoundDesc" : lblTaskSoundDesc,
            "btnTaskSound" : btnTaskSound,
            "btnEditTaskSound" : btnEditTaskSound,//Edit
            "lblTaskTimeDesc" : lblTaskTimeDesc,
            "btnEditTaskTime" : btnEditTaskTime,//Edit
            "lblTaskTime" : lblTaskTime,
            "lblTaskTimePriority" : lblTaskTimePriority,
            "lblTimePriorityDesc" : lblTimePriorityDesc,
            "btnEditTaskTimePriority" : btnEditTaskTimePriority
        ]
        
        let matrics = ["padding" : 10];
        
        var allConstains = [NSLayoutConstraint]()
        let leftVerticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[lblTaskNameDesc]-(padding)-[lblTaskName]-(padding)-[lblTaskSoundDesc]-(padding)-[btnTaskSound]-(padding)-[lblTaskTimeDesc]-(padding)-[lblTaskTime]-(padding)-[lblTimePriorityDesc]-(padding)-[lblTaskTimePriority]", options: NSLayoutFormatOptions.AlignAllLeading, metrics: matrics, views: viewsKeys)
        
        allConstains += leftVerticalLayout
        lblTaskNameDesc.leadingToSuperView(true)
        lblTaskNameDesc.topToViewControllerTopLayoutGuide(self, offset: 20)
        lblTaskTime.trailingToSuperView(true)
        
        btnEditTaskTime.trailingToSuperView(true)
        btnEditTaskTime.topAlighnToViewTop(lblTaskTimeDesc)
        
        btnEditTaskSound.trailingToSuperView(true)
        btnEditTaskSound.topAlighnToViewTop(lblTaskSoundDesc)
        
        btnEditTaskName.trailingToSuperView(true)
        btnEditTaskName.topAlighnToViewTop(lblTaskNameDesc)
        
        btnEditTaskTimePriority.trailingToSuperView(true)
        btnEditTaskTimePriority.topAlighnToViewTop(lblTimePriorityDesc) 

        NSLayoutConstraint.activateConstraints(allConstains)
        
        btnEditTaskTime.addTarget(self, action: "btnEditTaskTimePress", forControlEvents: UIControlEvents.TouchUpInside)
        btnEditTaskName.addTarget(self, action: "btnEditTaskNamePress", forControlEvents: UIControlEvents.TouchUpInside)
        btnEditTaskSound.addTarget(self, action: "btnEditTaskSoundPress", forControlEvents: UIControlEvents.TouchUpInside)
        btnTaskSound.addTarget(self, action: "btnPlaySoundPress", forControlEvents: UIControlEvents.TouchUpInside)
        btnEditTaskTimePriority.addTarget(self, action: "btnEditTaskTimePriorityPress", forControlEvents: UIControlEvents.TouchUpInside)
    
    }


    //MARK: Buttons press
    
    func btnEditTaskNamePress() {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKindOfClass(AddTaskNameViewController) {
                self.navigationController?.popToViewController(viewController, animated: true)
                return
            }
        }
        let addTaskNameViewController = self.container.resolve(AddTaskNameViewController.self)
        self.navigationController?.pushViewController(addTaskNameViewController!, animated: true)
    }

    func btnEditTaskSoundPress() {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKindOfClass(AddTaskVoiceViewController) {
                self.navigationController?.popToViewController(viewController, animated: true)
                return
            }
        }
        let addTaskVoiceViewController = self.container.resolve(AddTaskVoiceViewController.self)
        self.navigationController?.pushViewController(addTaskVoiceViewController!, animated: true)
    }

    func btnEditTaskTimePress() {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKindOfClass(AddTaskTimeViewController) {
                self.navigationController?.popToViewController(viewController, animated: true)
                return
            }
        }
        let addTaskTimeViewController = self.container.resolve(AddTaskTimeViewController.self)
        self.navigationController?.pushViewController(addTaskTimeViewController!, animated: true)
    }
    
    func btnEditTaskTimePriorityPress() {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKindOfClass(AddTaskTimePriorityController) {
                self.navigationController?.popToViewController(viewController, animated: true)
                return
            }
        }
        let addTaskTimePriorityController = self.container.resolve(AddTaskTimePriorityController.self)
        self.navigationController?.pushViewController(addTaskTimePriorityController!, animated: true)
    }


    func btnPlaySoundPress() {
        self.recorder.playURL(self.currenctTaskCreator.getTaskVoiceURL()!)
    }
    
    func doneButtonPress() {
        let task = self.currenctTaskCreator.getCurrenctTask()
        self.tasksServices.saveTask(task)
        if let manageAddTasksLocationViewController = self.container.resolve(ManageAddTasksLocationViewController.self) {
            self.navigationController!.pushViewController(manageAddTasksLocationViewController, animated: true)
        }

    }
}
