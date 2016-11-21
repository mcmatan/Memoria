
import Foundation
import UIKit
import Swinject
import SwiftDate

class AddTaskTimeViewController : ViewController {
    var cellIdentifier = "cell"
    var lblTime  = Label()
    var container : Container
    var chosenTime = Date()
    var currenctTaskCreator : CurrenctTaskCreator
    var addTaskTimePriorityController : AddTaskTimePriorityController?
    
    init(container : Container, currenctTaskCreator : CurrenctTaskCreator) {
        self.container = container
        self.currenctTaskCreator = currenctTaskCreator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.currenctTaskCreator.task.taskType.name()
        if let isTimes = currenctTaskCreator.getTaskTime() {
            self.chosenTime = isTimes as Date
            self.setTimeToDisplay(isTimes as Date)
        }else {
            let minumunDate = self.getMinimunDate()
            self.chosenTime = minumunDate as Date
            self.setTimeToDisplay(minumunDate as Date)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addTaskBtn = Button()
        addTaskBtn.setTitle(Content.getContent(ContentType.labelTxt, name: "addTaskTimeButton"), for: UIControlState())
        addTaskBtn.defaultStyle()
        addTaskBtn.addTarget(self, action: #selector(AddTaskTimeViewController.addTimeButtonPress), for: UIControlEvents.touchUpInside)
        let doneBtn = Button()
        doneBtn.setTitle(Content.getContent(ContentType.labelTxt, name: "addTimeDoneBtn"), for: UIControlState())
        doneBtn.addTarget(self, action: #selector(AddTaskTimeViewController.doneBtnPress), for: UIControlEvents.touchUpInside)
        doneBtn.defaultStyle()
    
        self.lblTime.font = UIFont.systemFont(ofSize: 25)
        self.lblTime.textAlignment = NSTextAlignment.center
        self.lblTime.numberOfLines = 0
        
        self.view.addSubview(addTaskBtn)
        self.view.addSubview(self.lblTime)
        self.view.addSubview(doneBtn)

        
        addTaskBtn.translatesAutoresizingMaskIntoConstraints = false
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        self.lblTime.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [doneBtn, addTaskBtn,lblTime] as [Any]
        let viewsInfoDic : [String : AnyObject] =
        [
            "addTaskBtn" : addTaskBtn,
            "doneBtn" : doneBtn,
            "lblTime" : self.lblTime
        ]
        

        UIViewAutoLayoutExtentions.equalWidthsForViews(views as! [UIView])
        
        let verticalLayout = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[addTaskBtn]-[doneBtn]-[lblTime]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: viewsInfoDic)
        NSLayoutConstraint.activate(verticalLayout)
        
        addTaskBtn.topToViewControllerTopLayoutGuide(self, offset: 20)
        addTaskBtn.centerHorizontlyInSuperView()
    }
    
    
    func addTimeButtonPress() {
        
        let minimunDate = self.getMinimunDate()
        let txt = Content.getContent(ContentType.labelTxt, name: "AddTaskTimeDatePickerDialog")
        let datePicker = DatePickerDialog()
        
        datePicker.show(txt, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", defaultDate: minimunDate, datePickerMode: UIDatePickerMode.time) { (date) in
            print(date)
            self.chosenTime = self.getRoundedSecoundsDate(date: date)
            self.setTimeToDisplay(date)
        }
    }
    
    func getRoundedSecoundsDate(date: Date)->Date {
        var dateRounded = NSDate();
        let timeInterval = floor(dateRounded.timeIntervalSinceReferenceDate / 60.0) * 60.0
        dateRounded = Date(timeIntervalSinceReferenceDate: timeInterval) as NSDate
        return dateRounded as Date
    }
    
    func getMinimunDate() ->Date {
        let minumTimeFromNowByMinutes = 2 // This is a hack, the date picker works wrong after setting minumun time.
        let minimunDate = Date() + minumTimeFromNowByMinutes.minutes
        return minimunDate
    }
    
    func setTimeToDisplay(_ date : Date) {
        let timeString = date.toStringCurrentRegionShortTime()
        self.lblTime.text = "\(timeString)"
    }

    func doneBtnPress() {
        
        self.currenctTaskCreator.setTaskTime(self.chosenTime)
    
        if let _ = self.addTaskTimePriorityController {} else {
            self.addTaskTimePriorityController =  self.container.resolve(AddTaskTimePriorityController.self)
        }
        self.navigationController?.pushViewController(self.addTaskTimePriorityController!, animated: true)
    }

}
