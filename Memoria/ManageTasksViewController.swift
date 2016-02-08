//
//  ManageAddTasksLocationViewController.swift
//  Memoria
//
//  Created by Matan Cohen on 1/13/16.
//  Copyright © 2016 MACMatan. All rights reserved.
//

import Foundation
import UIKit
import Swinject

class ManageAddTasksLocationViewController : ViewController, UITableViewDelegate, UITableViewDataSource {
    let tasksServices : TasksServices
    var allTasks : [Task]!
    let cellIdentifer = "cell"
    let tableView = UITableView()
    let currenctTaskCreator : CurrenctTaskCreator
    let container : Container
    
    init(tasksServices : TasksServices, currenctTaskCreator : CurrenctTaskCreator, container : Container) {
        self.tasksServices = tasksServices
        self.currenctTaskCreator = currenctTaskCreator
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        
        self.allTasks = self.tasksServices.getAllTasks()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allTasks = self.tasksServices.getAllTasks()

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneButtonPress")
        self.navigationItem.rightBarButtonItem = doneButton

        let lblTop = Label()
        lblTop.defaultyTitle()
        lblTop.text = "My Tasks:"
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifer)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        let topLayout = self.topLayoutGuide
        
        self.view.addSubviewWithAutoLayoutOn(lblTop)
        self.view.addSubviewWithAutoLayoutOn(tableView)
        
        let viewKeys : [String : AnyObject] =
        [
            "lblTop" : lblTop,
            "tableView" : tableView,
            "topLayout" : topLayout
        ]
        
        var allConstrins = [NSLayoutConstraint]()
        
        let verticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[topLayout]-[lblTop]-[tableView]-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: nil, views: viewKeys)

        let horizintalTableConstrain = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[tableView]-|", options: [], metrics: nil, views: viewKeys)

        let horizintalTopLblConstrain = NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-[lblTop]-|", options: [], metrics: nil, views: viewKeys)
        
        allConstrins += verticalLayout
        allConstrins += horizintalTableConstrain
        allConstrins += horizintalTopLblConstrain

        NSLayoutConstraint.activateConstraints(allConstrins)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }

    func doneButtonPress() {
        if let _ = self.navigationController {
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //TableView
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let task = self.allTasks[indexPath.row]
        let textForCell = task.taskName
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifer)
        cell?.textLabel?.text = textForCell! + "       " +  (task.taskBeaconIdentifier!.major)
        return cell!
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let task = self.allTasks[indexPath.row]
            self.tasksServices.removeTask(task)
            let index = self.allTasks.indexOf(task)
            self.allTasks.removeAtIndex(index!)
            self.tableView.reloadData()
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
        let addTaskNameController = self.container.resolve(AddTaskNameViewController.self)
        self.navigationController?.pushViewController(addTaskNameController!, animated: true)
    }
}