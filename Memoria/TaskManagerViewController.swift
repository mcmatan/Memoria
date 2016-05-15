//
//  TaskManagerViewController.swift
//  Memoria
//
//  Created by Matan Cohen on 1/13/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import Swinject

class TaskManagerViewController : ViewController, UITableViewDelegate, UITableViewDataSource {
    let kCellHeight = 70
    let tasksServices : TasksServices
    var allTasks : [Task]!
    let cellIdentifer = "cell"
    let tableView = UITableView()
    let currenctTaskCreator : CurrenctTaskCreator
    let container : Container
    let iBeaconServices : IBeaconServices
    var addTaskNameViewController : AddTaskNameViewController?
    let lblCount = Label()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

    
    init(tasksServices : TasksServices, currenctTaskCreator : CurrenctTaskCreator, container : Container, iBeaconServices : IBeaconServices) {
        self.tasksServices = tasksServices
        self.currenctTaskCreator = currenctTaskCreator
        self.container = container
        self.iBeaconServices = iBeaconServices
        super.init(nibName: nil, bundle: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TaskManagerViewController.reloadTable), name: NotificationsNames.kTaskDone, object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        
        self.allTasks = self.tasksServices.getAllTasks()
        self.reloadTable()
    
    }
    
    dynamic private func reloadTable() {
        self.allTasks = self.tasksServices.getAllTasks()        
        self.tableView .reloadData()
        self.lblCount.text =  "Remining \(self.allTasks.count)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "navigationBar")
        self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)

        
        self.allTasks = self.tasksServices.getAllTasks()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(TaskManagerViewController.doneButtonPress))
        self.navigationItem.rightBarButtonItem = doneButton
        
        let createTaskBtn = Button()
        createTaskBtn.defaultStyle()
        createTaskBtn.setTitle("+ Create a new task", forState: UIControlState.Normal)
        createTaskBtn.addTarget(self, action: #selector(TaskManagerViewController.createNewTask), forControlEvents: UIControlEvents.TouchUpInside)

        let lblTop = Label()
        lblTop.defaultyTitle()
        lblTop.text = "My Memories"
        
        lblCount.defaultyTitle()
        lblCount.text = "No remining tasks"
        lblCount.textColor = UIColor.grayColor()

        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        let topLayout = self.topLayoutGuide

        self.view.addSubviewWithAutoLayoutOn(createTaskBtn)
        self.view.addSubviewWithAutoLayoutOn(lblTop)
        self.view.addSubviewWithAutoLayoutOn(tableView)
        self.view.addSubviewWithAutoLayoutOn(lblCount)
        createTaskBtn.addSubviewWithAutoLayoutOn(activityIndicator)
        
        let viewKeys : [String : AnyObject] =
        [
            "lblTop" : lblTop,
            "lblCount" : lblCount,
            "tableView" : tableView,
            "topLayout" : topLayout,
            "createTaskBtn" : createTaskBtn,
        ]
        
        var allConstrins = [NSLayoutConstraint]()
        
        let verticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[topLayout]-(20)-[createTaskBtn]-(20)-[lblTop]-[tableView]-(20)-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: viewKeys)

        let horizintalTableConstrain = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[tableView]-|", options: [], metrics: nil, views: viewKeys)

        let horizintalTopLblConstrain = NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-[lblTop]-|", options: [], metrics: nil, views: viewKeys)
        
        lblCount.topAlighnToViewTop(lblTop)
        lblCount.trailingToSuperView(true)
        
        allConstrins += verticalLayout
        allConstrins += horizintalTableConstrain
        allConstrins += horizintalTopLblConstrain

        NSLayoutConstraint.activateConstraints(allConstrins)
        UIViewAutoLayoutExtentions.centerVerticlyAlViewsInSuperView([activityIndicator])
        UIViewAutoLayoutExtentions.centerHorizontalyAlViewsInSuperView([activityIndicator])

        
        self.tableView.delegate = self
        self.tableView.dataSource = self
     
    }

    //MARK: TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let task = self.allTasks[indexPath.row]
        let textForCell = "Task name: "  + task.taskName!
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) 
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        cell?.textLabel?.text = textForCell
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator;
        cell?.detailTextLabel?.text = "Schedule time:" + (task.taskTime?.toStringWithCurrentRegion())! + " major:" + (task.taskBeaconIdentifier!.major)
        
        cell?.contentView.backgroundColor = task.isTaskDone ? Colors.lightGreen() : UIColor.whiteColor()

        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(kCellHeight)
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let task = self.allTasks[indexPath.row]
            self.tasksServices.removeTask(task)
            let index = self.allTasks.indexOf(task)
            self.allTasks.removeAtIndex(index!)
            self.reloadTable()
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if (self.allTasks.count != 0) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.tableView.backgroundView = nil
        } else {
            let lblNoData = UILabel()
            lblNoData.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)
            lblNoData.text = "No tasks assigned"
            lblNoData.textColor = UIColor.blackColor()
            lblNoData.textAlignment = NSTextAlignment.Center
            self.tableView.backgroundView = lblNoData
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allTasks.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let task = self.allTasks[indexPath.row]
        self.currenctTaskCreator.setCurrenctTask(task)
        
        let addTaskConfirmationViewController = self.container.resolve(AddTaskConfirmationViewController.self)
        self.navigationController?.pushViewController(addTaskConfirmationViewController!, animated: true)
    }
    
    //MARK: Button press
    
    func createNewTask() {
        self.activityIndicator.startAnimating()
        self.iBeaconServices.isThereABeaconInArea { (result, beacon) -> Void in
            self.activityIndicator.stopAnimating()
            if result == false {
                self.showNoBeaconInEreaMessage()
                return
            }
            if self.iBeaconServices.isBeaconAlreadyHasATaskAssigned(beacon!) == true {
                self.showBeaconHasAlreadyTaskAssignedMessage(beacon!)
                return
            }
            
            self.goToNextPage(beacon!)
        }
    }
    
    //MARK: Alerts
    
    func showNoBeaconInEreaMessage() {
        let alert = UIAlertController(title: "No beacons detected in current area", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        let btnOk = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel) { (action : UIAlertAction) in
        }
        alert.addAction(btnOk)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func showBeaconHasAlreadyTaskAssignedMessage(closestBeacon : CLBeacon) {
        let closeiBeaconIdentifier = IBeaconIdentifier.creatFromCLBeacon(closestBeacon)
        let alert = UIAlertController(title: "The beacon you have selected \(closeiBeaconIdentifier.major), already has a task assigend to it", message: "Do you want to edit the task?", preferredStyle: UIAlertControllerStyle.Alert)
        let btnYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (action : UIAlertAction) in
            let task = self.tasksServices.getTaskForIBeaconIdentifier(closeiBeaconIdentifier)
            self.currenctTaskCreator.setCurrenctTask(task)
            self.goToNextPage(closestBeacon)
        }
        
        let btnNo = UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel) { (action : UIAlertAction) in
        }
        alert.addAction(btnNo)
        alert.addAction(btnYes)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: Navgiation
    
    func goToNextPage(closestBeacon : CLBeacon) {
        let closeiBeaconIdentifier = IBeaconIdentifier.creatFromCLBeacon(closestBeacon)
        self.currenctTaskCreator.startNewTask()
        self.currenctTaskCreator.setTaskBeaconIdentifier(closeiBeaconIdentifier)
        
        if let _ = self.addTaskNameViewController {} else {
            self.addTaskNameViewController = self.container.resolve(AddTaskNameViewController.self)
        }
        self.navigationController?.pushViewController(self.addTaskNameViewController!, animated: true)
    }

    //MARK: Buttons
    func doneButtonPress() {
        if let _ = self.navigationController {
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    

}