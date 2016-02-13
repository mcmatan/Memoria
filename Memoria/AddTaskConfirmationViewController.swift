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
    var currenctTaskCreator : CurrenctTaskCreator
    
    var addTaskNameViewController : AddTaskNameViewController!
    var addTaskVoiceViewController : AddTaskVoiceViewController!
    var addTaskTimeViewController : AddTaskTimeViewController!
    
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
        if let timeString = currenctTime!.toString() {
            self.lblTaskTime.text = "\(timeString)"
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
        lblTaskNameDesc.defaultyTitle()
        lblTaskNameDesc.text = Content.getContent(ContentType.LabelTxt, name: "taskConfirmationTaskNameDesc")
    
        
        let btnEditTaskName = Button()
        btnEditTaskName.defaultStyleMini()
        btnEditTaskName.setTitle(Content.getContent(ContentType.ButtonTxt, name: "EditButton"), forState: UIControlState.Normal)

        //Sound
        let lblTaskSoundDesc = Label()
        lblTaskSoundDesc.defaultyTitle()
        lblTaskSoundDesc.text = Content.getContent(ContentType.LabelTxt, name: "taskConfirmationTaskSoundDesc")

        let btnTaskSound = Button()
        btnTaskSound.defaultStyleMini()
        btnTaskSound.setTitle(Content.getContent(ContentType.ButtonTxt, name: "PlaySound"), forState: UIControlState.Normal)
        
        let btnEditTaskSound = Button()
        btnEditTaskSound.defaultStyleMini()
        btnEditTaskSound.setTitle(Content.getContent(ContentType.ButtonTxt, name: "EditButton"), forState: UIControlState.Normal)
        
        //Time
        let lblTaskTimeDesc = Label()
        lblTaskTimeDesc.defaultyTitle()
        lblTaskTimeDesc.text = Content.getContent(ContentType.LabelTxt, name: "taskConfirmationTaskTimeDesc")
        
        let btnEditTaskTime = Button()
        btnEditTaskTime.defaultStyleMini()
        btnEditTaskTime.setTitle(Content.getContent(ContentType.ButtonTxt, name: "EditButton"), forState: UIControlState.Normal)
    

        
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
            self.lblTaskTime
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
            "lblTaskTime" : lblTaskTime
        ]
        
        var allConstains = [NSLayoutConstraint]()
        let leftVerticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[lblTaskNameDesc]-[lblTaskName]-[lblTaskSoundDesc]-[btnTaskSound]-[lblTaskTimeDesc]-[lblTaskTime]", options: NSLayoutFormatOptions.AlignAllLeading, metrics: nil, views: viewsKeys)
        
        allConstains += leftVerticalLayout
        lblTaskNameDesc.LeadingToSuperView(true)
        lblTaskNameDesc.topToViewControllerTopLayoutGuide(self, offset: 20)
        lblTaskTime.trailingToSuperView(true)
        
        btnEditTaskTime.trailingToSuperView(true)
        btnEditTaskTime.topAlighnToViewTop(lblTaskTimeDesc)
        btnEditTaskSound.trailingToSuperView(true)
        btnEditTaskSound.topAlighnToViewTop(lblTaskSoundDesc)
        btnEditTaskName.trailingToSuperView(true)
        btnEditTaskName.topAlighnToViewTop(lblTaskNameDesc)

        NSLayoutConstraint.activateConstraints(allConstains)
        
        btnEditTaskTime.addTarget(self, action: "btnEditTaskTimePress", forControlEvents: UIControlEvents.TouchUpInside)
        btnEditTaskName.addTarget(self, action: "btnEditTaskNamePress", forControlEvents: UIControlEvents.TouchUpInside)
        btnEditTaskSound.addTarget(self, action: "btnEditTaskSoundPress", forControlEvents: UIControlEvents.TouchUpInside)
        btnTaskSound.addTarget(self, action: "btnPlaySoundPress", forControlEvents: UIControlEvents.TouchUpInside)
    
    }

//    //MARK: TableView
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let currenctTime = self.currenctTaskCreator.getTaskTime()
//        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
//        if let timeString = currenctTime!.toString() {
//            cell?.textLabel?.text = "\(timeString)"
//        }
//        return cell!
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }

    //MARK: Buttons press
    
    func btnEditTaskNamePress() {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKindOfClass(AddTaskNameViewController) {
                self.navigationController?.popToViewController(viewController, animated: true)
            }
        }
    }

    func btnEditTaskSoundPress() {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKindOfClass(AddTaskVoiceViewController) {
                self.navigationController?.popToViewController(viewController, animated: true)
            }
        }
    }

    func btnEditTaskTimePress() {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKindOfClass(AddTaskTimeViewController) {
                self.navigationController?.popToViewController(viewController, animated: true)
            }
        }
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
