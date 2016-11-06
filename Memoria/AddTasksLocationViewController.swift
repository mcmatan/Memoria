

import Foundation
import UIKit
import Swinject

class AddTasksLocationViewController : ViewController {
    let container : Container
    let tasksServices : TasksServices
    let iBeaconServices : IBeaconServices
    var currenctTaskCreator : CurrenctTaskCreator
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currenctTaskCreator.startNewTask()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topExpelenationText = Label()
        topExpelenationText.numberOfLines = 0
        topExpelenationText.textAlignment = NSTextAlignment.center
        let txt = Content.getContent(ContentType.labelTxt, name: "TesksFirstExplenation")
        topExpelenationText.text = txt
        let thisIsMyLocation = Button()
        thisIsMyLocation.defaultStyle()
        thisIsMyLocation.setTitle(Content.getContent(ContentType.buttonTxt, name: "ThisIsMyLocationTask"), for: UIControlState())
        thisIsMyLocation.addTarget(self, action: #selector(AddTasksLocationViewController.thisIsMyLocationPress), for: UIControlEvents.touchUpInside)
        let or = Label()
        or.text = Content.getContent(ContentType.labelTxt, name: "or")
        let manageTasks = Button()
        manageTasks.defaultStyle()
        manageTasks.setTitle(Content.getContent(ContentType.buttonTxt, name: "ManageTasks"), for: UIControlState())
        manageTasks.addTarget(self, action: #selector(AddTasksLocationViewController.menageTasksButtonPress), for: UIControlEvents.touchUpInside)
        self.view.addSubview(topExpelenationText)
        self.view.addSubview(thisIsMyLocation)
        self.view.addSubview(or)
        self.view.addSubview(manageTasks)
        thisIsMyLocation.addSubview(activityIndicator)
        
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
        
        let verticalLayout = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[topLayoutGuide]-[topExpelenationText]-[thisIsMyLocation]-[or(topExpelenationText)]-[manageTasks]-[bottomLayoutGuide]"
            , options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        
        let horizintalLayout = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[topExpelenationText]|"
            , options: [], metrics: nil, views: views)
        
        UIViewAutoLayoutExtentions.centerVerticlyAlViewsInSuperView([activityIndicator])
        UIViewAutoLayoutExtentions.centerHorizontalyAlViewsInSuperView([activityIndicator])
        
        allConstrains += verticalLayout
        allConstrains += horizintalLayout
        NSLayoutConstraint.activate(allConstrains)

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
        if let TaskManagerViewController = self.container.resolve(TaskManagerViewController.self) {
            self.navigationController!.pushViewController(TaskManagerViewController, animated: true)
        }
    }
    
    //MARK: Alerts
    
    func showNoBeaconInEreaMessage() {
        let alert = UIAlertController(title: Content.getContent(ContentType.labelTxt, name: "TaskManagerVCNoBeaconInEreas"), message: "", preferredStyle: UIAlertControllerStyle.alert)
        let btnOk = UIAlertAction(title: Content.getContent(ContentType.buttonTxt, name: "Ok"), style: UIAlertActionStyle.cancel) { (action : UIAlertAction) in
        }
        alert.addAction(btnOk)
        self.present(alert, animated: true, completion: nil)

    }
    
    func showBeaconHasAlreadyTaskAssignedMessage(_ closestBeacon : CLBeacon) {
        let closeiBeaconIdentifier = IBeaconIdentifier.creatFromCLBeacon(closestBeacon)
        
        let alert = UIAlertController(title: "The beacon you have selected \(closeiBeaconIdentifier.major), already has a task assigend to it", message: "Do you want to edit the task?", preferredStyle: UIAlertControllerStyle.alert)
        let btnYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { (action : UIAlertAction) in
            let task = self.tasksServices.getTaskForIBeaconIdentifier(closeiBeaconIdentifier)
            self.currenctTaskCreator.setCurrenctTask(task)
            self.goToNextPage(closestBeacon)
        }
        
        let btnNo = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) { (action : UIAlertAction) in
        }
        alert.addAction(btnNo)
        alert.addAction(btnYes)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Navgiation
    
    func goToNextPage(_ closestBeacon : CLBeacon) {
        let closeiBeaconIdentifier = IBeaconIdentifier.creatFromCLBeacon(closestBeacon)
        self.currenctTaskCreator.setTaskBeaconIdentifier(closeiBeaconIdentifier)
        
        if let _ = self.addTaskNameViewController {} else {
            self.addTaskNameViewController = self.container.resolve(AddTaskNameViewController.self)
        }
        self.navigationController?.pushViewController(self.addTaskNameViewController!, animated: true)

    }
}
