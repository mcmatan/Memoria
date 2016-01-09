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

class AddTaskConfirmationViewController : ViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    let cellIdentifier = "Cell"
    var datesList : Array<NSDate>
    let container : Container
    let taskName : String
    let voiceURL : NSURL
    let recorder = Recorder()
    
    var addTaskNameViewController : AddTaskNameViewController!
    var addTaskVoiceViewController : AddTaskVoiceViewController!
    var addTaskTimeViewController : AddTaskTimeViewController!
    
    init(container : Container, taskName : String, datesList : Array<NSDate>, voiceURL : NSURL) {
        self.container = container
        self.taskName = taskName
        self.datesList = datesList
        self.voiceURL = voiceURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func saveViewControllers() {
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKindOfClass(AddTaskNameViewController) {
                addTaskNameViewController = viewController as! AddTaskNameViewController
            }
        }
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKindOfClass(AddTaskVoiceViewController) {
                addTaskVoiceViewController = viewController as! AddTaskVoiceViewController
            }
        }
        for viewController in (self.navigationController?.viewControllers)! {
            if viewController.isKindOfClass(AddTaskTimeViewController) {
                addTaskTimeViewController = viewController as! AddTaskTimeViewController
            }
        }
        self.navigationController?.setViewControllers([self], animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveViewControllers()
         //Creation
        //Name
        let lblTaskNameDesc = Label()
        lblTaskNameDesc.textColor = UIColor.blueColor()
        lblTaskNameDesc.text = Content.getContent(ContentType.LabelTxt, name: "taskConfirmationTaskNameDesc")
        
        let lblTaskName = Label()
        lblTaskName.text = self.taskName
        
        let btnEditTaskName = Button()
        btnEditTaskName.setTitle(Content.getContent(ContentType.ButtonTxt, name: "EditButton"), forState: UIControlState.Normal)
        btnEditTaskName.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)

        //Sound
        let lblTaskSoundDesc = Label()
        lblTaskSoundDesc.textColor = UIColor.blueColor()
        lblTaskSoundDesc.text = Content.getContent(ContentType.LabelTxt, name: "taskConfirmationTaskSoundDesc")

        let btnTaskSound = Button()
        btnTaskSound.setTitle(Content.getContent(ContentType.ButtonTxt, name: "PlaySound"), forState: UIControlState.Normal)
        btnTaskSound.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        
        let btnEditTaskSound = Button()
        btnEditTaskSound.setTitle(Content.getContent(ContentType.ButtonTxt, name: "EditButton"), forState: UIControlState.Normal)
        btnEditTaskSound.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        
        //Time
        let lblTaskTimeDesc = Label()
        lblTaskTimeDesc.textColor = UIColor.blueColor()
        lblTaskTimeDesc.text = Content.getContent(ContentType.LabelTxt, name: "taskConfirmationTaskTimeDesc")
        
        let btnEditTaskTime = Button()
        btnEditTaskTime.setTitle(Content.getContent(ContentType.ButtonTxt, name: "EditButton"), forState: UIControlState.Normal)
        btnEditTaskTime.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
    
        self.tableView.layer.borderColor = UIColor.grayColor().CGColor
        self.tableView.layer.borderWidth = 1.0
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.separatorColor = UIColor.grayColor()
        tableView.delegate = self
        tableView.dataSource = self

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
            self.tableView
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
            "tableView" : tableView
        ]
        
        var allConstains = [NSLayoutConstraint]()
        let leftVerticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[lblTaskNameDesc]-[lblTaskName]-[lblTaskSoundDesc]-[btnTaskSound]-[lblTaskTimeDesc]-[tableView]", options: NSLayoutFormatOptions.AlignAllLeading, metrics: nil, views: viewsKeys)
        
        allConstains += leftVerticalLayout
        lblTaskNameDesc.LeadingToSuperView(true)
        lblTaskNameDesc.topToViewControllerTopLayoutGuide(self)
        tableView.trailingToSuperView(true)
        tableView.bottomToViewControllerTopLayoutGuide(self)
        
        btnEditTaskTime.trailingToSuperView(true)
        btnEditTaskTime.topAlighnToViewTop(lblTaskTimeDesc)
        btnEditTaskSound.trailingToSuperView(true)
        btnEditTaskSound.topAlighnToViewTop(lblTaskSoundDesc)
        btnEditTaskName.trailingToSuperView(true)
        btnEditTaskName.topAlighnToViewTop(lblTaskNameDesc)

        NSLayoutConstraint.activateConstraints(allConstains)
        
        self.tableView.reloadData()
        btnEditTaskTime.addTarget(self, action: "btnEditTaskTimePress", forControlEvents: UIControlEvents.TouchUpInside)
        btnEditTaskName.addTarget(self, action: "btnEditTaskNamePress", forControlEvents: UIControlEvents.TouchUpInside)
        btnEditTaskSound.addTarget(self, action: "btnEditTaskSoundPress", forControlEvents: UIControlEvents.TouchUpInside)
        btnTaskSound.addTarget(self, action: "btnPlaySoundPress", forControlEvents: UIControlEvents.TouchUpInside)
    
    }

    //MARK: TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currenctTime = self.datesList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if let timeString = currenctTime.toString() {
            cell?.textLabel?.text = "\(timeString)"
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datesList.count
    }
    
    //MARK: Buttons press
    
    func btnEditTaskNamePress() {
        self.navigationController!.presentViewController(self.addTaskNameViewController, animated: true, completion: nil)
    }

    func btnEditTaskSoundPress() {
        self.navigationController!.presentViewController(self.addTaskVoiceViewController, animated: true, completion: nil)
    }

    func btnEditTaskTimePress() {
        self.navigationController!.presentViewController(self.addTaskTimeViewController, animated: true, completion: nil)
    }

    func btnPlaySoundPress() {
        self.recorder.playURL(self.voiceURL)
    }
}