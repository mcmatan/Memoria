
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
    var addTaskVoiceViewController : AddTaskVoiceViewController?
    
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
        self.title = self.currenctTaskCreator.getTaskName()
        if let isTimes = currenctTaskCreator.getTaskTime() {
            self.chosenTime = isTimes as Date
            self.setTimeToDisplay(isTimes as Date)
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
        addTaskBtn.centerVerticlyInSuperView()
    }
    
    
    func addTimeButtonPress() {
        let txt = Content.getContent(ContentType.labelTxt, name: "AddTaskTimeDatePickerDialog")
        let datePicker = DatePickerDialog()
        let minimunDate = Date() + 2.minutes
        datePicker.setMinimunDate(date: minimunDate)
        
        //datePicker.setMinimunDate(date: (Date().minute += 2))
        datePicker.show(txt, datePickerMode: UIDatePickerMode.dateAndTime) { (date) -> Void in
            print(date)
            self.chosenTime = date
            self.setTimeToDisplay(date)
        }
    }
    
    func setTimeToDisplay(_ date : Date) {
        let timeString = date.description(with: Locale.current)
        self.lblTime.text = "\(timeString)"
    }

    func doneBtnPress() {
        
        self.currenctTaskCreator.setTaskTime(self.chosenTime)
    
        if let _ = self.addTaskVoiceViewController {} else {
            self.addTaskVoiceViewController =  self.container.resolve(AddTaskVoiceViewController.self)
        }
        self.navigationController?.pushViewController(self.addTaskVoiceViewController!, animated: true)
        
    }

}
