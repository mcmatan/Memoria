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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.currenctTaskCreator.getTaskName()
        if let isTimePriority = currenctTaskCreator.getTaskTimePriority() {
            self.switchPrairity.isOn = isTimePriority
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.switchPrairity = UISwitch()
        
        self.btnDone.setTitle(Content.getContent(ContentType.buttonTxt, name: "DoneButton"), for: UIControlState())
        self.btnDone.addTarget(self, action: #selector(AddTaskTimePriorityController.doneBtnPress), for: UIControlEvents.touchUpInside)
        self.btnDone.defaultStyle()
        
        self.lblExplenation.font = UIFont.systemFont(ofSize: 15)
        self.lblExplenation.textAlignment = NSTextAlignment.center
        self.lblExplenation.text = Content.getContent(ContentType.labelTxt, name: "AddTaskPrirityExpenation")
        self.lblExplenation.numberOfLines = 0
        
        self.view.addSubview(lblExplenation)
        self.view.addSubview(switchPrairity)
        self.view.addSubview(btnDone)
        
        
        lblExplenation.translatesAutoresizingMaskIntoConstraints = false
        switchPrairity.translatesAutoresizingMaskIntoConstraints = false
        btnDone.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [lblExplenation,btnDone] as [Any]
        let viewsInfoDic : [String : AnyObject] =
        [
            "switchPrairity" : switchPrairity,
            "lblExplenation" : lblExplenation,
            "btnDone" : btnDone
        ]
        
        
        UIViewAutoLayoutExtentions.equalWidthsForViews(views as! [UIView])
        
        let verticalLayout = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[lblExplenation]-[switchPrairity]-[btnDone]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewsInfoDic)
        NSLayoutConstraint.activate(verticalLayout)
        
        lblExplenation.topToViewControllerTopLayoutGuide(self, offset: 20)
        switchPrairity.centerVerticlyInSuperView()
    }
    
    func timePriorirtySwitchStateChage(_ change : UISwitch) {
        self.currenctTaskCreator.setTaskTimePriority(change.isOn)
    }
    
    
    func doneBtnPress() {
        self.currenctTaskCreator.setTaskTimePriority(self.switchPrairity.isOn)
        self.tasksServices.saveTask(self.currenctTaskCreator.getCurrenctTask())
        
        self.navigationController?.popToRootViewController(animated: true)
        
//        if let _ = self.addTaskConfirmationViewController {} else {
//            self.addTaskConfirmationViewController = self.container.resolve(AddTaskConfirmationViewController.self)
//        }
//        self.navigationController?.pushViewController(self.addTaskConfirmationViewController!, animated: true)

        
    }
    

}
