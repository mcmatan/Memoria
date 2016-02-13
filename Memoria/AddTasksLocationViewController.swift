

import Foundation
import UIKit
import Swinject

class AddTasksLocationViewController : ViewController {
    let container : Container
    let tasksServices : TasksServices
    let iBeaconServices : IBeaconServices
    var currenctTaskCreator : CurrenctTaskCreator
    var addTaskNameViewController : AddTaskNameViewController?
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    init(container : Container, tasksServices : TasksServices, iBeaconServices : IBeaconServices, currenctTaskCreator : CurrenctTaskCreator) {
        self.container = container
        self.tasksServices = tasksServices
        self.iBeaconServices = iBeaconServices
        self.currenctTaskCreator = currenctTaskCreator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.currenctTaskCreator.startNewTask()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        
        let topExpelenationText = Label()
        topExpelenationText.numberOfLines = 0
        topExpelenationText.textAlignment = NSTextAlignment.Center
        let txt = Content.getContent(ContentType.LabelTxt, name: "TesksFirstExplenation")
        topExpelenationText.text = txt
        let thisIsMyLocation = Button()
        thisIsMyLocation.defaultStyle()
        thisIsMyLocation.setTitle(Content.getContent(ContentType.ButtonTxt, name: "ThisIsMyLocationTask"), forState: UIControlState.Normal)
        thisIsMyLocation.addTarget(self, action: "thisIsMyLocationPress", forControlEvents: UIControlEvents.TouchUpInside)
        let or = Label()
        or.text = Content.getContent(ContentType.LabelTxt, name: "or")
        let manageTasks = Button()
        manageTasks.defaultStyle()
        manageTasks.setTitle(Content.getContent(ContentType.ButtonTxt, name: "ManageTasks"), forState: UIControlState.Normal)
        manageTasks.addTarget(self, action: "menageTasksButtonPress", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(topExpelenationText)
        self.view.addSubview(thisIsMyLocation)
        self.view.addSubview(or)
        self.view.addSubview(manageTasks)
        
        topExpelenationText.translatesAutoresizingMaskIntoConstraints = false
        thisIsMyLocation.translatesAutoresizingMaskIntoConstraints = false
        or.translatesAutoresizingMaskIntoConstraints = false
        manageTasks.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let topLayoutGuide = self.topLayoutGuide
        let bottomLayoutGuide = self.bottomLayoutGuide
        
        let views : [String : AnyObject] =
        ["topExpelenationText" : topExpelenationText,
            "thisIsMyLocation" : thisIsMyLocation,
            "or" : or,
            "manageTasks" : manageTasks,
            "topLayoutGuide" : topLayoutGuide,
            "bottomLayoutGuide" : bottomLayoutGuide
        ]
        
        var allConstrains = [NSLayoutConstraint]()
        
        let verticalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[topLayoutGuide]-[topExpelenationText]-[thisIsMyLocation]-[or(topExpelenationText)]-[manageTasks]-[bottomLayoutGuide]"
            , options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: views)
        
        let horizintalLayout = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|[topExpelenationText]|"
            , options: [], metrics: nil, views: views)
        
        UIViewAutoLayoutExtentions.centerVerticlyAlViewsInSuperView([activityIndicator])
        UIViewAutoLayoutExtentions.centerHorizontalyAlViewsInSuperView([activityIndicator])
        
        allConstrains += verticalLayout
        allConstrains += horizintalLayout
        NSLayoutConstraint.activateConstraints(allConstrains)

    }
    
    //MARK: Buttons presses
    

    func thisIsMyLocationPress() {
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
    
    func menageTasksButtonPress() {
        if let manageAddTasksLocationViewController = self.container.resolve(ManageAddTasksLocationViewController.self) {
            self.navigationController!.pushViewController(manageAddTasksLocationViewController, animated: true)
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
        self.currenctTaskCreator.setTaskBeaconIdentifier(closeiBeaconIdentifier)
        
        if let _ = self.addTaskNameViewController {} else {
            self.addTaskNameViewController = self.container.resolve(AddTaskNameViewController.self)
        }
        self.navigationController?.pushViewController(self.addTaskNameViewController!, animated: true)

    }
}
