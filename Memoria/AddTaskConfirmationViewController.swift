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
    
    var addTaskTimeViewController : AddTaskTimeViewController!
    var addTaskTimePriorityViewController : AddTaskTimePriorityController!
    
    let lblTaskName = Label()
    
    init(container : Container, tasksServices : TasksServices, currenctTaskCreator : CurrenctTaskCreator) {
        self.currenctTaskCreator = currenctTaskCreator
        self.tasksServices = tasksServices
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        lblTaskName.text = self.currenctTaskCreator.task.taskType.name()

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
        
        let doneButton = UIBarButtonItem(title: Content.getContent(ContentType.buttonTxt, name: "Done"), style: UIBarButtonItemStyle.done, target: self, action: #selector(AddTaskConfirmationViewController.doneButtonPress))
        self.navigationItem.rightBarButtonItem = doneButton

        //Name
        let lblTaskNameDesc = Label()
        lblTaskNameDesc.titleGray()
        lblTaskNameDesc.text = Content.getContent(ContentType.labelTxt, name: "taskConfirmationTaskNameDesc")
    
        
        let btnEditTaskName = Button()
        btnEditTaskName.editBtn()

        //Sound
        let lblTaskSoundDesc = Label()
        lblTaskSoundDesc.titleGray()
        lblTaskSoundDesc.text = Content.getContent(ContentType.labelTxt, name: "taskConfirmationTaskSoundDesc")

        let btnTaskSound = Button()
        btnTaskSound.playSoundBtn()
        
        let btnEditTaskSound = Button()
        btnEditTaskSound.editBtn()
        
        //Time
        let lblTaskTimeDesc = Label()
        lblTaskTimeDesc.titleGray()
        lblTaskTimeDesc.text = Content.getContent(ContentType.labelTxt, name: "taskConfirmationTaskTimeDesc")
        
        lblTaskTime.defaultyTitle()
        
        let btnEditTaskTime = Button()
        btnEditTaskTime.editBtn()

        
        //TimePriority
        let lblTimePriorityDesc = Label()
        lblTimePriorityDesc.titleGray()
        lblTimePriorityDesc.text = Content.getContent(ContentType.labelTxt, name: "taskConfirmationTaskTimePriorityDesc")
        
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
        let leftVerticalLayout = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[lblTaskNameDesc]-(padding)-[lblTaskName]-(padding)-[lblTaskSoundDesc]-(padding)-[btnTaskSound]-(padding)-[lblTaskTimeDesc]-(padding)-[lblTaskTime]-(padding)-[lblTimePriorityDesc]-(padding)-[lblTaskTimePriority]", options: NSLayoutFormatOptions.alignAllLeading, metrics: matrics, views: viewsKeys)
        
        allConstains += leftVerticalLayout
        lblTaskNameDesc.leadingToSuperView(true)
        lblTaskNameDesc.topToViewControllerTopLayoutGuide(self, offset: 20)
        lblTaskTime.trailingToSuperView(true)
        
        btnEditTaskTime.trailingToSuperView(true)
        let _ = btnEditTaskTime.topAlighnToViewTop(lblTaskTimeDesc)
        
        btnEditTaskSound.trailingToSuperView(true)
        let _ = btnEditTaskSound.topAlighnToViewTop(lblTaskSoundDesc)
        
        btnEditTaskName.trailingToSuperView(true)
        let _ = btnEditTaskName.topAlighnToViewTop(lblTaskNameDesc)
        
        btnEditTaskTimePriority.trailingToSuperView(true)
        let _ = btnEditTaskTimePriority.topAlighnToViewTop(lblTimePriorityDesc) 

        NSLayoutConstraint.activate(allConstains)
        
        btnEditTaskTime.addTarget(self, action: #selector(AddTaskConfirmationViewController.btnEditTaskTimePress), for: UIControlEvents.touchUpInside)
        btnTaskSound.addTarget(self, action: #selector(AddTaskConfirmationViewController.btnPlaySoundPress), for: UIControlEvents.touchUpInside)
        btnEditTaskTimePriority.addTarget(self, action: #selector(AddTaskConfirmationViewController.btnEditTaskTimePriorityPress), for: UIControlEvents.touchUpInside)
    
    }


    //MARK: Buttons press
    
    func btnEditTaskTimePress() {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKind(of: AddTaskTimeViewController.self) {
                let _ = self.navigationController?.popToViewController(viewController, animated: true)
                return
            }
        }
        let addTaskTimeViewController = self.container.resolve(AddTaskTimeViewController.self)
        self.navigationController?.pushViewController(addTaskTimeViewController!, animated: true)
    }
    
    func btnEditTaskTimePriorityPress() {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKind(of: AddTaskTimePriorityController.self) {
                let _ = self.navigationController?.popToViewController(viewController, animated: true)
                return
            }
        }
        let addTaskTimePriorityController = self.container.resolve(AddTaskTimePriorityController.self)
        self.navigationController?.pushViewController(addTaskTimePriorityController!, animated: true)
    }


    func btnPlaySoundPress() {
        //Removing recornig functionllaity
        //self.recorder.playURL(self.currenctTaskCreator.getTaskVoiceURL()!)
    }
    
    func doneButtonPress() {
        let task = self.currenctTaskCreator.getCurrenctTask()
        self.tasksServices.saveTask(task)
        if let TaskManagerViewController = self.container.resolve(TaskManagerViewController.self) {
            self.navigationController!.pushViewController(TaskManagerViewController, animated: true)
        }

    }
}
