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
import EmitterKit

class TaskManagerViewController : ViewController, UITableViewDelegate, UITableViewDataSource {
    let kCellHeight = 70
    let tasksServices : TasksServices
    var allTasks : [Task]!
    let cellIdentifer = "cell"
    let tableView = UITableView()
    let currenctTaskCreator : CurrenctTaskCreator
    let container : Container
    let iNearableServices : NearableServices
    let lblCount = Label()
    var addTaskTypeViewController: AddTaskTypeViewController?
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    var tasksChangedListener: EventListener<Any>!

    
    init(tasksServices : TasksServices, currenctTaskCreator : CurrenctTaskCreator, container : Container, iNearableServices : NearableServices) {
        self.tasksServices = tasksServices
        self.currenctTaskCreator = currenctTaskCreator
        self.container = container
        self.iNearableServices = iNearableServices
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TaskManagerViewController.reloadTable), name: NSNotification.Name(rawValue: NotificationsNames.kTaskDone), object: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        
        self.allTasks = self.tasksServices.getAllTasks()
        self.reloadTable()
    
    }
    
    dynamic fileprivate func reloadTable() {
        self.allTasks = self.tasksServices.getAllTasks()        
        self.tableView .reloadData()
        
        let remainingTasks = self.allTasks.filter { task in
            return task.isTaskDone
        }
        let remainingCount = remainingTasks.count
        if (remainingCount > 0) {
            let text = Content.getContent(ContentType.labelTxt, name: "TaskManagerRemaining")
            let format = String.localizedStringWithFormat(text, "\(remainingCount)")
            self.lblCount.text = format
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.bindings()
    }
    
    func bindings() {
        self.tasksChangedListener = Events.shared.tasksChanged.on { event in
            self.reloadTable()
        }
    }
    
    func setupView() {
        let image = UIImage(named: "navigationBar")
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        
        
        self.allTasks = self.tasksServices.getAllTasks()
        
        let doneButton = UIBarButtonItem(title: Content.getContent(ContentType.buttonTxt, name: "Done"), style: UIBarButtonItemStyle.done, target: self, action: #selector(TaskManagerViewController.doneButtonPress))
        self.navigationItem.rightBarButtonItem = doneButton
        
        let btnCreateStickerTask = Button()
        btnCreateStickerTask.defaultStyle()
        btnCreateStickerTask.setTitle(Content.getContent(ContentType.labelTxt, name: "TaskManagerCreateStickerTask"), for: UIControlState())
        btnCreateStickerTask.addTarget(self, action: #selector(TaskManagerViewController.createNewStickerTask), for: UIControlEvents.touchUpInside)
        
        let btnCreateTask = Button()
        btnCreateTask.defaultStyle()
        btnCreateTask.setTitle(Content.getContent(ContentType.labelTxt, name: "TaskManagerCreateTask"), for: UIControlState())
        btnCreateTask.addTarget(self, action: #selector(TaskManagerViewController.createNewTimeTask), for: UIControlEvents.touchUpInside)
        
        let btnCreateGPSLocationTask = Button()
        btnCreateGPSLocationTask.defaultStyle()
        btnCreateGPSLocationTask.setTitle(Content.getContent(ContentType.labelTxt, name: "TaskManagerCreateGPSLocationTask"), for: UIControlState())
        btnCreateGPSLocationTask.addTarget(self, action: #selector(TaskManagerViewController.createNewStickerTask), for: UIControlEvents.touchUpInside)
        
        let lblTop = Label()
        lblTop.defaultyTitle()
        lblTop.text = Content.getContent(ContentType.labelTxt, name: "TaskManagerVCLblTop")
        
        lblCount.defaultyTitle()
        lblCount.text = Content.getContent(ContentType.labelTxt, name: "TaskManagerVCNoRemainingTasks")
        lblCount.textColor = UIColor.gray
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let topLayout = self.topLayoutGuide
        
        self.view.addSubviewWithAutoLayoutOn(btnCreateStickerTask)
        self.view.addSubviewWithAutoLayoutOn(btnCreateTask)
        self.view.addSubviewWithAutoLayoutOn(btnCreateGPSLocationTask)
        self.view.addSubviewWithAutoLayoutOn(lblTop)
        self.view.addSubviewWithAutoLayoutOn(tableView)
        self.view.addSubviewWithAutoLayoutOn(lblCount)
        btnCreateStickerTask.addSubviewWithAutoLayoutOn(activityIndicator)
        
        let viewKeys : [String : AnyObject] =
            [
                "lblTop" : lblTop,
                "lblCount" : lblCount,
                "tableView" : tableView,
                "topLayout" : topLayout,
                "btnCreateStickerTask" : btnCreateStickerTask,
                "btnCreateTask" : btnCreateTask,
                "btnCreateGPSLocationTask": btnCreateGPSLocationTask,
                ]
        
        var allConstrins = [NSLayoutConstraint]()
        
        let verticalLayout = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[topLayout]-(20)-[btnCreateTask]-(20)-[btnCreateStickerTask]-(20)-[btnCreateGPSLocationTask]-(20)-[lblTop]-[tableView]-(20)-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewKeys)
        
        let horizintalTableConstrain = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[tableView]-|", options: [], metrics: nil, views: viewKeys)
        
        let horizintalTopLblConstrain = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[lblTop]-|", options: [], metrics: nil, views: viewKeys)
        
        let _ = lblCount.topAlighnToViewTop(lblTop)
        lblCount.trailingToSuperView(true)
        
        allConstrins += verticalLayout
        allConstrins += horizintalTableConstrain
        allConstrins += horizintalTopLblConstrain
        
        NSLayoutConstraint.activate(allConstrins)
        UIViewAutoLayoutExtentions.centerVerticlyAlViewsInSuperView([activityIndicator])
        UIViewAutoLayoutExtentions.centerVerticalyAlViewsInSuperView([activityIndicator])
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    

    //MARK: TableView
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = self.allTasks[(indexPath as NSIndexPath).row]
        let textForCell = Content.getContent(ContentType.labelTxt, name: "TaskManagerVCTaskNameCell") + " " + task.taskType.name()
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) 
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        cell?.textLabel?.text = textForCell
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator;
        cell?.contentView.backgroundColor = task.isTaskDone ? Colors.lightGreen() : UIColor.white

        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(kCellHeight)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let task = self.allTasks[(indexPath as NSIndexPath).row]
            self.tasksServices.removeTask(task)
            let index = self.allTasks.index(of: task)
            self.allTasks.remove(at: index!)
            self.reloadTable()
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.allTasks.count != 0) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            self.tableView.backgroundView = nil
        } else {
            let lblNoData = UILabel()
            lblNoData.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height)
            lblNoData.text = Content.getContent(ContentType.labelTxt, name: "TaskManagerVCNoTasksAssigened")
            lblNoData.textColor = UIColor.black
            lblNoData.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = lblNoData
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allTasks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.allTasks[(indexPath as NSIndexPath).row]
        self.currenctTaskCreator.setCurrenctTask(task)
        
        let addTaskConfirmationViewController = self.container.resolve(AddTaskConfirmationViewController.self)
        self.navigationController?.pushViewController(addTaskConfirmationViewController!, animated: true)
    }
    
    //MARK: Create task
    
    func createNewStickerTask() {
        self.activityIndicator.startAnimating()
        self.iNearableServices.isThereNearableInErea { (result, nearable) -> Void in
            self.activityIndicator.stopAnimating()
            if result == false {
                self.showNoNearableInEreaMessage()
                return
            }
            
            if self.iNearableServices.isNearableAlreadyHasATaskAssigned(nearable!) == true {
                self.showNearableHasAlreadyTaskAssignedMessage(nearable!)
                return
            }
            
            self.currenctTaskCreator.startNewTask()
            self.currenctTaskCreator.setTaskNearableIdentifer(nearable!.identifier)
            self.goToNextPage()
        }
    }
    
    func createNewTimeTask() {
        self.currenctTaskCreator.startNewTask()
        self.goToNextPage()
    }
    
    //MARK: Alerts
    
    func showNoNearableInEreaMessage() {
        let alert = UIAlertController(title: Content.getContent(ContentType.labelTxt, name: "TaskManagerVCNoNearableInEreas"), message: "", preferredStyle: UIAlertControllerStyle.alert)
        let btnOk = UIAlertAction(title: Content.getContent(ContentType.buttonTxt, name: "Ok"), style: UIAlertActionStyle.cancel) { (action : UIAlertAction) in
        }
        alert.addAction(btnOk)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showNearableHasAlreadyTaskAssignedMessage(_ closestNearable : ESTNearable) {
        let title = Content.getContent(ContentType.labelTxt, name: "TaskManagerVCTheNearableHasTaskAllreadyMessage")
        let btnYesTxt = Content.getContent(ContentType.buttonTxt, name: "Yes")
        let btnNoTxt = Content.getContent(ContentType.buttonTxt, name: "No")
        let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        let btnYes = UIAlertAction(title: btnYesTxt, style: UIAlertActionStyle.default) { (action : UIAlertAction) in
            let task = self.tasksServices.getTaskForNearableIdentifier(closestNearable.identifier)
            self.currenctTaskCreator.setCurrenctTask(task)
            
            self.currenctTaskCreator.startNewTask()
            self.currenctTaskCreator.setTaskNearableIdentifer(closestNearable.identifier)
            self.goToNextPage()
        }
        
        let btnNo = UIAlertAction(title: btnNoTxt, style: UIAlertActionStyle.cancel) { (action : UIAlertAction) in
        }
        alert.addAction(btnNo)
        alert.addAction(btnYes)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Navgiation
    
    func goToNextPage() {
        if let _ = self.addTaskTypeViewController {} else {
            self.addTaskTypeViewController = self.container.resolve(AddTaskTypeViewController.self)
        }
        self.navigationController?.pushViewController(self.addTaskTypeViewController!, animated: true)
    }

    //MARK: Buttons
    func doneButtonPress() {
        if let _ = self.navigationController {
            let _ = self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    

}
