//
//  AddTaskTimePriorityController.swift
//  Memoria
//
//  Created by Matan Cohen on 2/13/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import Swinject


class AddTaskTimePriorityController: ViewController {
    var lblExplenation  = Label()
    var switchPrairity = UISwitch()
    var btnDone = Button()
    var container : Container
    let tasksServices : TasksServices
    var currenctTaskCreator : CurrenctTaskCreator
    var addTaskVoiceViewController : AddTaskVoiceViewController?
    var addTaskConfirmationViewController : AddTaskConfirmationViewController?    
    
    init(container : Container, currenctTaskCreator : CurrenctTaskCreator, tasksServices : TasksServices) {
        self.container = container
        self.tasksServices = tasksServices
        self.currenctTaskCreator = currenctTaskCreator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.currenctTaskCreator.getTaskName()
        if let isTimePriority = currenctTaskCreator.getTaskTimePriority() {
            self.switchPrairity.on = isTimePriority
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.switchPrairity = UISwitch()
        
        self.btnDone.setTitle("Done", forState: UIControlState.Normal)
        self.btnDone.addTarget(self, action: "doneBtnPress", forControlEvents: UIControlEvents.TouchUpInside)
        self.btnDone.defaultStyle()
        
        self.lblExplenation.font = UIFont.systemFontOfSize(15)
        self.lblExplenation.textAlignment = NSTextAlignment.Center
        self.lblExplenation.text = "Turn switch on for Hi priority.\n That means You cannot accomplish the task not at time"
        self.lblExplenation.numberOfLines = 0
        
        self.view.addSubview(lblExplenation)
        self.view.addSubview(switchPrairity)
        self.view.addSubview(btnDone)
        
        
        lblExplenation.translatesAutoresizingMaskIntoConstraints = false
        switchPrairity.translatesAutoresizingMaskIntoConstraints = false
        btnDone.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [lblExplenation,btnDone]
        let viewsInfoDic : [String : AnyObject] =
        [
            "switchPrairity" : switchPrairity,
            "lblExplenation" : lblExplenation,
            "btnDone" : btnDone
        ]
        
        
        UIViewAutoLayoutExtentions.equalWidthsForViews(views)
        
        let verticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[lblExplenation]-[switchPrairity]-[btnDone]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: viewsInfoDic)
        NSLayoutConstraint.activateConstraints(verticalLayout)
        
        lblExplenation.topToViewControllerTopLayoutGuide(self, offset: 20)
        switchPrairity.centerVerticlyInSuperView()
    }
    
    func timePriorirtySwitchStateChage(change : UISwitch) {
        self.currenctTaskCreator.setTaskTimePriority(change.on)
    }
    
    
    func doneBtnPress() {
        self.currenctTaskCreator.setTaskTimePriority(self.switchPrairity.on)
        self.tasksServices.saveTask(self.currenctTaskCreator.getCurrenctTask())
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
//        if let _ = self.addTaskConfirmationViewController {} else {
//            self.addTaskConfirmationViewController = self.container.resolve(AddTaskConfirmationViewController.self)
//        }
//        self.navigationController?.pushViewController(self.addTaskConfirmationViewController!, animated: true)

        
    }
    

}
